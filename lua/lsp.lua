local M = {}

--vim.lsp.set_log_level("trace")

local lsp_float_opts = {
  wrap = true,
  max_width = 100,
}

M.capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
M.keymap_opts = { buffer = true, noremap = true, silent = true }

local function get_ra_runnable_range(lens)
  local arguments = (lens.command.arguments or {})[1]
  local targetRange = arguments and arguments.location and arguments.location.targetRange
  if not targetRange then
    return -1, -1
  end
  return targetRange['start'].line, targetRange['end'].line
end

local function codelenses_on(pos)
  local position = vim.fn.getpos(pos)
  local bufnr = position[1]
  local row = position[2] - 1

  local lenses = {}
  for _, lens in ipairs(vim.lsp.codelens.get(bufnr)) do
    if not lens.command or lens.command.command == '' then
      goto continue
    end
    local raStart, raEnd = get_ra_runnable_range(lens)
    if lens.range and lens.range.start.line == row then
      -- highest priority for lenses on current line
      table.insert(lenses, { lens, prio = -1, bufnr = bufnr })
    elseif raStart <= row and row <= raEnd then
      local size = raEnd - raStart
      -- lower priority for larger range (prefer local lenses)
      table.insert(lenses, { lens, prio = size, bufnr = bufnr })
    end
    ::continue::
  end
  table.sort(lenses, function(a, b)
    return a.prio < b.prio
  end)
  return lenses
end

local ms = require('vim.lsp.protocol').Methods
local function execute_lens(lens, bufnr)
  -- execute for all clients attached to the current buffer, because we don't know which client the
  -- lens comes from; inappropriate LSP seem to just ignore the request.
  for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    vim.notify('excuting on ' .. client.name)
    client:exec_cmd(lens.command, { bufnr = bufnr }, function(...)
      vim.lsp.handlers[ms.workspace_executeCommand](...)
      vim.lsp.codelens.refresh()
    end)
  end
end

local function extended_codelens_run_on(pos)
  local options = codelenses_on(pos)
  if #options == 0 then
    vim.notify('No executable codelens found for current line')
  elseif #options == 1 then
    local lens = options[1]
    execute_lens(lens[1], lens.bufnr)
  else
    vim.ui.select(options, {
      prompt = 'Code lenses:',
      kind = 'codelens',
      format_item = function(option)
        local format = option[1].command.title
        local arguments = option[1].command.arguments
        local argument = arguments and arguments[1]
        local raLabel = argument and argument.label
        if raLabel and argument.kind then
          raLabel = argument.kind .. " " .. raLabel
        end
        if raLabel then
          format = raLabel .. " [" .. format .. "]"
        end
        return format
      end,
    }, function(lens)
      if lens then
        execute_lens(lens[1], lens.bufnr)
      end
    end)
  end
end

local function smart_codelens_run()
  local expr = vim.v.register == '"' and "." or "'" .. vim.v.register
  extended_codelens_run_on(expr)
end

M.on_attach = function(client)
  local snacks = require('snacks')
  -- code navigation shortcuts
  vim.keymap.set('n', 'gd', snacks.picker.lsp_definitions, M.keymap_opts)
  vim.keymap.set('n', 'gD', snacks.picker.lsp_declarations, M.keymap_opts)
  vim.keymap.set('n', 'gr', snacks.picker.lsp_references, M.keymap_opts)
  vim.keymap.set('n', 'gi', snacks.picker.lsp_implementations, M.keymap_opts)
  -- docs and info
  vim.keymap.set('n', 'K', function() vim.lsp.buf.hover(lsp_float_opts) end, M.keymap_opts)
  vim.keymap.set({ 'n', 'v', 'i' }, '<C-l>', function() vim.lsp.buf.signature_help(lsp_float_opts) end, M.keymap_opts)
  vim.keymap.set('n', 'gt', snacks.picker.lsp_type_definitions, M.keymap_opts)
  -- action shortcuts (code actions are implemented in actions_preview.lua
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, M.keymap_opts)
  vim.keymap.set('n', 'gC', smart_codelens_run, M.keymap_opts)

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
    vim.api.nvim_clear_autocmds { buffer = 0, group = "lsp_document_highlight" }
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = vim.lsp.buf.document_highlight,
      group = "lsp_document_highlight",
      desc = "Document Highlight",
      buffer = 0,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = vim.lsp.buf.clear_references,
      group = "lsp_document_highlight",
      desc = "Clear All the References",
      buffer = 0,
    })
  end

  if client.server_capabilities.codeLensProvider then
    vim.lsp.codelens.refresh()
    vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
      callback = vim.lsp.codelens.refresh,
      desc = "Refresh codelens",
      buffer = 0,
    })
  end

  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_buf_create_user_command(0, 'Fmt', function()
      vim.lsp.buf.format()
    end, {})
  end
end

local caps_for_jsonls = vim.lsp.protocol.make_client_capabilities()
caps_for_jsonls.textDocument.completion.completionItem.snippetSupport = true

require('utils').setup_lsps(
  { capabilities = M.capabilities, on_attach = M.on_attach },
  {
    'bashls',
    {
      'clangd',
      filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }
    },
    'cssls',
    'docker_compose_language_service',
    'dockerls',
    {
      'eslint',
      cmd = { "eslint", "--stdio" },
    },
    'fsautocomplete',
    {
      'gopls',
      settings = {
        gopls = {
          codelenses = {
            test = true,
          },
        },
      },
    },
    'hls',
    'jqls',
    {
      'jsonls',
      capabilities = caps_for_jsonls,
      cmd = { "vscode-json-languageserver", "--stdio" },
    },
    'lua_ls',
    'marksman',
    {
      'nixd',
      settings = {
        nixd = {
          formatting = {
            command = { "nixfmt" },
          },
        },
      }
    },
    'postgres_lsp',
    {
      'protols',
      root_markers = { "protols.toml", ".git" },
    },
    'pyright',
    'ruff',
    'taplo',
    'ts_ls',
    'vacuum',
    'vimls',
    'yamlls',
  }
)

return M

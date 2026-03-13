return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    "L3MON4D3/LuaSnip",
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'zjp-CN/nvim-cmp-lsp-rs',
  },
  config = function()
    local cmp = require('cmp')
    local border = require('border')

    ---@param entry cmp.Entry
    ---@return string|nil
    local function lsp_client_name(entry)
      local source = entry.source and entry.source.source
      local client = source and source.client
      return client and client.config and client.config.name or nil
    end

    --- Return a cmp comparator that enforces a relative ordering for entries whose
    --- mapped keys are both present in `expected_order`.
    ---
    --- If either entry maps to a value outside `expected_order`, or both map to the
    --- same position, the comparator returns `nil` so later comparators can decide.
    ---
    ---@generic T
    ---@param key_fn fun(entry: cmp.Entry): T|nil Maps an entry to the value used for ordering.
    ---@param expected_order T[] Earlier items have higher priority.
    ---@return fun(entry1: cmp.Entry, entry2: cmp.Entry): boolean|nil
    local function enforce_order(key_fn, expected_order)
      ---@type table<any, integer>
      local positions = {}

      for index, value in ipairs(expected_order) do
        positions[value] = index
      end

      return function(a, b)
        local key_a = key_fn(a)
        local key_b = key_fn(b)
        local pos1 = key_a and positions[key_a] or nil
        local pos2 = key_b and positions[key_b] or nil

        if pos1 and pos2 and pos1 ~= pos2 then
          return pos1 > pos2
        end
        return nil
      end
    end

    local kind_icons = {
      Text = "󰦨",
      Method = "󰫺",
      Function = "󰊕",
      Constructor = "",
      Field = "",
      Variable = "󰫧",
      Class = "",
      Interface = "",
      Module = "",
      Property = "",
      Unit = "",
      Value = "󰎠",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "󰸌",
      File = "󰈙",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "",
      Event = "",
      Operator = "󰐙",
      TypeParameter = "󰊄",
    }

    cmp.setup({
      snippet = {
        expand = function(args)
          require 'luasnip'.lsp_expand(args.body)
        end
      },
      window = {
        completion = {
          winhighlight = 'CursorLine:FloatVisual,Search:None',
          scrolloff = 1,
          side_padding = 1,
          border = border.round,
        },
        documentation = {
          winhighlight = 'CursorLine:FloatVisual,Search:None',
          border = border.round,
        },
      },
      completion = {
        autocomplete = false,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable,
        ['<C-e>'] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
      }),
      sorting = {
        priority_weight = 100,
        comparators = {
          enforce_order(lsp_client_name, { 'crates.nvim', 'taplo' }),
          require('cmp_lsp_rs').comparators.inscope_inherent_import,
          cmp.config.compare.score,
        },
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }),
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
          vim_item.menu = (({
            nvim_lsp = "[lsp]",
            luasnip = "[snip]",
            buffer = "[buf]",
          })[entry.source.name] or "") .. " " .. (vim_item.menu or "")
          return vim_item
        end,
      },
      experimental = {
        -- workaround from https://github.com/hrsh7th/nvim-cmp/issues/1573
        ghost_text = {
          hl_group = 'Comment',
        },
      },
    })

    vim.opt.completeopt = "menu,menuone,noselect"
  end
}

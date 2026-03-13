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
    local function get_lsp_client_name(entry)
      local source = entry.source and entry.source.source
      local client = source and source.client
      return client and client.config and client.config.name or nil
    end

    ---@param entry1 cmp.Entry
    ---@param entry2 cmp.Entry
    local function compare_crates_before_taplo(entry1, entry2)
      local client1 = get_lsp_client_name(entry1)
      local client2 = get_lsp_client_name(entry2)

      if client1 == 'crates.nvim' and client2 == 'taplo' then
        return true
      end
      if client1 == 'taplo' and client2 == 'crates.nvim' then
        return false
      end
      return nil
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
          compare_crates_before_taplo,
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

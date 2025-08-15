return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'zjp-CN/nvim-cmp-lsp-rs',
  },
  config = function()
    local cmp = require('cmp')
    local border = require('border')

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
      window = {
        completion = {
          winhighlight = 'CursorLine:FloatVisual,Search:None',
          scrolloff = 1,
          side_padding = 1,
          border = border,
        },
        documentation = {
          winhighlight = 'CursorLine:FloatVisual,Search:None',
          border = border,
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
          require('cmp_lsp_rs').comparators.inscope_inherent_import,
          cmp.config.compare.score,
        },
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
      }),
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
          vim_item.menu = (({
            nvim_lsp = "[lsp]",
            vsnip = "[snip]",
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

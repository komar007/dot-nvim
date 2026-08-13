return {
  'poljar/typos.nvim',
  config = function()
    require('typos').setup()

    local typos_ns = vim.api.nvim_create_namespace('typos')
    local group = vim.api.nvim_create_augroup('typos-readonly-diagnostics', { clear = true })
    vim.api.nvim_create_autocmd('DiagnosticChanged', {
      group = group,
      callback = function(args)
        if vim.bo[args.buf].readonly and #vim.diagnostic.get(args.buf, { namespace = typos_ns }) > 0 then
          vim.diagnostic.reset(typos_ns, args.buf)
        end
      end,
    })
  end,
}

local function repeatable_move()
  return require('nvim-treesitter-textobjects.repeatable_move')
end

local function tsto_select(obj)
  return function()
    return require('nvim-treesitter-textobjects.select').select_textobject(obj, "textobjects")
  end
end

local function tsto_goto_next_start(obj)
  return function()
    return require('nvim-treesitter-textobjects.move').goto_next_start(obj, "textobjects")
  end
end
local function tsto_goto_next_end(obj)
  return function()
    return require('nvim-treesitter-textobjects.move').goto_next_end(obj, "textobjects")
  end
end
local function tsto_goto_previous_start(obj)
  return function()
    return require('nvim-treesitter-textobjects.move').goto_previous_start(obj, "textobjects")
  end
end
local function tsto_goto_previous_end(obj)
  return function()
    return require('nvim-treesitter-textobjects.move').goto_previous_end(obj, "textobjects")
  end
end

return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  lazy = false,
  init = function()
    vim.g.no_plugin_maps = true
  end,
  opts = {
    select = {
      lookahead = true,
    },
    move = {
      set_jumps = true,
    },
  },
  keys = function()
    return {
      { "][", tsto_goto_next_start("@function.inner"),                      mode = { "n", "x", "o" } },
      { "]{", tsto_goto_next_start("@function.outer"),                      mode = { "n", "x", "o" } },
      { "]a", tsto_goto_next_start("@parameter.inner"),                     mode = { "n", "x", "o" } },
      { "]s", tsto_goto_next_start("@class.inner"),                         mode = { "n", "x", "o" } },

      { "]]", tsto_goto_next_end("@function.inner"),                        mode = { "n", "x", "o" } },
      { "]}", tsto_goto_next_end("@function.outer"),                        mode = { "n", "x", "o" } },
      { "]b", tsto_goto_next_end("@block.inner"),                           mode = { "n", "x", "o" } },
      { "]B", tsto_goto_next_end("@block.outer"),                           mode = { "n", "x", "o" } },
      { "]A", tsto_goto_next_end("@parameter.inner"),                       mode = { "n", "x", "o" } },
      { "]S", tsto_goto_next_end("@class.inner"),                           mode = { "n", "x", "o" } },

      { "[[", tsto_goto_previous_start("@function.inner"),                  mode = { "n", "x", "o" } },
      { "[{", tsto_goto_previous_start("@function.outer"),                  mode = { "n", "x", "o" } },
      { "[b", tsto_goto_previous_start("@block.inner"),                     mode = { "n", "x", "o" } },
      { "[B", tsto_goto_previous_start("@block.outer"),                     mode = { "n", "x", "o" } },
      { "[a", tsto_goto_previous_start("@parameter.inner"),                 mode = { "n", "x", "o" } },
      { "[s", tsto_goto_previous_start("@class.inner"),                     mode = { "n", "x", "o" } },

      { "[]", tsto_goto_previous_end("@function.inner"),                    mode = { "n", "x", "o" } },
      { "[}", tsto_goto_previous_end("@function.outer"),                    mode = { "n", "x", "o" } },
      { "[A", tsto_goto_previous_end("@parameter.inner"),                   mode = { "n", "x", "o" } },
      { "[S", tsto_goto_previous_end("@class.inner"),                       mode = { "n", "x", "o" } },

      { "af", tsto_select("@function.outer"),                               mode = { "x", "o" } },
      { "if", tsto_select("@function.inner"),                               mode = { "x", "o" } },
      { "aa", tsto_select("@parameter.outer"),                              mode = { "x", "o" } },
      { "ia", tsto_select("@parameter.inner"),                              mode = { "x", "o" } },
      { "ac", tsto_select("@class.outer"),                                  mode = { "x", "o" } },
      { "ic", tsto_select("@class.inner"),                                  mode = { "x", "o" } },

      { ";",  function() repeatable_move().repeat_last_move() end,          mode = { "n", "x", "o" } },
      { ",",  function() repeatable_move().repeat_last_move_opposite() end, mode = { "n", "x", "o" } },

      { "f",  function() return repeatable_move().builtin_f_expr() end,     mode = { "n", "x", "o" }, expr = true },
      { "F",  function() return repeatable_move().builtin_F_expr() end,     mode = { "n", "x", "o" }, expr = true },
      { "t",  function() return repeatable_move().builtin_t_expr() end,     mode = { "n", "x", "o" }, expr = true },
      { "T",  function() return repeatable_move().builtin_T_expr() end,     mode = { "n", "x", "o" }, expr = true },
    }
  end
}

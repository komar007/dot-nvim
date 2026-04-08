return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  opts = {
    heading = {
      sign = false,
      position = 'overlay',
      width = 'block',
      min_width = 79,
      backgrounds = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      },
      icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " }
    },
    code = {
      sign = false,
      width = 'block',
      position = 'right',
      min_width = 79,
      language_border = ' ',
      language_left = '█',
      language_right = '█',
    },
    dash = {
      width = 79,
    },
    pipe_table = {
      preset = 'round',
      alignment_indicator = '○',
    },
    overrides = {
      buftype = {
        nofile = {
          win_options = {
            concealcursor = {
              rendered = "nc",
            },
          },
        },
      },
    },
  },
}

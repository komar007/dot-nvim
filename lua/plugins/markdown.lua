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
      min_width = 79,
    },
    dash = {
      width = 79,
    },
  },
}

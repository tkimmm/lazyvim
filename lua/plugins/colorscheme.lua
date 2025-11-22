return {
  -- { "ellisonleao/gruvbox.nvim" },
  -- { "nyoom-engineering/oxocarbon.nvim" },
  -- { "ellisonleao/gruvbox.nvim", priority = 1000, config = true, opts = ... },
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "gruvbox",
      -- colorscheme = "nightfox",
      colorscheme = "catppuccin",
      -- colorscheme = "oxocarbon",
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = true,
        background = {
          light = "latte",
          dark = "mocha",
        },
        show_end_of_buffer = false,
        term_colors = false,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {},
        custom_highlights = function(colors)
          return {
            LineNr = { fg = colors.yellow, bold = true },
            LineNrBelow = { fg = colors.subtext0, bold = false },
            LineNrAbove = { fg = colors.subtext0, bold = false },
          }
        end,
        integrations = {
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          notify = true,
          mini = true,
          neotree = false,
          dap = true,
          fzf = true,
          -- blink = true,
          -- cmp = true,
        },
      })

      local sign = vim.fn.sign_define
      sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
    end,
  },
}

return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local bufferline = require("bufferline")
    bufferline.setup({
      options = {
        style_preset = bufferline.style_preset.minimal,
        offsets = {
          {
            filetype = "NvimTree",
            text = "",
            separator = true,
            text_align = "left",
          },
        },
        diagnostics = "nvim_lsp",
        separator_style = { "", "" },
        modified_icon = "●",
        show_close_icon = false,
        show_buffer_close_icons = false,
      },
    })
  end,
}

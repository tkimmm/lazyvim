return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    opts = {},
    keys = {
      {
        "<C-p>",
        function()
          require("fzf-lua").files({
            hidden = true,
            no_ignore = true,
            layout = "default",
          })
        end,
      },
      {
        "<C-f>",
        function()
          require("fzf-lua").blines({
            layout = "default",
          })
        end,
      },
    },
  },
}

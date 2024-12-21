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
          })
        end,
      },
    },
  },
}

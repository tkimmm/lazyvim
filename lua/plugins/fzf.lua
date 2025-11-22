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
            fd_opts = "--hidden --no-ignore --exclude node_modules --exclude .git --exclude dist",
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

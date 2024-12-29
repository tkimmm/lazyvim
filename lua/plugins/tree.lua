-- Old tree config
-- local HEIGHT_RATIO = 0.8 -- You can change this
-- local WIDTH_RATIO = 0.5

-- return {
--   "nvim-tree/nvim-tree.lua",
--   version = "*",
--   dependencies = {
--     "nvim-tree/nvim-web-devicons",
--   },
--   keys = {
--     { "_", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Tree toggle", { silent = true } },
--   },
--   config = function()
--     local tree_api = require("nvim-tree")
--     local tree_view = require("nvim-tree.view")
--
--     vim.api.nvim_create_augroup("NvimTreeResize", {
--       clear = true,
--     })
--
--     vim.api.nvim_create_autocmd({ "VimResized" }, {
--       group = "NvimTreeResize",
--       callback = function()
--         if tree_view.is_visible() then
--           tree_view.close()
--         end
--       end,
--     })
--
--     local api = require("nvim-tree.api")
--     api.events.subscribe(api.events.Event.FileCreated, function(file)
--       vim.cmd("edit " .. file.fname)
--     end)
--
--     require("nvim-tree").setup({
--       live_filter = {
--         prefix = "[FILTER]: ",
--         always_show_folders = false, -- Turn into false from true by default
--       },
--       -- view = {
--       -- width = 35,
--       -- signcolumn = "yes",
--       -- },
--       view = {
--         float = {
--           enable = true,
--           open_win_config = function()
--             local screen_w = vim.opt.columns:get()
--             local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
--             local window_w = screen_w * WIDTH_RATIO
--             local window_h = screen_h * HEIGHT_RATIO
--             local window_w_int = math.floor(window_w)
--             local window_h_int = math.floor(window_h)
--             local center_x = (screen_w - window_w) / 2
--             local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
--             return {
--               border = "rounded",
--               relative = "editor",
--               row = center_y,
--               col = center_x,
--               width = window_w_int,
--               height = window_h_int,
--             }
--           end,
--         },
--         width = function()
--           return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
--         end,
--       },
--       renderer = {
--         group_empty = true, -- default: true. Compact folders that only contain a single folder into one node in the file tree.
--         highlight_git = false,
--         full_name = true,
--         highlight_opened_files = "icon", -- "none" (default), "icon", "name" or "all"
--         highlight_modified = "icon",     -- "none", "name" or "all". Nice and subtle, override the open icon
--         root_folder_label = ":~:s?$?/..?",
--         indent_width = 2,
--         indent_markers = {
--           enable = false,
--           inline_arrows = true,
--           icons = {
--             corner = "└",
--             edge = "│",
--             item = "│",
--             bottom = "─",
--             none = " ",
--           },
--         },
--         icons = {
--           -- webdev_colors = true,
--           git_placement = "before",
--           modified_placement = "after",
--           padding = " ",
--           symlink_arrow = " ➛ ",
--           show = {
--             file = true,
--             folder = true,
--             folder_arrow = true,
--             git = true,
--             modified = true,
--           },
--           glyphs = {
--             default = "",
--             symlink = "",
--             bookmark = "",
--             modified = "",        -- default: ● - Rather change background color
--             folder = {
--               arrow_closed = "-", -- default: "",
--               arrow_open = "+",   -- default: "",
--               default = "",
--               open = "",
--               empty = "",
--               empty_open = "",
--               symlink = "",
--               symlink_open = "",
--             },
--             git = {
--               unstaged = "✗",
--               staged = "✓",
--               unmerged = "",
--               renamed = "➜",
--               untracked = "★",
--               deleted = "",
--               ignored = "◌",
--             },
--           },
--         },
--         special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
--         symlink_destination = true,
--       },
--       modified = {
--         enable = true,
--         show_on_dirs = true,
--         show_on_open_dirs = false,
--       },
--       filters = {
--         dotfiles = false,
--         git_clean = false,
--         no_buffer = false,
--         custom = {},
--         exclude = {},
--       },
--       git = {
--         enable = false, -- default: true, however on large git project becomes very slow
--       },
--     })
--   end,
-- }

return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      "_",
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
    -- {
    --   -- Open in the current working directory
    --   "<leader>cw",
    --   "<cmd>Yazi cwd<cr>",
    --   desc = "Open the file manager in nvim's working directory" ,
    -- },
    -- {
    --   -- NOTE: this requires a version of yazi that includes
    --   -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
    --   "<c-up>",
    --   "<cmd>Yazi toggle<cr>",
    --   desc = "Resume the last yazi session",
    -- },
  },
  ---@type YaziConfig
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    keymaps = {
      show_help = "g?",
    },
  },
}

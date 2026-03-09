local prefix = "<Leader>a"
return {
  {
    "zbirenbaum/copilot.lua",
    opts = function(_, opts)
      opts.suggestion = opts.suggestion or {}
      opts.suggestion.debounce = 200
      opts.suggestion.auto_trigger = false
      opts.suggestion.enabled = false
      return opts
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    version = "^18.0.0",
    lazy = false,
    opts = {
      adapters = {
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = {
              api_key = "GEMINI_API_KEY",
            },
          })
        end,
      },
      display = {
        diff = {},
      },
      interactions = {
        chat = {
          adapter = "gemini", -- switched from "gemini" to "copilot"
          model = "gemini-2.5-flash",
          variables = {
            ["buffer"] = {
              opts = {
                default_params = "diff",
              },
            },
          },
          tools = {
            opts = {
              default_tools = {
                "files",
              },
            },
          },
        },
        inline = {
          adapter = "gemini",
          model = "gemini-2.5-flash",
          -- adapter = "copilot",
          keymaps = {
            accept_change = {
              modes = { n = "gda" },
            },
            reject_change = {
              modes = { n = "gdr" },
            },
            always_accept = {
              modes = { n = "gdA" },
            },
          },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)
      vim.keymap.set({ "n", "v" }, prefix .. "a", function()
        require("codecompanion").toggle({ window_opts = { width = 0.3 } })
      end, {
        noremap = true,
        silent = true,
        desc = "Toggle CodeCompanion chat",
      })
      vim.keymap.set({ "n", "v" }, prefix .. "s", "<cmd>CodeCompanionChat Add<cr>", {
        noremap = true,
        silent = true,
        desc = "Add buffer/selection to chat",
      })
    end,
  },
  {
    "saghen/blink.cmp",
    opts_extend = { "sources.default" },
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or {}
      opts.sources.providers = opts.sources.providers or {}

      table.insert(opts.sources.default, "codecompanion")

      opts.sources.providers.codecompanion = {
        name = "CodeCompanion",
        module = "codecompanion.providers.completion.blink",
      }

      opts.sources.per_filetype = opts.sources.per_filetype or {}
      opts.sources.per_filetype.codecompanion = { "codecompanion" }

      return opts
    end,
  },
  {
    "NickvanDyke/opencode.nvim", -- AI-powered code assistant with chat interface
    dependencies = {
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      -- Configure opencode with empty options table
      vim.g.opencode_opts = {}

      -- Auto-reload files when changed externally (useful for AI edits)
      vim.o.autoread = true

      -- Quick AI query: Ask question with current context
      vim.keymap.set({ "n", "x" }, prefix .. "q", function()
        require("opencode").ask("@this: ", { subqmit = true })
      end, { desc = "Ask opencode" })

      -- Show action menu with available AI commands
      vim.keymap.set({ "n", "x" }, prefix .. "x", function()
        require("opencode").select()
      end, { desc = "Execute opencode action…" })

      -- Toggle AI chat window visibility
      vim.keymap.set({ "n", "t" }, prefix .. "t", function()
        require("opencode").toggle({ context = { file = vim.api.nvim_buf_get_name(0) } })
      end, { desc = "Toggle opencode (with file context)" })

      -- Add text selection to AI context (use with motions: <leader>ajip, <leader>aj}, etc.)
      vim.keymap.set({ "n", "x" }, prefix .. "j", function()
        return require("opencode").operator("@this ")
      end, { expr = true, desc = "Add range to opencode" })

      -- Add current line to AI context
      vim.keymap.set("n", prefix .. "J", function()
        return require("opencode").operator("@this ") .. "_"
      end, { expr = true, desc = "Add line to opencode" })

      -- Scroll up in AI chat window
      vim.keymap.set("n", prefix .. "u", function()
        require("opencode").command("session.half.page.up")
      end, { desc = "opencode half page up" })

      -- Scroll down in AI chat window
      vim.keymap.set("n", prefix .. "k", function()
        require("opencode").command("session.half.page.down")
      end, { desc = "opencode half page down" })

      -- Number manipulation shortcuts
      vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
      vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
    end,
  },
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  config = function()
    require("claude-code").setup()
  end,
}

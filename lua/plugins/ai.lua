local prefix = "<Leader>a"
return {
  {
    "zbirenbaum/copilot.lua",
    opts = function(_, opts)
      opts.suggestion = opts.suggestion or {}
      opts.suggestion.debounce = 200
      return opts
    end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = true,
    version = false, -- set this if you want to always pull the latest change
    config = function(_, opts)
      _G.toggle_ai_provider = function()
        local current_provider = vim.g.avante_current_provider or "copilot"
        local new_provider = current_provider == "copilot" and "ollama" or "copilot"
        vim.g.avante_current_provider = new_provider
        vim.cmd("AvanteSwitchProvider " .. new_provider)
      end
      vim.api.nvim_create_user_command("AvanteToggleProvider", function()
        _G.toggle_ai_provider()
      end, {})
      vim.keymap.set("n", prefix .. "p", _G.toggle_ai_provider, { desc = "Toggle between Ollama and Copilot" })
      require("avante").setup(opts)
    end,
    opts = {
      -- add any opts here
      mappings = {
        ask = prefix .. "<CR>",
        edit = prefix .. "e",
        refresh = prefix .. "r",
        focus = prefix .. "f",
        toggle = {
          default = prefix .. "a",
          debug = prefix .. "d",
          hint = prefix .. "h",
          suggestion = prefix .. "s",
          repomap = prefix .. "R",
        },
        diff = {
          next = "]c",
          prev = "[c",
        },
        files = {
          add_current = prefix .. ".",
        },
        -- Add provider switching shortcuts
        provider = {
          copilot = prefix .. "c",
          ollama = prefix .. "o",
          switch = prefix .. "p", -- Add switch provider shortcut
        },
      },
      disabled_tools = {
        "list_files",
        "search_files",
        "read_file",
        "create_file",
        "rename_file",
        "delete_file",
        "create_dir",
        "rename_dir",
        "delete_dir",
        "bash",
      },
      behaviour = {
        auto_suggestions = false,
      },
      provider = "copilot",
      switch_provider = {
        providers = { "copilot", "ollama" },
      },
      copilot = {
        model = "claude-3.7-sonnet",
        temperature = 0,
        max_tokens = 8192,
      },
      ollama = {
        endpoint = "http://10.1.3.231:11434",
        model = "llama3.1:8b-instruct-q8_0",
      },
      web_search_engine = {
        provider = "tavily", -- tavily, serpapi, searchapi, google, kagi, brave, or searxng
        proxy = nil, -- proxy support, e.g., http://127.0.0.1:7890
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- dynamically build it, taken from astronvim
    build = vim.fn.has("win32") == 1 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
          -- make sure rendering happens even without opening a markdown file first
          "yetone/avante.nvim",
        },
        opts = function(_, opts)
          opts.file_types = opts.file_types or { "markdown", "norg", "rmd", "org" }
          vim.list_extend(opts.file_types, { "Avante" })
        end,
      },
    },
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = "MCPHub", -- lazy load by default
    build = "npm install -g mcp-hub@latest", -- Installs globally
    config = function()
      require("mcphub").setup({
        -- Server configuration
        port = 37373, -- Port for MCP Hub Express API
        config = vim.fn.expand("~/.config/mcphub/servers.json"), -- Config file path

        native_servers = {}, -- add your native servers here
        -- Extension configurations
        auto_approve = true,
        extensions = {
          avante = {
            make_slash_commands = true, -- make /slash commands from MCP server prompts
          },
        },

        -- UI configuration
        ui = {
          window = {
            width = 0.8, -- Window width (0-1 ratio)
            height = 0.8, -- Window height (0-1 ratio)
            border = "rounded", -- Window border style
            relative = "editor", -- Window positioning
            zindex = 50, -- Window stack order
          },
        },

        -- Event callbacks
        on_ready = function(hub) end, -- Called when hub is ready
        on_error = function(err) end, -- Called on errors

        -- Logging configuration
        log = {
          level = vim.log.levels.WARN, -- Minimum log level
          to_file = false, -- Enable file logging
          file_path = nil, -- Custom log file path
          prefix = "MCPHub", -- Log message prefix
        },
      })
      require("avante").setup({
        -- other config
        -- The system_prompt type supports both a string and a function that returns a string. Using a function here allows dynamically updating the prompt with mcphub
        system_prompt = function()
          local hub = require("mcphub").get_hub_instance()
          return hub:get_active_servers_prompt()
        end,
        -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
        custom_tools = function()
          return {
            require("mcphub.extensions.avante").mcp_tool(),
          }
        end,
      })
    end,
  },
}

if true then
  return {
    {
      "mfussenegger/nvim-dap",
      dependencies = {
        -- fancy UI for the debugger
        {
          "rcarriga/nvim-dap-ui",
          dependencies = { "nvim-neotest/nvim-nio" },
          -- stylua: ignore
          keys = {
            { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
            { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
          },
          opts = {},
          config = function(_, opts)
            -- setup dap config by VsCode launch.json file
            -- require("dap.ext.vscode").load_launchjs()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup(opts)
            dap.listeners.after.event_initialized["dapui_config"] = function()
              dapui.open({})
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
              dapui.close({})
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
              dapui.close({})
            end
          end,
        },
        -- virtual text for the debugger
        {
          "theHamsta/nvim-dap-virtual-text",
          opts = {},
        },

        -- which key integration
        {
          "folke/which-key.nvim",
          optional = true,
          opts = {
            defaults = {
              ["<leader>d"] = { name = "+debug" },
            },
          },
        },

        -- mason.nvim integration
        {
          "jay-babu/mason-nvim-dap.nvim",
          dependencies = "mason.nvim",
          cmd = { "DapInstall", "DapUninstall" },
          opts = {
            -- Makes a best effort to setup the various debuggers with
            -- reasonable debug configurations
            automatic_installation = true,

            -- You can provide additional configuration to the handlers,
            -- see mason-nvim-dap README for more information
            handlers = {},

            -- You'll need to check that you have the required things installed
            -- online, please don't ask me how to install them :)
            ensure_installed = {
              -- Update this to ensure that you have the debuggers for the langs you want
            },
          },
        },
      },

      -- stylua: ignore
      keys = {
        { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
        { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
        { "<leader>dc", function() require("dap").continue() end,                                             desc = "Continue" },
        { "<leader>da", function() require("dap").continue({ before = get_args }) end,                        desc = "Run with Args" },
        { "<leader>dC", function() require("dap").run_to_cursor() end,                                        desc = "Run to Cursor" },
        { "<leader>dg", function() require("dap").goto_() end,                                                desc = "Go to Line (No Execute)" },
        { "<leader>di", function() require("dap").step_into() end,                                            desc = "Step Into" },
        { "<leader>dj", function() require("dap").down() end,                                                 desc = "Down" },
        { "<leader>dk", function() require("dap").up() end,                                                   desc = "Up" },
        { "<leader>dl", function() require("dap").run_last() end,                                             desc = "Run Last" },
        { "<leader>do", function() require("dap").step_out() end,                                             desc = "Step Out" },
        { "<leader>dO", function() require("dap").step_over() end,                                            desc = "Step Over" },
        { "<leader>dp", function() require("dap").pause() end,                                                desc = "Pause" },
        { "<leader>dr", function() require("dap").repl.toggle() end,                                          desc = "Toggle REPL" },
        { "<leader>ds", function() require("dap").session() end,                                              desc = "Session" },
        { "<leader>dt", function() require("dap").terminate() end,                                            desc = "Terminate" },
        { "<leader>dw", function() require("dap.ui.widgets").hover() end,                                     desc = "Widgets" },
      },

      config = function()
        local Config = require("lazyvim.config")
        vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

        for name, sign in pairs(Config.icons.dap) do
          sign = type(sign) == "table" and sign or { sign }
          vim.fn.sign_define(
            "Dap" .. name,
            { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
          )
        end
      end,
    }
  }
end

local isDebugging = false
local isFEDebugging = false

local function toggleDebugging()
  if isDebugging then
    require("dap").terminate()
  else
    require("dap").run({
      name = "Attach",
      type = "pwa-node",
      request = "attach",
      port = 9229,
      cwd = "/",
      resolveSourceMapLocations = nil,
      attachExistingChildren = false,
      autoAttachChildProcesses = false,
      restart = true,
      autoReload = {
        enable = true,
      },
      skipFiles = { "**/node_modules/**", "<node_internals>/**", "http?(s):/**", "**/google.com/**" },
    })
  end
  isDebugging = not isDebugging
end

local function toggleFEDebugging()
  if isFEDebugging then
    require("dap").terminate()
  else
    require("dap").run({
      name = "Debug with Firefox",
      type = "firefox",
      request = "launch",
      reAttach = true,
      url = "http://localhost:3000",
      webRoot = "${workspaceFolder}",
      firefoxExecutable = "/Applications/Firefox Developer Edition.app/Contents/MacOS/firefox-bin",
      firefoxArgs = { "-start-debugger-server", 9222 },
      skipFiles = { "**/node_modules/**", "<node_internals>/**", "http?(s):/**", "**/google.com/**" },
    })
  end
  isFEDebugging = not isFEDebugging
end

return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "mxsdev/nvim-dap-vscode-js",
    "leoluz/nvim-dap-go",
    {
      "microsoft/vscode-js-debug",
      version = "1.x",
      build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
    },
  },
  keys = {
    { "<leader>C", toggleDebugging,   desc = "Debug - Backend Debug" },
    { "<leader>c", toggleFEDebugging, desc = "Debug - Frontend Debug" },
    {
      "<leader>v",
      function()
        require("dap").continue()
      end,
      desc = "Debug - Continue",
    },
    {
      "<leader>=",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Debug - Breakpoint",
    },
    {
      "<leader>k",
      function()
        require("dap").step_over()
      end,
      desc = "Debug - Step Over",
    },
    {
      "<leader>l",
      function()
        require("dap").step_into()
      end,
      desc = "Debug - Step Into",
    },
    {
      "<leader>h",
      function()
        require("dap").step_out()
      end,
      desc = "Debug - Step Out",
    },
    {
      "<leader>/",
      function()
        require("dap").eval()
      end,
      desc = "Debug - Eval",
    },
  },
  config = function()
    require("dap-vscode-js").setup({
      debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
      adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
    })

    require("dap").adapters.firefox = {
      type = "executable",
      command = "npm run dev",
      args = { os.getenv("HOME") .. "/Downloads/vscode-firefox-debug/dist/adapter.bundle.js" },
    }

    for _, language in ipairs({ "typescript", "javascript", "typescriptreact" }) do
      require("dap").configurations[language] = {
        {
          name = "Attach",
          type = "pwa-node",
          request = "attach",
          port = 9229,
          cwd = "/",
          resolveSourceMapLocations = nil,
          attachExistingChildren = false,
          autoAttachChildProcesses = false,
          restart = true,
          autoReload = {
            enable = true,
          },
          skipFiles = { "**/node_modules/**", "<node_internals>/**", "http?(s):/**", "**/google.com/**" },
        },
        -- run npm run dev --inspect on remix
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch (npm run dev)",
          runtimeExecutable = "npm",
          runtimeArgs = {
            "run",
            "dev",
            "--inspect",
          },
          resolveSourceMapLocations = nil,
          program = "${file}",
          cwd = "${workspaceFolder}",
          skipFiles = { "**/node_modules/**", "<node_internals>/**", "http?(s):/**", "**/google.com/**" },
        },
      }

      local dap = require("dap")
      require('dap-go').setup()
      dap.adapters.go = {
        type = 'executable',
        command = 'node',
        args = { os.getenv('HOME') .. '/Downloads/vscode-go/extension/dist/debugAdapter.js' },
      }
      dap.configurations.go = {
        {
          type = 'go',
          name = 'Debug with environmental variables',
          request = 'launch',
          showLog = false,
          program = "${file}",
          dlvToolPath = vim.fn.exepath('dlv'),
          env = {
          },
        },
        {
          type = 'go',
          name = 'Debug',
          request = 'launch',
          showLog = true,
          program = "${file}",
          dlvToolPath = vim.fn.exepath('dlv')
        },
        {
          -- Must be "go" or it will be ignored by the plugin
          type = "go",
          name = "Attach remote",
          mode = "remote",
          port = 8003,
          request = "attach",
        },
      }
    end

    require("dapui").setup({
      layouts = {
        {
          elements = {
            {
              id = "stacks",
              size = 0.15,
            },
            {
              id = "scopes",
              size = 0.85,
            },
          },
          position = "right",
          size = 70,
        },
        {
          elements = {
            -- {
            -- id = "watches",
            -- size = 0.5,
            -- },
            {
              id = "breakpoints",
              size = 0.5,
            },
            {
              id = "repl",
              size = 0.5
            },
            -- {
            -- id = "repl",
            -- size = 0.35,
            -- },
          },
          position = "bottom",
          size = 10,
        },
      },
    })

    local dap, dapui = require("dap"), require("dapui")
    dap.adapters.firefox = {
      type = "executable",
      command = "node",
      args = { os.getenv("HOME") .. "/Downloads/vscode-firefox-debug/dist/adapter.bundle.js" },
    }
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open({ reset = true })
    end
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close
  end,
}

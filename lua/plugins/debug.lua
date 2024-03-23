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
    {
      "microsoft/vscode-js-debug",
      version = "1.x",
      build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
    },
  },
  keys = {
    { "<leader>c", toggleDebugging,   desc = "Debug - Backend Debug" },
    { "<leader>C", toggleFEDebugging, desc = "Debug - Frontend Debug" },
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
        -- {
        --   type = "pwa-chrome",
        --   name = "Launch Chrome to debug client",
        --   request = "launch",
        --   url = "http://localhost:3000",
        --   sourceMaps = true,
        --   protocol = "inspector",
        --   port = 8003,
        --   webRoot = "${workspaceFolder}/src",
        --   -- skip files from vite's hmr
        --   skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
        -- },
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

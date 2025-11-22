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
      -- restart = true,
      -- autoReload = {
      -- enable = true,
      -- },
      skipFiles = {
        "${workspaceFolder}/node_modules/**/**",
        "${workspaceFolder}/lib/**/**",
        "<node_internals>/**/*.js",
        "**/node_modules/**",
        "<node_internals>/**",
        "http?(s):/**",
      },
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

local function get_package_json_script(script_name)
  local package_json = vim.fn.getcwd() .. "/package.json"
  if vim.fn.filereadable(package_json) == 1 then
    local content = vim.fn.join(vim.fn.readfile(package_json), "\n")
    local package_data = vim.fn.json_decode(content)
    if package_data and package_data.scripts and package_data.scripts[script_name] then
      return package_data.scripts[script_name]
    end
  end
  return nil
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
    { "<leader>dd", toggleDebugging, desc = "Debug - Backend Debug" },
    { "<leader>DD", toggleFEDebugging, desc = "Debug - Frontend Debug" },
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
    -- {
    --   "<leader>/",
    --   function()
    --     require("dap").eval()
    --   end,
    --   desc = "Debug - Eval",
    -- },
  },
  config = function()
    require("dap-vscode-js").setup({
      debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
      adapters = { "node", "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
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
        {
          type = "node",
          request = "launch",
          name = "Launch Current File",
          program = "${file}", -- This will run the current file
          cwd = vim.fn.getcwd(),
          runtimeExecutable = "node", -- Use node directly
          runtimeArgs = { "--inspect" }, -- Add any additional arguments you want here
          skipFiles = { "**/node_modules/**", "<node_internals>/**", "http?(s):/**", "**/google.com/**" },
          env = {
            NODE_ENV = "staging",
          },
        },
        {
          type = "node",
          request = "launch",
          name = "Launch Package.json Script",
          runtimeExecutable = "npm",
          runtimeArgs = function()
            local script_name = vim.fn.input("Enter script name from package.json: ")
            local script = get_package_json_script(script_name)
            if script then
              return { "run", script_name }
            else
              print("Script not found in package.json")
              return {}
            end
          end,
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
        },
      }

      local dap = require("dap")
      require("dap-go").setup()
      -- dap.adapters.go = {
      --   type = "executable",
      --   command = "node",
      --   args = { os.getenv("HOME") .. "/Downloads/vscode-go/extension/dist/debugAdapter.js" },
      -- }
      dap.configurations.go = {
        {
          type = "go",
          name = "Debug",
          request = "launch",
          showLog = true,
          program = "${file}",
          dlvToolPath = vim.fn.exepath("dlv"),
        },
        {
          type = "go",
          name = "Debug with environmental variables",
          request = "launch",
          showLog = false,
          program = "${file}",
          dlvToolPath = vim.fn.exepath("dlv"),
          env = {},
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
              size = 0.5,
            },
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

-- plugins/debug.lua
-- Cloudflare Workers debugging configuration for LazyVim

-- local function get_cloudflare_worker_name()
--   -- First try to get from wrangler.toml
--   local wrangler_toml = vim.fn.getcwd() .. "/wrangler.toml"
--   if vim.fn.filereadable(wrangler_toml) == 1 then
--     local content = vim.fn.join(vim.fn.readfile(wrangler_toml), "\n")
--     local name_match = content:match("name%s*=%s*[\"']([^\"']+)[\"']")
--     if name_match then
--       return name_match
--     end
--   end
--
--   -- Fallback to package.json
--   local package_json = vim.fn.getcwd() .. "/package.json"
--   if vim.fn.filereadable(package_json) == 1 then
--     local content = vim.fn.join(vim.fn.readfile(package_json), "\n")
--     local package_data = vim.fn.json_decode(content)
--     if package_data and package_data.name then
--       return package_data.name
--     end
--   end
--
--   return nil
-- end
--
-- local function check_wrangler_running()
--   local handle = io.popen("pgrep -f 'wrangler dev'")
--   if handle then
--     local result = handle:read("*a")
--     handle:close()
--     return result and result ~= ""
--   end
--   return false
-- end
--
-- local function get_debug_port()
--   -- Check if wrangler is running with custom port
--   local handle = io.popen("ps aux | grep 'wrangler dev' | grep -v grep")
--   if handle then
--     local result = handle:read("*a")
--     handle:close()
--
--     -- Look for --inspector-port flag
--     local port = result:match("%-%-inspector%-port[=%s]+(%d+)")
--     if port then
--       return tonumber(port)
--     end
--   end
--
--   -- Default port
--   return 9229
-- end
--
-- return {
--   -- Override the existing nvim-dap configuration
--   {
--     "mfussenegger/nvim-dap",
--     optional = true,
--     dependencies = {
--       {
--         "microsoft/vscode-js-debug",
--         build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
--       },
--     },
--     opts = function()
--       local dap = require("dap")
--
--       -- Add custom event listeners for better debugging
--       dap.listeners.after.event_initialized["cloudflare_debug"] = function(session)
--         print("✅ Debug session initialized for Cloudflare Worker")
--       end
--
--       dap.listeners.after.event_terminated["cloudflare_debug"] = function(session, body)
--         print("❌ Debug session terminated. Reason: " .. vim.inspect(body))
--       end
--
--       dap.listeners.after.event_exited["cloudflare_debug"] = function(session, body)
--         print("🚪 Debug session exited. Code: " .. vim.inspect(body))
--       end
--
--       dap.listeners.after.disconnect["cloudflare_debug"] = function(session, body)
--         print("🔌 Debug session disconnected. Reason: " .. vim.inspect(body))
--       end
--
--       -- Configure for JavaScript/TypeScript
--       for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
--         if not dap.configurations[language] then
--           dap.configurations[language] = {}
--         end
--
--         -- Add Cloudflare Workers configuration with correct WebSocket path
--         table.insert(dap.configurations[language], {
--           name = "Debug Cloudflare Worker",
--           type = "pwa-node",
--           request = "attach",
--           websocketAddress = function()
--             local port = get_debug_port()
--             local address = "ws://127.0.0.1:" .. port .. "/ws"
--             print("🔗 Connecting to: " .. address)
--             return address
--           end,
--           sourceMaps = true,
--           resolveSourceMapLocations = nil,
--           skipFiles = { "**/node_modules/**", "<node_internals>/**", "http?(s):/**" },
--           timeout = 30000,
--           localRoot = vim.fn.getcwd(),
--           remoteRoot = "/",
--         })
--
--         -- Alternative: Try direct port connection as fallback
--         table.insert(dap.configurations[language], {
--           name = "Debug Cloudflare Worker (Port)",
--           type = "pwa-node",
--           request = "attach",
--           port = function()
--             return get_debug_port()
--           end,
--           sourceMaps = true,
--           skipFiles = { "**/node_modules/**", "<node_internals>/**", "http?(s):/**" },
--           timeout = 30000,
--         })
--       end
--     end,
--     keys = {
--       {
--         "<leader>dC",
--         function()
--           -- Check if wrangler is running
--           if not check_wrangler_running() then
--             vim.notify(
--               "⚠️  Wrangler dev server is not running. Please start with 'wrangler dev'",
--               vim.log.levels.WARN
--             )
--             return
--           end
--
--           local port = get_debug_port()
--           local address = "ws://127.0.0.1:" .. port .. "/ws"
--
--           vim.notify("🔍 Connecting to Cloudflare Worker on: " .. address)
--
--           -- Try to connect with the correct Cloudflare format
--           require("dap").run({
--             name = "Debug Cloudflare Worker",
--             type = "pwa-node",
--             request = "attach",
--             websocketAddress = address,
--             sourceMaps = true,
--             resolveSourceMapLocations = nil,
--             skipFiles = { "**/node_modules/**", "<node_internals>/**", "http?(s):/**" },
--             timeout = 30000,
--           })
--         end,
--         desc = "Debug Cloudflare Worker",
--       },
--       {
--         "<leader>dF",
--         function()
--           -- Fallback: Try regular port connection
--           if not check_wrangler_running() then
--             vim.notify(
--               "⚠️  Wrangler dev server is not running. Please start with 'wrangler dev'",
--               vim.log.levels.WARN
--             )
--             return
--           end
--
--           local port = get_debug_port()
--           vim.notify("🔍 Connecting to port " .. port .. " (fallback method)")
--
--           require("dap").run({
--             name = "Debug Cloudflare Worker (Port)",
--             type = "pwa-node",
--             request = "attach",
--             port = port,
--             sourceMaps = true,
--             skipFiles = { "**/node_modules/**", "<node_internals>/**", "http?(s):/**" },
--             timeout = 30000,
--           })
--         end,
--         desc = "Debug Cloudflare Worker (Port)",
--       },
--     },
--   },
-- }

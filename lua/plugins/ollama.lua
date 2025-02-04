return {
  {
    "David-Kunz/gen.nvim",
    opts = {
      model = "llama3", -- The default model to use.
      -- model = "mistral", -- The default model to use.
      -- model = "codestra:latest", -- The default model to use.
      -- model = "deepseek-r1:14b", -- The default model to use.
      -- model = "gemma:2b", -- The default model to use.
      host = "localhost", -- The host running the Ollama service.
      port = "11434", -- The port on which the Ollama service is listening.
      display_mode = "split", -- The display mode. Can be "float" or "split".
      show_prompt = false, -- Shows the Prompt submitted to Ollama.
      show_model = false, -- Displays which model you are using at the beginning of your chat session.
      quit_map = "q", -- set keymap for quit
      no_auto_close = false, -- Never closes the window automatically.
      init = function(options)
        pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
      end,
      -- Function to initialize Ollama
      command = function(options)
        return "curl --silent --no-buffer -X POST http://"
          .. options.host
          .. ":"
          .. options.port
          .. "/api/chat -d $body"
      end,
      -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
      -- This can also be a command string.
      -- The executed command must return a JSON object with { response, context }
      -- (context property is optional).
      -- list_models = '<omitted lua function>', -- Retrieves a list of model names
      debug = false, -- Prints errors and the command which is run.
    },
    config = function(_, opts)
      require("gen").setup(opts)
      require("gen").prompts["Generate_TSDoc"] = {
        prompt = "Generate TSDocs for this function:\n $text",
        replace = false,
        opts = {
          display_mode = "split", -- The display mode. Can be "float" or "split".
        },
      }
    end,
    -- keys = {
    -- { "<leader>o", "<cmd>Gen<CR>", mode = { "n", "x", "o", "v" }, desc = "Gen toggle", { silent = true } },
    -- },
  },
}

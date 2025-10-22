return {
  {
    "linux-cultist/venv-selector.nvim",
    ft = { "python" },
    cmd = { "VenvSelect", "VenvSelectCurrent" },
    opts = function()
      return {
        settings = {
          options = {
            activate_venv_in_terminal = true,
            cached_venv_automatic_activation = true,
            notify_user_on_venv_activation = false,
            picker = "snacks",
          },
        },
      }
    end,
    config = function(_, opts)
      require("venv-selector").setup(opts)
      vim.api.nvim_create_autocmd("VimEnter", {
        desc = "Auto select virtualenv Nvim open",
        pattern = "*",
        callback = function()
          local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
          if venv ~= "" then
            pcall(require("venv-selector").retrieve_from_cache)
          end
        end,
        once = true,
      })
    end,
  },
}

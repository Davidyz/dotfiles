return {
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "ibhagwan/fzf-lua" },
    ft = { "python" },
    cmd = { "VenvSelect", "VenvSelectCurrent" },
    opts = function()
      return {
        settings = {
          options = {
            activate_venv_in_terminal = true,
            cached_venv_automatic_activation = true,
            notify_user_on_venv_activation = true,
            picker = "fzf-lua",
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
  {
    "Davidyz/inlayhint-filler.nvim",
    event = "LspAttach",
    ---@module "inlayhint-filler"
    ---@type InlayHintFillerOpts
    opts = { blacklisted_servers = {} },
    keys = {
      {
        "<Leader>I",
        function()
          if vim.lsp.inlay_hint.apply_text_edits ~= nil then
            return vim.lsp.inlay_hint.apply_text_edits({ bufnr = 0 })
          end
          require("inlayhint-filler").fill()
        end,
        mode = { "n", "v" },
        desc = "Insert inlay hint to the buffer",
      },
    },
  },
}

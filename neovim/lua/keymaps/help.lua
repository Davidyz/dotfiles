vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "q", "", {
      callback = function()
        vim.api.nvim_command("quit")
      end,
      noremap = true,
      silent = true,
    })
  end,
})

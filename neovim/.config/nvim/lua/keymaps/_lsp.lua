if vim.fn.exists("g:vscode") ~= 0 then
  return
end

local window_style = {
  border = "single",
}

local has_telescope, telescope = pcall(require, "telescope.builtin")

vim.o.pumheight = math.floor(vim.o.lines / 4)

local bufmap = function(mode, lhs, rhs)
  local opts = { buffer = true }
  vim.keymap.set(mode, lhs, rhs, opts)
end

local show_docs = function()
  if
    (
      vim.bo.ft == "lua"
      and (
        string.match(
          vim.fn.getline("."),
          "vim%." .. "%w+%." .. vim.fn.expand("<cword>")
        )
        or string.match(vim.fn.getline("."), "vim%." .. vim.fn.expand("<cword>"))
      )
    )
    or vim.bo.ft == "vim"
    or vim.bo.ft == "help"
  then
    local status, result = pcall(vim.api.nvim_command, "h " .. vim.fn.expand("<cword>"))
    if status then
      return
    end
  end
  return vim.lsp.buf.hover()
end

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function()
    -- Displays hover information about the symbol under the cursor
    -- bufmap("n", "K", vim.lsp.buf.hover)
    bufmap("n", "K", show_docs)

    -- Jump to the definition
    bufmap("n", "gd", function()
      vim.lsp.buf.definition({ reuse_win = false })
    end)

    -- Jump to declaration
    bufmap("n", "gD", vim.lsp.buf.declaration)

    -- Lists all the implementations for the symbol under the cursor
    bufmap("n", "gi", vim.lsp.buf.implementation)

    -- Jumps to the definition of the type symbol
    bufmap("n", "go", vim.lsp.buf.type_definition)

    -- Lists all the references
    bufmap("n", "gr", function(ctx, opts)
      if has_telescope then
        return telescope.lsp_references(opts)
      else
        return vim.lsp.buf.references(ctx, opts)
      end
    end)

    -- Displays a function's signature information
    -- bufmap("n", "<C-k>", vim.lsp.buf.signature_help)

    -- Renames all references to the symbol under the cursor
    bufmap("n", "<Leader>r", vim.lsp.buf.rename)

    -- Selects a code action available at the current cursor position
    bufmap("n", "<Leader>a", vim.lsp.buf.code_action)
    bufmap("x", "<F4>", vim.lsp.buf.range_code_action)

    -- Show diagnostics in a floating window
    bufmap("n", "gl", vim.diagnostic.open_float)

    -- Move to the previous diagnostic
    bufmap("n", "[d", vim.diagnostic.goto_prev)

    -- Move to the next diagnostic
    bufmap("n", "]d", vim.diagnostic.goto_next)
  end,
})

local cmp = require("cmp")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local luasnip = require("luasnip")
local select_opts = { behavior = cmp.SelectBehavior.Insert }

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp", keyword_length = 1 },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "dictionary", keyword_length = 2 },
    { name = "buffer", keyword_length = 2 },
    { name = "luasnip", keyword_length = 2 },
    { name = "nvim_lsp_signature_help" },
    { name = "zsh" },
  },
  window = {
    documentation = cmp.config.window.bordered(window_style),
    completion = cmp.config.window.bordered(window_style),
  },
  formatting = {
    fields = { "abbr", "menu", "kind" },
  },
  mapping = {
    ["<CR>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
      else
        local cr = vim.api.nvim_replace_termcodes("<cr>", true, true, true)
        vim.api.nvim_feedkeys(cr, "n", false)
      end
    end),

    ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
    ["<Down>"] = cmp.mapping.select_next_item(select_opts),

    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-d>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-b>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      local col = vim.fn.col(".") - 1

      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
        fallback()
      else
        cmp.complete()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
})
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

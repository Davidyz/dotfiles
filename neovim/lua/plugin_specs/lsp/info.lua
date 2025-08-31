local api = vim.api
return {
  {
    "xzbdmw/colorful-menu.nvim",
    opts = { max_width = 0.3 },
  },
  {
    "SmiteshP/nvim-navic",
    opts = {
      lsp = { auto_attach = true },
      icons = require("_utils").codicons,
    },
    event = "LspAttach",
    cond = require("_utils").no_vscode,
  },
  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach",
    opts = function()
      local function h(name)
        return api.nvim_get_hl(0, { name = name })
      end

      -- hl-groups can have any name
      api.nvim_set_hl(
        0,
        "SymbolUsageRounding",
        { fg = h("CursorLine").bg, italic = true }
      )
      api.nvim_set_hl(
        0,
        "SymbolUsageContent",
        { bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true }
      )
      api.nvim_set_hl(
        0,
        "SymbolUsageRef",
        { fg = h("Function").fg, bg = h("CursorLine").bg, italic = true }
      )
      api.nvim_set_hl(
        0,
        "SymbolUsageDef",
        { fg = h("Type").fg, bg = h("CursorLine").bg, italic = true }
      )
      api.nvim_set_hl(
        0,
        "SymbolUsageImpl",
        { fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true }
      )

      local function text_format(symbol)
        local res = {}

        local round_start = { "", "SymbolUsageRounding" }
        local round_end = { "", "SymbolUsageRounding" }

        -- Indicator that shows if there are any other symbols in the same line
        local stacked_functions_content = symbol.stacked_count > 0
            and ("+%s"):format(symbol.stacked_count)
          or ""

        if symbol.references then
          local usage = symbol.references <= 1 and "usage" or "usages"
          local num = symbol.references == 0 and "no" or symbol.references
          table.insert(res, round_start)
          table.insert(res, { "󰌹  ", "SymbolUsageRef" })
          table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        if symbol.definition then
          if #res > 0 then
            table.insert(res, { " ", "NonText" })
          end
          table.insert(res, round_start)
          table.insert(res, { "󰳽  ", "SymbolUsageDef" })
          table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        if symbol.implementation then
          if #res > 0 then
            table.insert(res, { " ", "NonText" })
          end
          table.insert(res, round_start)
          table.insert(res, { "󰡱  ", "SymbolUsageImpl" })
          table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        if stacked_functions_content ~= "" then
          if #res > 0 then
            table.insert(res, { " ", "NonText" })
          end
          table.insert(res, round_start)
          table.insert(res, { "  ", "SymbolUsageImpl" })
          table.insert(res, { stacked_functions_content, "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        return res
      end
      ---@module "symbol-usage"
      ---@type UserOpts
      return {
        text_format = text_format,
        definition = { enabled = true },
        implementation = { enabled = true },
        symbol_filter = function(ctx)
          return function(symbol)
            if ctx.method == vim.lsp.protocol.Methods.textDocument_references then
              return string.find(symbol.uri, "tests") == nil
            else
              return true
            end
          end
        end,
      }
    end,
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    version = "*",
    opts = function()
      return {
        notification = {
          window = {
            normal_hl = "FidgetNormal",
            winblend = 50,
            align = "bottom",
            x_padding = 0,
            border = "solid",
          },
          view = { stack_upwards = false },
        },
      }
    end,
    config = function(_, opts)
      require("fidget").setup(opts)
      local comment_hl = api.nvim_get_hl(0, { name = "Comment" })
      local float_border = api.nvim_get_hl(0, { name = "FloatBorder" })
      api.nvim_set_hl(
        0,
        "FidgetNormal",
        { fg = comment_hl.fg, guifg = comment_hl.guifg, bg = float_border.bg }
      )
    end,
    cond = require("_utils").no_vscode,
  },
  {
    "hedyhli/outline.nvim",
    cond = require("_utils").no_vscode,
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>o", ":Outline<CR>", desc = "Toggle outline" },
    },
    opts = function()
      local opts = { symbols = { icons = {} } }
      for k, v in pairs(require("_utils").codicons) do
        opts.symbols.icons[k] = { icon = v }
      end
      return opts
    end,
    init = function()
      api.nvim_create_autocmd("BufEnter", {
        nested = true,
        callback = function()
          if #api.nvim_list_wins() == 1 and vim.bo.filetype == "Outline" then
            vim.cmd("quit")
          end
        end,
      })
    end,
  },
  {
    "lewis6991/hover.nvim",
    opts = {
      init = function()
        require("hover.providers.lsp")
        require("hover.providers.man")
        require("hover.providers.dap")
        require("hover.providers.diagnostic")

        local peek_supported_capabilities = {
          vim.lsp.protocol.Methods.textDocument_declaration,
          vim.lsp.protocol.Methods.textDocument_implementation,
          vim.lsp.protocol.Methods.textDocument_definition,
        }
        require("hover").register({
          name = "LSP Peek",
          priority = 1000,
          enabled = function(bufnr)
            return vim.iter(vim.lsp.get_clients({ bufnr = bufnr })):any(
              ---@param cli vim.lsp.Client
              function(cli)
                return vim.iter(peek_supported_capabilities):any(function(method)
                  return cli:supports_method(method, bufnr)
                end)
              end
            )
          end,
          execute = function(opts, done)
            local finished = false
            for _, method in ipairs(peek_supported_capabilities) do
              if
                vim.iter(vim.lsp.get_clients({ bufnr = opts.bufnr })):any(
                  ---@param cli vim.lsp.Client
                  function(cli)
                    return cli:supports_method(method, opts.bufnr)
                  end
                )
              then
                vim.lsp.buf_request(opts.bufnr, method, function(client, _bufnr)
                  return vim.lsp.util.make_position_params(0, client.offset_encoding)
                end, function(err, result, context, config)
                  if result == nil or vim.tbl_isempty(result) then
                    if not finished then
                      finished = true
                      return pcall(done, false)
                    else
                      return
                    end
                  end
                  local loc = result
                  if vim.islist(result) then
                    loc = result[1]
                  end
                  loc.uri = loc.uri or loc.targetUri
                  loc.range = loc.range or loc.targetRange
                  if loc.uri == nil or loc.range == nil then
                    if not finished then
                      finished = true
                      return pcall(done, false)
                    else
                      return
                    end
                  end
                  local peek_bufnr = vim.uri_to_bufnr(loc.uri)
                  vim.fn.bufload(peek_bufnr)
                  api.nvim_buf_call(peek_bufnr, function()
                    -- make sure the appropriate treesitter parser can be created
                    vim.cmd("filetype detect")
                  end)

                  local range = loc.range
                  local ft = vim.bo[peek_bufnr].filetype
                  local md_lines = {}
                  local peek_path = vim.fs.abspath(api.nvim_buf_get_name(peek_bufnr))
                  local orig_path = vim.fs.abspath(api.nvim_buf_get_name(opts.bufnr))
                  if orig_path ~= peek_path then
                    local cli = vim.lsp.get_client_by_id(context.client_id)
                    if cli and cli.config.root_dir then
                      peek_path =
                        string.format([[%s]], vim.fs.normalize(peek_path)):gsub(
                          string.format(
                            [[%s/]],
                            vim.fs.normalize(vim.fs.abspath(cli.config.root_dir))
                          ),
                          ""
                        )
                    end

                    peek_path = peek_path:gsub(
                      string.format([[%s]], os.getenv("HOME") or ""),
                      "~"
                    )
                    vim.list_extend(md_lines, { string.format("`%s`", peek_path) })
                  end
                  vim.list_extend(md_lines, {
                    "```" .. ft,
                    string.format(vim.bo[peek_bufnr].commentstring, method),
                  })
                  local line_num = math.ceil(api.nvim_win_get_height(0) * 0.2)
                  local ts_node = vim.treesitter.get_node({
                    bufnr = peek_bufnr,
                    pos = { range.start.line, range.start.character },
                  })
                  if ts_node ~= nil then
                    local row_start, _, row_end, _ =
                      vim.treesitter.get_node_range(ts_node)

                    while row_start == row_end and ts_node ~= nil do
                      -- find the closest multi_line parent node and treat it as the definition.
                      ts_node = ts_node:parent()
                      if ts_node:parent() == nil then
                        -- it's probably the root node. skip it.
                        break
                      end
                      row_start, _, row_end, _ = vim.treesitter.get_node_range(ts_node)
                    end

                    line_num = row_end - row_start + 1
                  end
                  vim.list_extend(
                    md_lines,
                    api.nvim_buf_get_lines(
                      peek_bufnr,
                      range.start.line,
                      range.start.line + line_num,
                      false
                    )
                  )
                  table.insert(md_lines, "```")
                  if not finished then
                    finished = true
                    return pcall(done, {
                      lines = md_lines,
                      filetype = "markdown",
                    })
                  else
                    return
                  end
                end)
                return
              end
            end
          end,
        })
      end,
      preview_opts = {
        -- border = "double",
      },
      preview_window = false,
      title = true,
      mouse_providers = {
        "LSP",
      },
      mouse_delay = 1000,
    },
    keys = {
      {
        "K",
        function()
          require("hover").hover({})
        end,
        desc = "Trigger hover.",
        mode = "n",
        noremap = true,
      },
    },
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = { "LspAttach" },
    dependencies = { "neovim/nvim-lspconfig" },
    init = function()
      vim.diagnostic.config({
        virtual_text = false,
      })
    end,
    main = "tiny-inline-diagnostic",
    cond = require("_utils").no_vscode,
    opts = {
      preset = "nonerdfont",
      options = {
        multiple_diag_under_cursor = true,
        show_source = true,
      },
    },
  },
}

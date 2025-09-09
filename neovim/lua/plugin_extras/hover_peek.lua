local lsp = vim.lsp
local api = vim.api
local _utils = require("_utils")

---@type vim.lsp.protocol.Method[]
local peek_supported_methods = {
  lsp.protocol.Methods.textDocument_declaration,
  lsp.protocol.Methods.textDocument_implementation,
  lsp.protocol.Methods.textDocument_definition,
}

---@module "hover"

---@type Hover.Provider
return {
  name = "LSP Peek",
  priority = 999,
  enabled = function(bufnr)
    local clis = _utils.get_lsp_clients({
      bufnr = bufnr,
      methods = peek_supported_methods,
      strategy = "any",
    })
    return #clis ~= 0
  end,
  execute = function(opts, done)
    ---@type {client: vim.lsp.Client, method: vim.lsp.protocol.Method}[]
    local combinations = {}

    for _, client in
      ipairs(_utils.get_lsp_clients({
        bufnr = opts.bufnr,
        methods = peek_supported_methods,
        strategy = "any",
      }))
    do
      for _, method in ipairs(peek_supported_methods) do
        if client:supports_method(method, opts.bufnr) then
          table.insert(combinations, { client = client, method = method })
        end
      end
    end

    ---@param idx? integer
    ---@param comb {client: vim.lsp.Client, method: vim.lsp.protocol.Method}
    local function do_peek(idx, comb)
      if idx == nil or comb == nil then
        return pcall(done, false)
      end
      local method = comb.method
      comb.client:request(
        method,
        lsp.util.make_position_params(0, comb.client.offset_encoding),
        function(err, result, context, config)
          if result == nil or vim.tbl_isempty(result) then
            return pcall(do_peek, next(combinations, idx))
          end
          local loc = result
          if vim.islist(result) then
            loc = result[1]
          end
          loc.uri = loc.uri or loc.targetUri
          loc.range = loc.range or loc.targetRange
          if loc.uri == nil or loc.range == nil then
            return pcall(do_peek, next(combinations, idx))
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
            local cli = lsp.get_client_by_id(context.client_id)
            if cli and cli.config.root_dir then
              peek_path = string.format([[%s]], vim.fs.normalize(peek_path)):gsub(
                string.format(
                  [[%s/]],
                  vim.fs.normalize(vim.fs.abspath(cli.config.root_dir))
                ),
                ""
              )
            end

            peek_path =
              peek_path:gsub(string.format([[%s]], os.getenv("HOME") or ""), "~")
            vim.list_extend(md_lines, { string.format("`%s`", peek_path) })
          end
          vim.list_extend(md_lines, {
            "```" .. ft,
            string.format(
              vim.bo[peek_bufnr].commentstring,
              string.format("%s from %s", method, comb.client.name)
            ),
          })
          local line_num = math.ceil(api.nvim_win_get_height(0) * 0.2)
          local ts_node = vim.treesitter.get_node({
            bufnr = peek_bufnr,
            pos = { range.start.line, range.start.character },
          })
          if ts_node ~= nil then
            local row_start, _, row_end, _ = vim.treesitter.get_node_range(ts_node)

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
          return pcall(done, {
            lines = md_lines,
            filetype = "markdown",
          })
        end,
        opts.bufnr
      )
    end
    do_peek(next(combinations))
  end,
}

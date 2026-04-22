---@module "lazy"

local fs = vim.fs
local api = vim.api
local fn = vim.fn

---@param exec string|nil
---@return boolean
local function has_kitten(exec)
  return fn.executable(exec or "kitten") == 1
end

---@type LazySpec[]
return {
  {
    "hedyhli/markdown-toc.nvim",
    ft = { "markdown" },
    opts = { headings = { before_toc = false } },
  },
  {
    "Myzel394/easytables.nvim",
    cmd = { "EasyTablesCreateNew", "EasyTablesImportThisTable" },
    opts = {},
  },
  {
    "brianhuster/live-preview.nvim",
    config = function(self, _)
      return require("livepreview.config").set({ address = "0.0.0.0" })
    end,
    cmd = { "LivePreview" },
    keys = {
      {
        "mp",
        function()
          local lp = require("livepreview")
          if lp.is_running() then
            return lp.close()
          end
          local filepath = api.nvim_buf_get_name(0)
          local Config = require("livepreview.config").config
          local utils = require("livepreview.utils")
          lp.start(filepath, Config.port)

          local urlpath = (
            Config.dynamic_root and fs.basename(filepath)
            or utils.get_relative_path(filepath, fs.normalize(vim.uv.cwd() or ""))
          )
          local host = "127.0.0.1"
          if vim.env.SSH_CONNECTION then
            host = vim.split(vim.env.SSH_CONNECTION, " ", {})[3]
          end
          local url = string.format("http://%s:%d/%s", host, Config.port, urlpath)
          local notify_opts = { title = "live-preview.nvim" }

          -- if has_kitten() then
          --   -- use kitty if available. This _should_ allow opening browsers over ssh?
          --   local res = vim
          --     .system({ "kitten", "@", "run", "xdg-open", url }, { detach = true, text = true }, function(out)
          --       if out.code ~= 0 then
          --         vim.schedule_wrap(vim.notify)(
          --           out.stderr or ("An error has occurred. Failed to open " .. url),
          --           vim.log.levels.ERROR,
          --           { title = "LivePreview" }
          --         )
          --       end
          --     end)
          --     :wait()
          --   if res.code == 0 then
          --     return
          --   end
          -- end

          if vim.env.SSH_CONNECTION == nil then
            vim.notify(string.format("live-preview.nvim: Opening browser at %s", url), vim.log.levels.INFO, notify_opts)
            utils.open_browser(url, Config.browser)
          else
            vim.fn.setreg("+", url)
            vim.notify(
              string.format("**Active SSH session detected**.\nYanking the url: `%s` to the clipboard.", url),
              vim.log.levels.WARN,
              notify_opts
            )
          end
        end,
        mode = "n",
        desc = "[m]arkdown [p]review",
      },
    },
  },
}

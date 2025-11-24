---@type vim.lsp.Config
return {
  capabilities = {
    textDocument = {
      formatting = vim.NIL,
    },
  },
  -- flags = { debounce_text_changes = 0 },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        requirePattern = { "?/init.lua", "?/lua/?.lua'" },
      },
      diagnostics = {
        globals = {
          "vim",
          "require",
          "pcall",
          "rawset",
          "rawget",
          "getmetatable",
          "setmetatable",
          "tostring",
          "tonumber",
          "type",
          "print",
          "pairs",
          "ipairs",
          "error",
          "assert",
          "select",
          "next",
          "coroutine",
          "table",
          "math",
          "string",
          "io",
          "os",
          "debug",
          "package",
        },
        enableUnrecognisedLocals = false,
        disableWhenNoFileOpen = true,
        disableCheckFile = {},
        disable = { "type-not-found", "unnecessary-if" },
      },
      codeAction = {
        insertSpace = true,
      },
      strict = {
        typeCall = true,
        arrayIndex = true,
      },
      workspace = {
        checkThirdParty = true,
        enableCodeLens = true,
        ignoreDir = { "test_build" },
      },
      completion = {
        enable = true,
      },
    },
  },
}

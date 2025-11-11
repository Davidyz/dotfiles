return {
  capabilities = {
    textDocument = {
      formatting = {
        dynamicRegistration = true,
      },
    },
  },
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
        library = {
          vim.env.VIMRUNTIME,
          -- vim.fn.stdpath("config"),
          -- vim.fn.stdpath("data"),
        },
        checkThirdParty = true,
        enableCodeLens = true,
      },
      completion = {
        enable = true,
      },
    },
  },
}

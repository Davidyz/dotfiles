return {
  flags = { debounce_text_changes = 150 },
  settings = {
    Lua = {
      format = {
        enable = false,
        defaultConfig = {
          indent_style = "space",
          indent_size = 2,
          quote_style = "double",
        },
      },
      completion = {
        callSnippet = "Replace",
        displayContext = 5,
        keywordSnippet = "Replace",
      },
      workspace = {
        useGitIgnore = true,
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
      hint = { enable = true },
    },
  },
}

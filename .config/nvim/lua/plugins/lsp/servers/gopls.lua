return {
  settings = {
    gopls = {
      -- analyses = {
      --   unusedparams = true,
      -- },
      -- staticcheck = true, -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md#staticcheck-bool
      -- semanticTokens = true,
      usePlaceholders = true,
      completeFunctionCalls = true,
      analyses = {
        fillstruct = false,
        unusedparams = true,
      },
      gofumpt = true,
    },
  },
}

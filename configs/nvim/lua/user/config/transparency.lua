local set_transparency = function()
  local hl_groups = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "FloatBorder",
    "FloatTitle",
    "TelescopeNormal",
    "TelescopeBorder",
    "TelescopePromptNormal",
    "TelescopePromptBorder",
    "TelescopeResultsNormal",
    "TelescopeResultsBorder",
    "TelescopePreviewNormal",
    "TelescopePreviewBorder",
    "LspFloatWinNormal",
    "LspFloatWinBorder",
    "DiagnosticsError",
    "NormalSB",
    "SignColumn",
    "FoldColumn",
  }

  for _, hl in ipairs(hl_groups) do
    vim.api.nvim_set_hl(0, hl, { bg = "NONE", ctermbg = "NONE" })
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = set_transparency,
})

set_transparency()

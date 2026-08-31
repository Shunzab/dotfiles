-- Force Neovim to use transparent backgrounds (inherits Alacritty transparency)
local function apply_transparency()
  local transparent_groups = {
    "Normal",
    "NormalNC",
    "SignColumn",
    "NormalFloat",
    "FloatBorder",
    "EndOfBuffer",
  }
  for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
  end
end

apply_transparency()
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_transparency })

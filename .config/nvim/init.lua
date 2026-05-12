vim.opt.termguicolors = false
local function transparent_background()
  local groups = { "Normal", "NormalFloat", "NormalNC", "LineNr", "Folded", "NonText", "SignColumn" }
  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
 end
end

-- Esegui la funzione all'avvio e ogni volta che cambi colorscheme
transparent_background()
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = transparent_background,
})

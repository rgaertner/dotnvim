vim.g.tokyonight_sidebar = true
vim.g.tokyonight_transparent = true
vim.cmd("colorscheme tokyonight")

local status, _ = pcall(vim.cmd, "colorscheme tokyonight")
if not status then
  print("Colorscheme tokyonight not found!")
  return
end

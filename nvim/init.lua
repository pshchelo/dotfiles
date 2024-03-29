-- !! change core keymappings before that !!
-- setup lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  { "altercation/vim-colors-solarized", lazy=false, priority=1000 },
})
vim.cmd "colorscheme solarized"
vim.o.background = "dark" -- TODO: add toggle to switch between light and dark, <F5>

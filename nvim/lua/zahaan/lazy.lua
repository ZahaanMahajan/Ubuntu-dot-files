-- lua/zahaan/lazy.lua

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Leader keys (set BEFORE lazy loads)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  -- Import your plugin definitions
  { import = "zahaan.plugins" },
}, {
  -- UI
  ui = {
    border = "rounded",
  },

  -- Performance
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },

  -- Auto update checker
  checker = {
    enabled = false,
    notify = false,
  },

  -- Change detection (live reload)
  change_detection = {
    notify = false,
  },

  -- Install missing plugins automatically
  install = {
    missing = true,
    colorscheme = { "habamax" },
  },
})

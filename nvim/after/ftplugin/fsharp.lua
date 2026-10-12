vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4
vim.opt_local.autoindent = true

local select = require('nvim-treesitter-textobjects.select')

-- aA: select a complete function application
vim.keymap.set({ 'x', 'o' }, 'aA', function()
  select.select_textobject('@call.outer', 'textobjects')
end, {
  buffer = true,
  desc = 'F#: select function application',
})

-- aa: select an argument or parameter
vim.keymap.set({ 'x', 'o' }, 'aa', function()
  select.select_textobject('@parameter.outer', 'textobjects')
end, {
  buffer = true,
  desc = 'F#: select argument',
})

-- ia: select the inner part of an argument or parameter
vim.keymap.set({ 'x', 'o' }, 'ia', function()
  select.select_textobject('@parameter.inner', 'textobjects')
end, {
  buffer = true,
  desc = 'F#: select argument contents',
})

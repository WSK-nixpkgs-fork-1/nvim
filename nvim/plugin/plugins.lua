if vim.g.did_load_plugins_plugin then
  return
end
vim.g.did_load_plugins_plugin = true

-- many plugins annoyingly require a call to a 'setup' function to be loaded,
-- even with default configs

require('nvim-surround').setup()
require('which-key').setup()
require("conjure").setup() 

local npairs = require("nvim-autopairs")
local cond = require("nvim-autopairs.conds")

npairs.setup({
    enable_check_bracket_line = false,
})

npairs.get_rules("'")[1].not_filetypes = { "racket" }
vim.g.sexp_filetypes = "racket,lisp,scheme,clojure"

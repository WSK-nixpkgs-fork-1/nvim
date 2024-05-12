if vim.g.did_load_completion_plugin then
  return
end
vim.g.did_load_completion_plugin = true

local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

local function has_words_before()
  local unpack_ = unpack or table.unpack
  local line, col = unpack_(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

---@param source string|table
local function complete_with_source(source)
  if type(source) == 'string' then
    cmp.complete { config = { sources = { { name = source } } } }
  elseif type(source) == 'table' then
    cmp.complete { config = { sources = { source } } }
  end
end

cmp.setup {
  completion = {
    completeopt = 'menu,menuone,noinsert',
    -- autocomplete = false,
  },
  formatting = {
    format = lspkind.cmp_format {
      mode = 'symbol_text',
      with_text = true,
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

      menu = {
        buffer = '[BUF]',
        nvim_lsp = '[LSP]',
        nvim_lsp_signature_help = '[LSP]',
        nvim_lsp_document_symbol = '[LSP]',
        nvim_lua = '[API]',
        path = '[PATH]',
        luasnip = '[SNIP]',
      },
    },
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
      if cmp.visible() then
        local entry = cmp.get_selected_entry()
	      if not entry then
	        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
	      end
	      cmp.confirm()
      else
        fallback()
      end
    end, {"i","s","c",}),
    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i', 's', 'c'}),
    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i', 's', 'c'}),
  },
  sources = cmp.config.sources {
    -- The insertion order influences the priority of the sources
    { name = 'nvim_lsp', keyword_length = 3 },
    { name = 'nvim_lsp_signature_help', keyword_length = 3 },
    { name = 'buffer' },
    { name = 'path' },
  },
  enabled = function()
    return vim.bo[0].buftype ~= 'prompt'
  end,
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
}

cmp.setup.filetype('lua', {
  sources = cmp.config.sources {
    { name = 'nvim_lua' },
    { name = 'nvim_lsp', keyword_length = 3 },
    { name = 'path' },
  },
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'nvim_lsp_document_symbol', keyword_length = 3 },
    { name = 'buffer' },
    { name = 'cmdline_history' },
  },
  view = {
    entries = { name = 'wildmenu', separator = '|' },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources {
    { name = 'cmdline' },
    { name = 'cmdline_history' },
    { name = 'path' },
  },
})


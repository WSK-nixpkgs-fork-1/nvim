
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client and client.name == "ionide" then
            vim.lsp.inlay_hint.enable(true, {
                bufnr = args.buf,
            })
        end
    end,
})
-- 确保 filetype、ftplugin 和 indent 脚本都已启用
vim.cmd("filetype plugin indent on")

-- F# 缩进设置
vim.api.nvim_create_autocmd("FileType", {
    pattern = "fsharp",
    callback = function()
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.autoindent = true
    end,
})

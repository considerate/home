local opts = {noremap = true, silent = true}

vim.keymap.set('n', '<space>lh', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[l', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']l', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>lq', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', '<space>ll', vim.lsp.codelens.run, opts)

-- https://github.com/nvim-lua/lsp-status.nvim#all-together-now
local lsp_status = require('lsp-status')
lsp_status.config {current_function = false, show_filename = false}

local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- Add diagnostics to locations list
    -- https://gist.github.com/phelipetls/0aeb9f4aca9af25d9f45ee56e0c5a340?permalink_comment_id=4397599#gistcomment-4397599
    vim.api.nvim_create_autocmd('DiagnosticChanged', {
        callback = function(args)
            vim.diagnostic.setloclist({open = false})
        end
    })
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = {noremap = true, silent = true, buffer = bufnr}
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>ld', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>lr', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>la', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<space>lf', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>lt',
                   function() vim.lsp.buf.format {async = true} end, bufopts)

    lsp_status.on_attach(client, bufnr)
end

lsp_status.register_progress()

local lspconfig = require('lspconfig')
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.hls.setup {on_attach = on_attach, capabilities = cmp_capabilities}
lspconfig.nil_ls.setup {on_attach = on_attach, capabilities = cmp_capabilities}
lspconfig.pyright.setup {on_attach = on_attach, capabilities = cmp_capabilities}
lspconfig.rust_analyzer.setup {
    on_attach = on_attach,
    capabilities = cmp_capabilities
}
lspconfig.purescriptls.setup {
    on_attach = on_attach,
    capabilities = cmp_capabilities
}
lspconfig.ruff_lsp.setup {
    on_attach = on_attach,
    capabilities = cmp_capabilities
}

local cmp = require('cmp')

cmp.setup {
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, {'i', 's'}),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, {'i', 's'})
    }),
    sources = {{name = 'nvim_lsp'}, {name = 'buffer'}}
}

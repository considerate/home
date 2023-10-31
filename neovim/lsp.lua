local opts = {noremap = true, silent = true}
require("telescope").load_extension("ui-select")
local telescope = require("telescope.builtin")

vim.keymap.set('n', '<space>lh', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[l', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']l', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>lq', telescope.diagnostics, opts)
vim.keymap.set('n', '<space>ll', vim.lsp.codelens.run, opts)

-- https://github.com/nvim-lua/lsp-status.nvim#all-together-now
local lsp_status = require('lsp-status')
lsp_status.config {current_function = false, show_filename = false}
local lsp_sig = require('lsp_signature')

local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = {noremap = true, silent = true, buffer = bufnr}
    local format_buffer = function() vim.lsp.buf.format {async = true} end
    vim.keymap.set('n', '<space>lr', vim.lsp.codelens.refresh, bufopts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', telescope.lsp_definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', telescope.lsp_implementations, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>ld', telescope.lsp_type_definition, bufopts)
    vim.keymap.set('n', '<space>lr', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>la', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<space>lf', telescope.lsp_references, bufopts)
    vim.keymap.set('n', '<space>lt', format_buffer, bufopts)
    vim.keymap.set('n', '<space>lq', telescope.diagnostics, bufopts)

    vim.keymap.set({'n'}, '<space>ls', lsp_sig.toggle_float_win, bufopts)
    lsp_sig.on_attach({
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        handler_opts = {border = "rounded"}
    }, bufnr)
    vim.api.nvim_create_autocmd({"BufEnter", "CursorHold", "InsertLeave"}, {
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh
    })

    lsp_status.on_attach(client, bufnr)
end

lsp_status.register_progress()

local lspconfig = require('lspconfig')
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.hls.setup {
    on_attach = on_attach,
    capabilities = cmp_capabilities,
    settings = {
        codeLens = {enable = true},
        haskell = {
            plugin = {
                class = { -- missing class methods
                    codeLensOn = true
                },
                importLens = { -- make import lists fully explicit
                    codeLensOn = true
                },
                refineImports = { -- refine imports
                    codeLensOn = true
                },
                tactics = { -- wingman
                    codeLensOn = true
                },
                moduleName = { -- fix module names
                    globalOn = true
                },
                eval = { -- evaluate code snippets
                    globalOn = true,
                    codeLensOn = true
                },
                ['ghcide-type-lenses'] = { -- show/add missing type signatures
                    globalOn = false
                }
            }
        }
    }
}
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

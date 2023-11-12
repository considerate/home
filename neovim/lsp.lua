local telescope = require("telescope.builtin")

require'treesitter-context'.setup {
    mode = 'topline' -- Line used to calculate context. Choices: 'cursor', 'topline'
}

local lsp_lines = require("lsp_lines")
lsp_lines.setup()
-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({virtual_text = false})

local opts = function(extra)
    return vim.tbl_extend("force", {noremap = true, silent = true}, extra)
end
vim.keymap.set('n', '<space>lh', vim.diagnostic.open_float,
               opts({desc = "Open diagnostics"}))
vim.keymap.set('n', '[l', vim.diagnostic.goto_prev,
               opts({desc = "Go to previous diagnostic"}))
vim.keymap.set('n', ']l', vim.diagnostic.goto_next,
               opts({desc = "Go to next diagnostic"}))
vim.keymap.set('n', '<space>lr', vim.lsp.codelens.run,
               opts({desc = "Run code lens"}))
vim.keymap.set("", "<space>ll", lsp_lines.toggle,
               opts({desc = "Toggle lsp_lines"}))

-- https://github.com/nvim-lua/lsp-status.nvim#all-together-now
local lsp_status = require('lsp-status')
lsp_status.config {current_function = false, show_filename = false}
local lsp_sig = require('lsp_signature')

local attach_code_lens = function(client, bufnr)
    local status_ok, codelens_supported = pcall(function()
        return client.supports_method("textDocument/codeLens")
    end)
    if not status_ok or not codelens_supported then return end
    vim.api.nvim_create_autocmd({'BufEnter', 'CursorHold', 'InsertLeave'}, {
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh
    })
end

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
    local opt = function(extra)
        return vim.tbl_extend("force", bufopts, extra)
    end
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
                   opt({desc = "Go to declaration"}))
    vim.keymap.set('n', 'gd', telescope.lsp_definitions,
                   opt({desc = "Go to definition"}))
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opt({desc = "Hover"}))
    vim.keymap.set('n', 'gi', telescope.lsp_implementations,
                   opt({desc = "Show implementation"}))
    vim.keymap.set('n', 'gr', telescope.lsp_references,
                   opt({desc = "Go to reference(s)"}))
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help,
                   opt({desc = "Signature help"}))
    vim.keymap.set('n', '<space>ld', telescope.lsp_type_definitions,
                   opt({desc = "Show type definition"}))
    vim.keymap.set('n', '<space>la', vim.lsp.buf.code_action,
                   opt({desc = "Run code action"}))
    vim.keymap.set('n', '<space>lf', telescope.lsp_references,
                   opt({desc = "Go to references"}))
    vim.keymap.set('n', '<space>ls', lsp_sig.toggle_float_win,
                   opt({desc = "Toggle floating type signature"}))
    vim.keymap.set('n', '<space>ln', vim.lsp.buf.rename,
                   opt({desc = "Rename symbol"}))

    attach_code_lens(client, bufnr)
    lsp_status.on_attach(client, bufnr)

    lsp_sig.on_attach({
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        handler_opts = {border = "rounded"}
    }, bufnr)
    local format_buffer = function() vim.lsp.buf.format {async = true} end
    vim.keymap.set('n', '<space>lt', format_buffer, bufopts)
end

lsp_status.register_progress()

local lspconfig = require('lspconfig')
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local capabilities = vim.tbl_extend('keep', cmp_capabilities,
                                    lsp_status.capabilities)

lspconfig.hls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
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
lspconfig.nil_ls.setup {on_attach = on_attach, capabilities = capabilities}
lspconfig.pyright.setup {on_attach = on_attach, capabilities = capabilities}
lspconfig.rust_analyzer.setup {
    on_attach = on_attach,
    capabilities = capabilities
}
lspconfig.purescriptls.setup {
    on_attach = on_attach,
    capabilities = capabilities
}
lspconfig.ruff_lsp.setup {on_attach = on_attach, capabilities = capabilities}

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

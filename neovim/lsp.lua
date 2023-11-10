local opts = {noremap = true, silent = true}
require("telescope").load_extension("ui-select")
require('telescope').load_extension('media_files')
local telescope = require("telescope.builtin")

require("trouble").setup {
    mode = "quickfix",
    auto_open = true, -- automatically open the list when you have diagnostics
    auto_close = true -- automatically close the list when you have no diagnostics
}
require'treesitter-context'.setup {
    mode = 'topline' -- Line used to calculate context. Choices: 'cursor', 'topline'
}

require("lsp_lines").setup()
-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({virtual_text = false})

vim.keymap.set('n', '<space>lh', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[l', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']l', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>lq', telescope.diagnostics, opts)
vim.keymap.set('n', '<space>ll', vim.lsp.codelens.run, opts)

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

require('neotest').setup {
    -- ...,
    adapters = {
        -- ...,
        require('neotest-haskell')
    }
}

local trbl = require("trouble")
vim.keymap.set("n", "<leader>xx", function() trbl.toggle() end)
vim.keymap.set("n", "<leader>xw",
               function() trbl.toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd",
               function() trbl.toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() trbl.toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() trbl.toggle("loclist") end)
vim.keymap.set("n", "gR", function() trbl.toggle("lsp_references") end)

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
    vim.keymap.set('n', 'gd', telescope.lsp_definitions, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', telescope.lsp_implementations, bufopts)
    vim.keymap.set('n', 'gr', telescope.lsp_references, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>ld', telescope.lsp_type_definitions, bufopts)
    vim.keymap.set('n', '<space>la', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<space>lf', telescope.lsp_references, bufopts)
    vim.keymap.set('n', '<space>lq', telescope.diagnostics, bufopts)
    vim.keymap.set('n', '<space>ls', lsp_sig.toggle_float_win, bufopts)
    vim.keymap.set('n', '<space>lr', vim.lsp.codelens.refresh, bufopts)
    vim.keymap.set('n', '<space>ln', vim.lsp.buf.rename, bufopts)

    attach_code_lens(client, bufnr)
    trouble()
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

local trouble = require("trouble.providers.telescope")

require"telescope".setup {
    defaults = {
        vimgrep_arguments = {
            "rg", "-L", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case"
        },
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
                results_width = 0.8
            },
            vertical = {mirror = false},
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120
        },
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_ignore_patterns = {"node_modules"},
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = {"truncate"},
        winblend = 0,
        border = {},
        borderchars = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
        color_devicons = true,
        set_env = {["COLORTERM"] = "truecolor"}, -- default = nil,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
        mappings = {
            n = {
                ["q"] = require("telescope.actions").close,
                ["<c-t>"] = trouble.open_with_trouble
            },
            i = {["<c-t>"] = trouble.open_with_trouble}
        }
    },

    extensions_list = {"themes", "terms", "fzf"},
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case"
        }
    }
}

require("trouble").setup {
    mode = "quickfix",
    auto_open = true, -- automatically open the list when you have diagnostics
    auto_close = true -- automatically close the list when you have no diagnostics
}
local trbl = require("trouble")
vim.keymap.set("n", "<leader>xx", function() trbl.toggle() end,
               {desc = "Toggle trouble"})
vim.keymap.set("n", "<leader>xw",
               function() trbl.toggle("workspace_diagnostics") end,
               {desc = "Trouble workspace_diagnostics"})
vim.keymap.set("n", "<leader>xd",
               function() trbl.toggle("document_diagnostics") end,
               {desc = "Trouble document_diagnostics"})
vim.keymap.set("n", "<leader>xq", function() trbl.toggle("quickfix") end,
               {desc = "Trouble quickfix"})
vim.keymap.set("n", "<leader>xl", function() trbl.toggle("loclist") end,
               {desc = "Trouble, loclist"})
vim.keymap.set("n", "gR", function() trbl.toggle("lsp_references") end,
               {desc = "Trouble lsp_references"})

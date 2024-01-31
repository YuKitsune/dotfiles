local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
-- local util = require "lsbconfig/util"

-- lspconfig.rust_analyzer.setup({
--     on_attach = on_attach,
--     capabilities = capabilities,
--     filetypes = {"rust"},
--     root_dir = lspconfig.util.root_pattern("Cargo.toml"),
--     settings = {
--         ['rust-analyzer'] = {
--             cargo = {
--                 allFeatures = true,
--             }
--         }
--     }
-- })

local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local options = {
    -- Plugin configuration
    tools = {
    },
    -- LSP configuration
    server = {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
            },
        },
    },
    -- DAP configuration
    dap = {
    },
}

return options
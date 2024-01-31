local plugins = {
    -- Ensures certain binaries required for other plugins are installed
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "rust-analyzer",
                "lldb",
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "plugins.configs.lspconfig"
            require "custom.configs.lspconfig"
        end
    },
    {
        "rust-lang/rust.vim",
        ft = "rust",
        init = function ()
            vim.g.rustfmt_autosave = 1
        end
    },
    {
        "mrcjkb/rustaceanvim",
        version = '^4', -- Recommended
        ft = "rust",
        dependencies = "nvim/nvim-lspconfig",
        opts = function ()
            return require "custom.configs.rust-tools"
        end
    },
    {
        "mfussenegger/nvim-dap"
    }
}

return plugins

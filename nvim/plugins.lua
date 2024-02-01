local plugins = {
    -- Ensures certain binaries required for other plugins are installed
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },

    -- Ensures certain binaries required for other plugins are installed
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "rust-analyzer",
                "gopls",
            },
        },
    },

    -- Language Server Protocol
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "plugins.configs.lspconfig"
            require "custom.configs.lspconfig"
        end
    },

    -- Debug Adapter Protocol
    {
        "mfussenegger/nvim-dap",
        init = function()
            require("core.utils").load_mappings("dap")
        end
    },

    -- Rust

    -- Rust: rustfmt on save
    {
        "rust-lang/rust.vim",
        ft = "rust",
        init = function ()
            vim.g.rustfmt_autosave = 1
        end
    },

    -- Rust LSP
    -- Todo: Migrate since this is deprecated
    {
        "simrat39/rust-tools.nvim",
        ft = "rust",
        dependencies = "neovim/nvim-lspconfig",
        opts = function ()
            return require "custom.configs.rust-tools"
        end,
        config = function(_, opts)
            require('rust-tools').setup(opts)
        end
    },
    
    -- Go

    -- Run gofmt on save
    {
        "jose-elias-alvarez/null-ls.nvim",
        ft = "go",
        opts = function()
            return require("custom.configs.null-ls")
        end
    },

    -- Better completions, iferr snippets, auto add struct tags (for JSON)
    -- TODO: Read the docs
    {
        "olexsmir/gopher.nvim",
        ft = "go",
        config = function(_, opts)
            require("gopher").setup()
        end,
        build = function()
            vim.cmd [[silent! GoInstallDeps]]
        end
    },

    -- DAP support using Delve for debugging go
    {
        -- "leoluz/nvim-dap-go",
        "dreamsofcode-io/nvim-dap-go",
        ft = "go",
        dependencies = "mfussenegger/nvim-dap",
        config = function(_, opts)
            require("dap-go").setup(opts)
            require("core.utils").load_mappings("dap_go")
        end
    },
}

return plugins

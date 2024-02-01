local M = {}

-- CTRL + hjkl to move between panes
M.general = {
    n = {
        ["<C-h>"] = { "<cmd> TmuxNavigateLeft<CR>", "window left" },
        ["<C-l>"] = { "<cmd> TmuxNavigateRight<CR>", "window right" },
        ["<C-j>"] = { "<cmd> TmuxNavigateDown<CR>", "window down" },
        ["<C-k>"] = { "<cmd> TmuxNavigateUp<CR>", "window up" },
    }
}

M.dap = {
    plugin = true,

    -- Normal mode bindings (Hence the N)
    n = {
        ["<leader>db"] = { 
            function ()
                require('dap').toggle_breakpoint();
            end,
            "Toggle breakpoint"
        },
        ["<leader>dus"] = {
            function ()
                local widgets = require('dap.ui.widgets');
                local sidebar = widgets.sidebar(widgets.scopes);
                sidebar.open();
            end,
            "Open debugging sidebar"
        }

        -- TODO: Step over and Step into commands
    }
}

M.dap_go = {
    plugin = true,

    -- Normal mode bindings (Hence the N)
    n = {
        ["<leader>gdt"] = { 
            function ()
                require('dap-go').debug_test();
            end,
            "Debug go test",
        },
        ["<leader>gdl"] = {
            function ()
                require('dap-go').debug_last();
            end,
            "Debug last go test",
        }
    }
}

return M
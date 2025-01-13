return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "folke/lazydev.nvim",
                ft = "lua", -- only load on lua files
                opts = {
                    library = {
                        -- See the configuration section for more details
                        -- Load luvit types when the `vim.uv` word is found
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
            {
                'saghen/blink.cmp',
            },
        },
        opts = {
            servers = {
                lua_ls = {},
                pyright = {},
                clangd = {},
                -- bashls = {},
            }
        },
        config = function(_, opts)
            local lspconfig = require('lspconfig')
            for server, config in pairs(opts.servers) do
                -- passing config.capabilities to blink.cmp merges with the capabilities in your
                -- `opts[server].capabilities, if you've defined it
                config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
                lspconfig[server].setup(config)
            end

            -- local lsp_defaults = lspconfig.util.default_config
            -- lsp_defaults.capabilities = vim.tbl_deep_extend('force', lsp_defaults.capabilities,
            --     require('cmp_nvim_lsp').default_capabilities())
            -- lspconfig.lua_ls.setup {}
            -- lspconfig.lua_ls.setup {
            --     settings = {
            --         Lua = {
            --             diagnostics = {
            --                 globals = { 'vim' }
            --             }
            --         }
            --     }
            -- }
            -- lspconfig.clangd.setup {}
            -- lspconfig.pyright.setup {}

            -- vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            -- vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
            -- vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
            -- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
        end,
    }
}

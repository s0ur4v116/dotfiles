return {
    "nvim-treesitter/nvim-treesitter",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "c", "cpp", "lua", "python", "vim", "vimdoc", "query", "json"},
            auto_install = false,
            highlight = {
                enable = true,
                disable = {"tmux"}
            },
            indent = {
                enable = true,
            },
        })
    end,
}

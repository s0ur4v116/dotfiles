return {
    "nvim-treesitter/nvim-treesitter",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "c", "cpp", "lua", "python", "vim", "vimdoc", "query" },
            auto_install = false,
            highlight = {
                enable = true,
                disable = {"tmux"}
            },
        })
    end,
}

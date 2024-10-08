return {
    "ellisonleao/gruvbox.nvim",
    config = function()
        require("gruvbox").setup({
            italic = {
                strings = false,
                emphasis = false,
                comments = true,
                operators = false,
                folds = false,
            },
            transparent_mode = true,
        })
    end,
}

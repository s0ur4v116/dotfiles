local state = {
    floating = {
        buf = -1,
        win = -1,
    }
}

local function create_floating_window(opts)
    local screen_width = vim.o.columns
    local screen_height = vim.o.lines

    local width = opts and opts.width or math.floor(screen_width * 0.8)
    local height = opts and opts.height or math.floor(screen_height * 0.8)

    local row = math.floor((screen_height - height) / 2)
    local col = math.floor((screen_width - width) / 2)

    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true)
    end

    local win_opts = {
        relative = "editor", -- Place the window relative to the entire editor
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal", -- Minimal UI (no borders, etc.)
        border = "solid"
    }

    local win = vim.api.nvim_open_win(buf, true, win_opts)

    return { buf = buf, win = win }
end

local toggle_terminal = function()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = create_floating_window({ buf = state.floating.buf })
        if vim.bo[state.floating.buf].buftype ~= "terminal" then
            vim.cmd.terminal()
        end
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
end

vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
vim.keymap.set({"n", "t"}, "<leader>tt", toggle_terminal)

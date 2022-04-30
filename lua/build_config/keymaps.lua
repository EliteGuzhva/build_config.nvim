local util = require("build_config.util")

local M = {}

M.apply_keymaps = function ()
    vim.g.bc_config = util.parse_config(vim.g.bc_config_path)
    if vim.g.bc_config == nil then
        return nil
    end

    local opts = vim.g.bc_config["keymaps"]

    if opts == nil then
        return
    end

    for module, commands in pairs(opts) do
        for command, keymap in pairs(commands) do
            local cmd = "<cmd>lua require('build_config." .. module .. "')." .. command .. "()<CR>"
            vim.api.nvim_set_keymap("n", keymap, cmd, { noremap = true })
        end
    end
end

return M

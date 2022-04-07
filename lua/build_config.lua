local util = require("build_config.util")

local M = {}

M.setup = function (opts)
    vim.g.bc_config_path = ".build_config.json"
    if opts["config_path"] ~= nil then
        vim.g.bc_config_path = opts["config_path"]
    end

    vim.g.bc_config = util.parse_config(vim.g.bc_config_path)
end

return M

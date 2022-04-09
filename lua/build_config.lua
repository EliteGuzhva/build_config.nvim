local util = require("build_config.util")

local M = {}

M.setup = function (opts)
    vim.g.bc_config_path = util.value_or(opts["config_path"], ".build_config.json")
    vim.g.bc_config = util.parse_config(vim.g.bc_config_path)

    vim.g.dc_config = {}
    vim.g.dc_container_name = ""
    vim.g.dc_did_launch = false
end

return M

local util = require("build_config.util")

local M = {}

M.parse_config = function ()
    local config = {}

    vim.g.bc_config = util.parse_config(vim.g.bc_config_path)
    local build_dir = util.value_or(vim.g.bc_config["build_dir"], "build")
    local opts = vim.g.bc_config["conan"]

    if opts == nil then
        return nil
    end

    config.exe = util.value_or(opts["exe"], "conan")
    config.install_dir = util.value_or(opts["install_dir"], build_dir)
    config.target = util.value_or(opts["target"], ".")
    config.args = util.value_or(opts["args"], {})

    return config
end

M.install = function ()
    local config = M.parse_config()

    local command = {
        config.exe,
        "install",
        "-if",
        config.install_dir,
        config.target
    }
    util.concat(command, config.args)

    util.execute_command(command)
end

return M

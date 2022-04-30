local util = require("build_config.util")

local M = {}

M.parse_config = function ()
    local config = {}

    vim.g.bc_config = util.parse_config(vim.g.bc_config_path)
    if vim.g.bc_config == nil then
        return nil
    end

    local opts = vim.g.bc_config["launch"]

    if opts == nil then
        util.log_error("Provide `launch` section")
        return nil
    end

    config.cwd = util.value_or(opts["cwd"], ".")
    config.exe = util.value_or(opts["exe"], nil)
    config.args = util.value_or(opts["args"], {})
    config.before_script = util.value_or(opts["before_script"], nil)

    return config
end

M.compose_command = function (config)
    if config.exe == nil then
        util.log_error("Provide `launch.exe`")
        return nil
    end

    local command = {}

    if config.before_script ~= nil then
        table.insert(command, config.before_script)
    end

    table.insert(command, "./" .. config.exe)
    util.concat(command, config.args)

    return command
end

M.launch = function ()
    local config = M.parse_config()
    if config == nil then
        return
    end

    local command = M.compose_command(config)
    if command == nil then
        return
    end

    util.execute_command(command, config.cwd, 2)
end

return M

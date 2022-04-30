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
        vim.notify("Provide `launch` section")
        return nil
    end

    config.cwd = util.value_or(opts["cwd"], ".")
    config.cmd = util.value_or(opts["cmd"], "")
    config.args = util.value_or(opts["args"], {})
    config.before_script = util.value_or(opts["before_script"], nil)

    return config
end

M.compose_command = function (config)
    local command = {}

    if config.before_script ~= nil then
        table.insert(command, config.before_script)
    end

    table.insert(command, config.cmd)
    util.concat(command, config.args)

    return command
end

M.launch = function ()
    local config = M.parse_config()
    if config == nil then
        return
    end

    local command = M.compose_command(config)

    util.execute_command(command, config.cwd, 2)
end

return M

local util = require("build_config.util")

local M = {}

M.parse_config = function ()
    local config = {}
    local opts = BUILD_CONFIG["launch"]

    if opts == nil then
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
    local command = M.compose_command(config)

    util.execute_command(config.cwd, command)
end

return M

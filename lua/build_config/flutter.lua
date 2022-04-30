local util = require("build_config.util")

local M = {}

M.default_exe = "flutter"
M.default_build_type = "debug"

M.parse_config = function ()
    local config = {}

    vim.g.bc_config = util.parse_config(vim.g.bc_config_path)
    if vim.g.bc_config == nil then
        return nil
    end

    local section = "flutter"
    local opts = vim.g.bc_config[section]

    if opts == nil then
        util.log_error("Provide `" .. section .. "` section")
        return nil
    end

    config.exe = util.value_or(opts["exe"], M.default_exe)
    config.device = util.value_or(opts["device"], nil)
    config.build_type = util.value_or(opts["build_type"], M.default_build_type)
    config.target = util.value_or(opts["target"], nil)
    config.build_variant = util.value_or(opts["build_variant"], nil)
    config.args = util.value_or(opts["args"], {})

    return config
end

M.doctor = function ()
    local config = M.parse_config()

    local exe = M.default_exe
    local args = {}
    if config ~= nil then
        exe = config["exe"]
        args = config["args"]
    end

    local command = {
        exe,
        "doctor"
    }
    util.concat(command, args)

    util.execute_command(command)
end

M.devices = function ()
    local config = M.parse_config()

    local exe = M.default_exe
    local args = {}
    if config ~= nil then
        exe = config["exe"]
        args = config["args"]
    end

    local command = {
        exe,
        "devices"
    }
    util.concat(command, args)

    util.execute_command(command)
end

M.run = function ()
    local config = M.parse_config()

    local exe = M.default_exe
    local device = nil
    local build_type = M.default_build_type
    local target = nil
    local args = {}

    if config ~= nil then
        exe = config["exe"]
        device = config["device"]
        build_type = config["build_type"]
        target = config["target"]
        args = config["args"]
    end

    local command = {
        exe,
        "run",
        "--" .. build_type
    }

    util.add_option(command, "-d", device)
    util.add_option(command, "-t", target)
    util.concat(command, args)

    util.execute_command(command)
end

M.build = function ()
    local config = M.parse_config()

    local exe = M.default_exe
    local device = nil
    local build_variant = nil
    local args = {}

    if config ~= nil then
        exe = config["exe"]
        device = config["device"]
        build_variant = config["build_variant"]
        args = config["args"]
    end

    if build_variant == nil then
        util.log_error("Provide `flutter.build_variant`")
        return
    end

    local command = {
        exe,
        "build",
        build_variant
    }

    util.add_option(command, "-d", device)
    util.concat(command, args)

    util.execute_command(command)
end

M.test = function ()
    local config = M.parse_config()

    local exe = M.default_exe
    local device = nil
    local args = {}

    if config ~= nil then
        exe = config["exe"]
        device = config["device"]
        args = config["args"]
    end

    local command = {
        exe,
        "test"
    }

    util.add_option(command, "-d", device)
    util.concat(command, args)

    util.execute_command(command)
end

M.clean = function ()
    local config = M.parse_config()

    local exe = M.default_exe
    local device = nil
    local args = {}

    if config ~= nil then
        exe = config["exe"]
        device = config["device"]
        args = config["args"]
    end

    local command = {
        exe,
        "clean"
    }

    util.add_option(command, "-d", device)
    util.concat(command, args)

    util.execute_command(command)
end

M.pub_get = function ()
    local config = M.parse_config()

    local exe = M.default_exe
    local args = {}

    if config ~= nil then
        exe = config["exe"]
        args = config["args"]
    end

    local command = {
        exe,
        "pub",
        "get"
    }

    util.concat(command, args)

    util.execute_command(command)
end

M.pub_upgrade = function ()
    local config = M.parse_config()

    local exe = M.default_exe
    local args = {}

    if config ~= nil then
        exe = config["exe"]
        args = config["args"]
    end

    local command = {
        exe,
        "pub",
        "upgrade"
    }

    util.concat(command, args)

    util.execute_command(command)
end

return M

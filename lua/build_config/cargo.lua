local util = require("build_config.util")

local M = {}

M.default_exe = "cargo"

M.parse_config = function ()
    local config = {}

    vim.g.bc_config = util.parse_config(vim.g.bc_config_path)
    if vim.g.bc_config == nil then
        return nil
    end

    local opts = vim.g.bc_config["cargo"]

    if opts == nil then
        return nil
    end

    config.exe = util.value_or(opts["exe"], M.default_exe)
    config.bin = util.value_or(opts["bin"], nil)
    config.install_dir = util.value_or(opts["install_dir"], nil)
    config.args = util.value_or(opts["args"], {})

    return config
end

M.run = function ()
    local config = M.parse_config()

    local exe = M.default_exe
    local bin = nil
    local args = {}
    if config ~= nil then
        exe = config["exe"]
        bin = config["bin"]
        args = config["args"]
    end

    local command = {
        exe,
        "run"
    }

    util.add_option(command, "--bin", bin)
    util.concat(command, args)

    util.execute_command(command)
end

M.build = function ()
    local config = M.parse_config()

    local exe = M.default_exe
    local args = {}
    if config ~= nil then
        exe = config["exe"]
        args = config["args"]
    end

    local command = {
        exe,
        "build"
    }

    util.concat(command, args)

    util.execute_command(command)
end

M.install = function ()
    local config = M.parse_config()

    local exe = M.default_exe
    local install_dir = nil
    local args = {}
    if config ~= nil then
        exe = config["exe"]
        install_dir = config["install_dir"]
        args = config["args"]
    end

    local command = {
        exe,
        "install"
    }

    util.add_option(command, "--path", install_dir)
    util.concat(command, args)

    util.execute_command(command)
end

M.clean = function ()
    local config = M.parse_config()

    local exe = M.default_exe
    local args = {}
    if config ~= nil then
        exe = config["exe"]
        args = config["args"]
    end

    local command = {
        exe,
        "clean"
    }

    util.concat(command, args)

    util.execute_command(command)
end

return M

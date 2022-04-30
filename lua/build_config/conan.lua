local util = require("build_config.util")

local M = {}

M.parse_config = function ()
    local config = {}

    vim.g.bc_config = util.parse_config(vim.g.bc_config_path)
    if vim.g.bc_config == nil then
        return nil
    end

    local build_dir = util.value_or(vim.g.bc_config["build_dir"], "build")
    local opts = vim.g.bc_config["conan"]

    if opts == nil then
        vim.notify("Provide `conan` section")
        return nil
    end

    config.exe = util.value_or(opts["exe"], "conan")
    config.install_folder = util.value_or(opts["install_folder"], build_dir)
    config.build = util.value_or(opts["build"], nil)
    config.path = util.value_or(opts["path"], ".")
    config.reference = util.value_or(opts["reference"], nil)
    config.args = util.value_or(opts["args"], {})

    return config
end

M.install = function ()
    local config = M.parse_config()
    if config == nil then
        return
    end

    local command = {
        config.exe,
        "install",
        "-if",
        config.install_folder
    }

    if config.build ~= nil then
        util.concat(command, {"-b", config.build})
    end

    util.concat(command, config.args)
    util.concat(command, {config.path})

    util.execute_command(command)
end

M.create = function ()
    local config = M.parse_config()
    if config == nil then
        return
    end

    if config.reference == nil then
        vim.notify("Provide `conan.reference`")
        return
    end

    local command = {
        config.exe,
        "create"
    }

    if config.build ~= nil then
        util.concat(command, {"-b", config.build})
    end

    util.concat(command, config.args)
    util.concat(command, {config.path, config.reference})

    util.execute_command(command)
end

return M

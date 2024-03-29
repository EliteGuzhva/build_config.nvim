local util = require("build_config.util")

local M = {}

M.parse_config = function ()
    local config = {}

    vim.g.bc_config = util.parse_config(vim.g.bc_config_path)
    if vim.g.bc_config == nil then
        return nil
    end

    local build_dir = util.value_or(vim.g.bc_config["build_dir"], "build")

    local build_type = "Release"
    if vim.g.bc_config["cmake"] ~= nil then
        build_type = util.value_or(vim.g.bc_config["cmake"]["build_type"], build_type)
    end

    local opts = vim.g.bc_config["conan"]
    if opts == nil then
        util.log_error("Provide `conan` section")
        return nil
    end

    config.exe = util.value_or(opts["exe"], "conan")
    config.build_type = util.value_or(opts["build_type"], build_type)
    config.install_folder = util.value_or(opts["install_folder"], build_dir)
    config.output_folder = util.value_or(opts["output_folder"], build_dir)
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
        config.install_folder,
        "-of",
        config.output_folder
    }

    if config.build ~= nil then
        util.concat(command, {"-b", config.build})
    end

    if config.build_type ~= nil then
        util.concat(command, {"-s", "build_type=" .. config.build_type})
    end

    util.concat(command, config.args)
    table.insert(command, config.path)

    util.execute_command(command)
end

M.create = function ()
    local config = M.parse_config()
    if config == nil then
        return
    end

    if config.reference == nil then
        util.log_error("Provide `conan.reference`")
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

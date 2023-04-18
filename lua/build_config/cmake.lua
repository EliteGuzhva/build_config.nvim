local util = require("build_config.util")

local M = {}

M.parse_config = function ()
    local config = {}

    vim.g.bc_config = util.parse_config(vim.g.bc_config_path)
    if vim.g.bc_config == nil then
        return nil
    end

    config.build_dir = util.value_or(vim.g.bc_config["build_dir"], "build")
    local opts = vim.g.bc_config["cmake"]

    if opts == nil then
        util.log_error("Provide `cmake` section")
        return nil
    end

    config.exe = util.value_or(opts["exe"], "cmake")
    config.build_type = util.value_or(opts["build_type"], "Debug")
    config.export_compile_commands = util.value_or(opts["export_compile_commands"], true)
    config.generator = util.value_or(opts["generator"], nil)
    config.generate_options = util.value_or(opts["generate_options"], {})
    config.build_options = util.value_or(opts["build_options"], {})
    config.install_prefix = util.value_or(opts["install_prefix"], "./install")
    config.target = util.value_or(opts["target"], "all")
    config.preset = util.value_or(opts["preset"], nil)

    return config
end

M.configure = function ()
    local config = M.parse_config()
    if config == nil then
        return
    end

    local command = {
        config.exe,
        ".",
        "-B",
        config.build_dir
    }

    if config.preset ~= nil then
        util.concat(command, { "--preset", config.preset })
    end

    if config.generator ~= nil then
        util.concat(command, { "-G", config.generator })
    end

    if config.export_compile_commands == true then
        table.insert(command, "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON")
    end

    table.insert(command, "-DCMAKE_BUILD_TYPE=" .. config.build_type)

    util.concat(command, config.generate_options)

    util.execute_command(command)
end

M.build = function ()
    local config = M.parse_config()
    if config == nil then
        return
    end

    local command = {
        config.exe,
        "--build",
        config.build_dir,
        "--target",
        config.target,
        "--"
    }
    util.concat(command, config.build_options)

    util.execute_command(command)
end

M.install = function ()
    local config = M.parse_config()
    if config == nil then
        return
    end

    local command = {
        config.exe,
        "--install",
        config.build_dir,
        "--prefix",
        config.install_prefix
    }
    util.concat(command, config.build_options)

    util.execute_command(command)
end

M.clean = function ()
    local config = M.parse_config()
    if config == nil then
        return
    end

    local command = {
        config.exe,
        "--build",
        config.build_dir,
        "--target",
        "clean",
        "--"
    }
    util.concat(command, config.build_options)

    util.execute_command(command)
end

M.link_compile_commands = function ()
    local config = M.parse_config()
    if config == nil then
        return
    end

    local command = {
        "ln -s",
        config.build_dir .. "/compile_commands.json",
        "./"
    }

    util.execute_command(command)
end

return M

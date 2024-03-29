local util = require("build_config.util")

local M = {}

M.default_exe = "python"

M.parse_config = function ()
    local config = {}

    vim.g.bc_config = util.parse_config(vim.g.bc_config_path)
    if vim.g.bc_config == nil then
        return nil
    end

    local opts = vim.g.bc_config["python"]

    if opts == nil then
        return nil
    end

    config.exe = util.value_or(opts["exe"], M.default_exe)
    config.venv = util.value_or(opts["venv"], nil)
    config.cwd = util.value_or(opts["cwd"], ".")
    config.script = util.value_or(opts["script"], nil)
    config.args = util.value_or(opts["args"], {})

    return config
end

M.pip_install_requirements = function ()
    local config = M.parse_config()

    local req_file = "requirements.txt"
    if not vim.loop.fs_stat(req_file) then
        util.log_error("Couldn't find `" .. req_file .. "` file")
        return
    end

    local exe = M.default_exe
    local venv = nil
    if config ~= nil then
        exe = config["exe"]
        venv = config["venv"]
    end

    if venv ~= nil then
        local command = {
            "source",
            venv .. "/bin/activate"
        }
        util.execute_command(command)
    end

    local command = {
        exe,
        "-m",
        "pip",
        "install",
        "-r",
        "requirements.txt"
    }

    util.execute_command(command)
end

M.compose_command = function (config)
    if config.script == nil then
        util.log_error("Provide `python.script`")
        return nil
    end

    local command = {
        config.exe,
        config.script
    }

    util.concat(command, config.args)

    return command
end

M.run = function ()
    local config = M.parse_config()
    if config == nil then
        return
    end

    local term_id = util.secondary_term_id

    if config.venv ~= nil then
        local command = {
            "source",
            config.venv .. "/bin/activate"
        }
        util.execute_command(command, ".", term_id)
    end

    local command = M.compose_command(config)
    if command == nil then
        return
    end

    util.execute_command(command, config.cwd, term_id)
end

return M

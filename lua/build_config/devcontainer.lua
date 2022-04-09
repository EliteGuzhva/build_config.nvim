local util = require("build_config.util")

local M = {}

M.parse_config = function ()
    local config = {}

    vim.g.dc_config = util.parse_config(".devcontainer/devcontainer.json")
    local opts = vim.g.dc_config

    if opts == nil then
        return nil
    end

    if opts["image"] ~= nil then
        config.image = opts["image"]
    end

    if opts["dockerFile"] ~= nil then
        config.dockerFile = opts["dockerFile"]
        config.image = "neovim_devcontainer"
    end

    config.context = util.value_or(opts["context"], ".")

    if opts["workspaceFolder"] ~= nil then
        config.workspaceMount = opts["workspaceMount"]
        config.workspaceFolder = opts["workspaceFolder"]
    else
        config.workspaceMount = "source=$PWD,target=/workspace,type=bind,consistency=cached"
        config.workspaceFolder = "/workspace"
    end

    vim.g.dc_container_name = "neovim_devcontainer_" .. config.image

    return config
end

M.build_container = function ()
    local config = M.parse_config()

    local command = {
        "docker",
        "build",
        "-f",
        ".devcontainer/" .. config.dockerFile,
        ".devcontainer/" .. config.context,
        "-t",
        config.image
    }

    util.execute_command(command)
end

M.launch_container = function ()
    local config = M.parse_config()

    local command = {
        "docker",
        "run",
        "-itd",
        "--mount",
        config.workspaceMount,
        "-w",
        config.workspaceFolder,
        "--name",
        vim.g.dc_container_name,
        config.image
    }
    util.execute_command(command, ".", 1, false)

    command = {
        "docker",
        "start",
        vim.g.dc_container_name
    }
    util.execute_command(command, ".", 1, false)

    util.execute_command({"exit"}, ".", 1, false)

    vim.g.dc_did_launch = true
    require("toggleterm.config").set({
        shell = "docker exec -it " .. vim.g.dc_container_name .. " /bin/bash"
    })

    vim.cmd([[
        augroup Devcontainer
        autocmd VimLeave * lua require("build_config.devcontainer").stop_container()
        augroup END
    ]])

    vim.notify("Launched devcontainer " .. vim.g.dc_container_name)
end

M.stop_container = function ()
    vim.notify("Stopping devcontainer " .. vim.g.dc_container_name .. "...")

    local stop_cmd = "silent !docker stop " .. vim.g.dc_container_name
    vim.cmd(stop_cmd)

    vim.g.dc_did_launch = false
    require("toggleterm.config").set({
        shell = vim.o.shell
    })

    vim.cmd([[
        autocmd! Devcontainer
    ]])

    vim.notify("Stopped devcontainer " .. vim.g.dc_container_name)
end

return M

local M = {}

M.parse_config = function (config_path)
    if vim.loop.fs_stat(config_path) then
        local json = vim.fn.readfile(config_path)
        return vim.fn.json_decode(json)
    else
        return {}
    end
end

M.execute_command = function (command, cwd, term_id)
    local status_ok, term = pcall(require, "toggleterm")
    if not status_ok then
        print("Couldn't find toggleterm")
        return
    end

    cwd = cwd or "."
    term_id = term_id or 1

    command = table.concat(command, " ")
    term.exec(command, term_id, 10, cwd, "horizontal", false)
end

M.concat = function (a, b)
---@diagnostic disable-next-line: undefined-field
    table.foreach(b, function(_, v) table.insert(a, v) end)
end

M.value_or = function (optional, default_value)
    if optional ~= nil then
        return optional
    else
        return default_value
    end
end

return M

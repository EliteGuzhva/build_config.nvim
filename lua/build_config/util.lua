local M = {}

M.execute_command = function (cwd, command, term_id)
    local status_ok, term = pcall(require, "toggleterm")
    if not status_ok then
        print("Couldn't find toggleterm")
        return
    end

    term_id = term_id or 1

    command = table.concat(command, " ")
    term.exec(command, term_id, 10, cwd, "horizontal", false)
end

M.concat = function (a, b)
    table.foreach(b, function(k, v) table.insert(a, v) end)
end

M.value_or = function (optional, default_value)
    if optional ~= nil then
        return optional
    else
        return default_value
    end
end

return M

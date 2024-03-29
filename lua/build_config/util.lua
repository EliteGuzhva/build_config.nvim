local M = {}

M.log_title = "build_config.nvim"
M.main_term_id = 200
M.secondary_term_id = 201

M.log = function(text, level)
    vim.notify(text, level, { title = M.log_title })
end

M.log_info = function(text)
    M.log(text, "info")
end

M.log_warn = function(text)
    M.log(text, "warn")
end

M.log_error = function(text)
    M.log(text, "error")
end

M.parse_config = function(config_path)
	if vim.loop.fs_stat(config_path) then
		local json = vim.fn.readfile(config_path)
		return vim.fn.json_decode(json)
	else
		return nil
	end
end

M.execute_command = function(command, cwd, term_id, open)
	local status_ok, term = pcall(require, "toggleterm")
	if not status_ok then
		M.log_error("Couldn't find toggleterm")
		return
	end

	local size = 10
	local direction = "horizontal"
	local go_back = false

	term_id = term_id or M.main_term_id
    open = open == nil or open

	command = table.concat(command, " ")

    term.exec(command, term_id, size, cwd, direction, "command", go_back, open)
end

M.concat = function(a, b)
	---@diagnostic disable-next-line: undefined-field
	table.foreach(b, function(_, v)
		table.insert(a, v)
	end)
end

M.value_or = function(optional, default_value)
	if optional ~= nil then
		return optional
	else
		return default_value
	end
end

M.add_option = function(command, option, value)
	if value ~= nil then
		M.concat(command, {
            option,
            value
        })
    end
end

return M

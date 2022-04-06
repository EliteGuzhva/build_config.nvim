local M = {}

M.setup = function (opts)
    local path_to_config = ".build_config.json"
    if opts["path_to_config"] ~= nil then
        path_to_config = opts["path_to_config"]
    end

    if not vim.loop.fs_stat(path_to_config) then
        return nil
    end

    local json = vim.fn.readfile(path_to_config)
    BUILD_CONFIG = vim.fn.json_decode(json)
end

return M

local M = {}
local persistence = require("persistence")
local pickers = require("telescope.pickers")
local Config = require("persistence.config")
local finders = require("telescope.finders")

local function getModificationDate(filePath)
    local modTime = vim.fn.getftime(filePath)
    return tonumber(modTime)
end

local function simple_name_from_path(path)
    local path_parts = vim.split(path, "/")
    local last_path = path_parts[#path_parts] or path
    last_path = last_path:gsub(".vim", "")
    local name_parts = vim.split(last_path, "%%")
    local name = name_parts[#name_parts] or last_path
    return name
end

local function sort_session_files_by_date(sessions)
    local sorted = {}
    for _, session in pairs(sessions) do
        table.insert(sorted, session)
    end
    table.sort(sorted, function(a, b)
        return getModificationDate(a) > getModificationDate(b)
    end)
    local new_sorted = {}
    for i = 1, 10, 1 do
        table.insert(new_sorted, sorted[i])
    end
    sorted = new_sorted
    return sorted
end

local function load_session_file(session_file)
    local e = vim.fn.fnameescape
    if type(Config.options.pre_load) == "function" then
        Config.options.pre_load()
    end

    vim.cmd("silent! source " .. e(session_file))

    if type(Config.options.post_load) == "function" then
        Config.options.post_load()
    end
end

function M.pick_recent_sessions_with_telescope()
    local sessions = persistence.list()
    local sorted = sort_session_files_by_date(sessions)
    local clean_sorted = {}
    for _, session in pairs(sorted) do
        local clean_path = simple_name_from_path(session)
        table.insert(clean_sorted, clean_path)
    end
    opts = {
        layout_config = {
            width = 0.6,
            height = 0.6,
        },
        layout_strategy = "center",
        prompt_title = "Recent projects",
        preview_title = "Preview",
        previewer = false,
        winblend = 10,
        border = true,
        sorting_strategy = "ascending",
    }
    pickers
        .new(opts, {
            prompt_title = "Recent projects",
            finder = finders.new_table({
                results = clean_sorted,
            }),
            sorter = require("telescope.config").values.generic_sorter(opts),
            attach_mappings = function()
                local load_session = function()
                    local selection =
                        require("telescope.actions.state").get_selected_entry()
                    if selection then
                        local session_file = sorted[selection.index]
                        load_session_file(session_file)
                    end
                end
                require("telescope.actions").select_default:replace(
                    load_session
                )
                return true
            end,
        })
        :find()
end
return M

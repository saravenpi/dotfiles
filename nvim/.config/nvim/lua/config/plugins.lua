local M = {}

local config_path = vim.fn.stdpath("config")
package.path = package.path .. ";" .. config_path .. "/?.lua"

local function scan_plugins_dir()
	local plugins_path = vim.fn.stdpath("config") .. "/lua/config/plugins"
	local handle = vim.loop.fs_scandir(plugins_path)

	if not handle then
		return {}
	end

	local plugin_files = {}

	repeat
		local entry_name, entry_type = vim.loop.fs_scandir_next(handle)
		if entry_name and entry_type == "file" and entry_name:match("%.lua$") then
			local filename_without_ext = entry_name:gsub("%.lua$", "")
			plugin_files[#plugin_files + 1] = filename_without_ext
		end
	until not entry_name

	return plugin_files
end

function M.get_specs()
	local plugins = {}
	local plugin_files = scan_plugins_dir()

	for _, plugin_file in ipairs(plugin_files) do
		local ok, plugin_module = pcall(require, "config.plugins." .. plugin_file)
		if ok and plugin_module and plugin_module.specs then
			for _, spec in ipairs(plugin_module.specs) do
				table.insert(plugins, spec)
			end
		else
			vim.notify("Failed to load plugin specs: " .. plugin_file, vim.log.levels.WARN)
		end
	end

	return plugins
end

function M.setup_all()
	local plugin_files = scan_plugins_dir()

	for _, plugin_file in ipairs(plugin_files) do
		local ok, plugin_module = pcall(require, "config.plugins." .. plugin_file)
		if ok and plugin_module and plugin_module.setup then
			plugin_module.setup()
		end
	end
end

-- Auto-load and setup plugins when module is required
vim.pack.add(M.get_specs())
M.setup_all()

return M


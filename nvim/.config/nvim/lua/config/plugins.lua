-- Spec source for lazy.nvim.
-- Scans lua/config/plugins/*.lua and merges every returned spec table into one
-- list, which lazy.nvim installs.
-- See https://lazy.folke.io/spec/spec_source for the spec import contract.

local plugins = {}

local function scan_plugins_dir()
	local plugins_path = vim.fn.stdpath("config") .. "/lua/config/plugins"
	local uv = vim.uv or vim.loop
	local handle = uv.fs_scandir(plugins_path)

	if not handle then
		return {}
	end

	local plugin_files = {}
	repeat
		local entry_name, entry_type = uv.fs_scandir_next(handle)
		if entry_name and entry_type == "file" and entry_name:match("%.lua$") then
			plugin_files[#plugin_files + 1] = entry_name:gsub("%.lua$", "")
		end
	until not entry_name

	return plugin_files
end

for _, plugin_file in ipairs(scan_plugins_dir()) do
	local ok, plugin_module = pcall(require, "config.plugins." .. plugin_file)
	if ok and plugin_module then
		for _, spec in ipairs(plugin_module) do
			plugins[#plugins + 1] = spec
		end
	else
		vim.notify("Failed to load plugin specs: " .. plugin_file, vim.log.levels.WARN)
	end
end

return plugins
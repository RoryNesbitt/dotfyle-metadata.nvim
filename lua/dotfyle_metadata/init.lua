local get_plugins = require("dotfyle_metadata.plugins")
local get_mapleader = require("dotfyle_metadata.mapleader")
local get_keymaps = require("dotfyle_metadata.keymaps")
local get_servers = require("dotfyle_metadata.extras.lsp")
local get_mason_tools = require("dotfyle_metadata.extras.mason")

local M = {}
local dotfyle_path = string.format("%s/dotfyle.json", vim.fn.stdpath("config"))

function M.generate()
	local plugin_manager, plugins = get_plugins()

	-- Json structure
	local dotfyle_ref = {
		["leaderKey"] = get_mapleader(),
		["pluginManager"] = plugin_manager,
		["plugins"] = plugins,
		["keymaps"] = get_keymaps(),
		["lspServers"] = get_servers(),
		["masonTools"] = get_mason_tools(),
	}

	local json = vim.json.encode(dotfyle_ref)
	vim.fn.writefile({ json }, dotfyle_path)

	vim.notify("[dotfyle] dotfyle.json generated!", nil, nil)
	vim.cmd(string.format("edit %s", dotfyle_path))

	-- TODO: Try something else instead of this complexity
	if vim.fn.executable("jq") == 1 then
		vim.cmd("%!jq")
		vim.cmd("write")
	elseif vim.fn.executable("prettier") == 1 then
		vim.cmd("%!prettier --no-color --stdin --stdin-filepath %")
		vim.cmd("write")
	elseif vim.fn.has("python3") == 1 then
		vim.cmd("%!python3 -m json.tool")
		vim.cmd("write")
	end
end

return M

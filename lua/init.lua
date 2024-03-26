local main = require("main.lua")

local M = {}

M.setup = function()
	vim.api.nvim_set_keymap(
		"n",
		"<leader>tl",
		'<cmd>lua require("main").list_tasks(vim.fn.getcwd())<CR>',
		{ noremap = true, silent = true }
	)
end

local fn = vim.fn

local M = {}

local function create_todo_file()
	local project_name = fn.fnamemodify(fn.getcwd(), ":t")
	local todo_file = fn.getcwd() .. "/.todo"
	local todo_file_exists = fn.filereadable(todo_file) == 1

	if not todo_file_exists then
		local file = io.open(todo_file, "w")
		file:write(project_name .. "\n")
		file:close()
	end
end

local function get_todo_list()
	local todo_file = fn.getcwd() .. "/.todo"
	local todo_file_exists = fn.filereadable(todo_file) == 1

	if not todo_file_exists then
		return {}
	end

	local todo_list = {}
	for line in io.lines(todo_file) do
		table.insert(todo_list, line)
	end

	return todo_list
end

local function add_todo()
	local project_name = fn.fnamemodify(fn.getcwd(), ":t")
	local todo_file = fn.getcwd() .. "/.todo"
	local todo_file_exists = fn.filereadable(todo_file) == 1

	if not todo_file_exists then
		create_todo_file()
	end

	local task = fn.input("Task: ")
	local priority = fn.input("Priority (1-5): ")

	local file = io.open(todo_file, "a")
	file:write(task .. " " .. priority .. "\n")
	file:close()
end

local function remove_todo()
	local project_name = fn.fnamemodify(fn.getcwd(), ":t")
	local todo_file = fn.getcwd() .. "/.todo"
	local todo_file_exists = fn.filereadable(todo_file) == 1

	if not todo_file_exists then
		return
	end

	local todo_list = get_todo_list()
	local task = fn.input("Task to remove: ")

	local file = io.open(todo_file, "w")
	for _, line in ipairs(todo_list) do
		if not string.match(line, task) then
			file:write(line .. "\n")
		end
	end
	file:close()
end

local function list_todo()
	local todo_list = get_todo_list()

	for _, line in ipairs(todo_list) do
		print(line)
	end
end

function M.todo()
	local todo_commands = {
		add = add_todo,
		remove = remove_todo,
		list = list_todo,
	}

	local command = fn.input("Command (add, remove, list): ")
	todo_commands[command]()
end

return M

-- Make it compativle with LazyVim plugin manager

-- Path: lua/init.lua
-- Create command

local todo = require("todo")

vim.cmd([[command! -nargs=0 Todo lua require('todo').todo()]])

-- Keymap
vim.api.nvim_set_keymap("n", "<leader>td", ":Todo<CR>", { noremap = true, silent = true })


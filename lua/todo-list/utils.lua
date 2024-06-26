local M = {}

-- Util functions for a TODO list plugin
--
--
-- Write a neovim plugin that keeps a list of things to do and their priorities.
-- This should be per-project.
-- Easily add, remove, and list tasks.
-- Easy key bindings to quickly open the todo list.
-- Todo list should be in a floating window.
--
-- The todo list should be a table with the following structure:
-- {
--  project_name = {
--  {
--  task = "task",
--  priority = "priority",
--  },
--  },
--  }
--  The priority should be a number from 1 to 5.
--  The todo list should be saved in a file in the project directory.
--  If the current root directory does not contain a todo file, the plugin should create one at startup.
-- Main file is init.lua

-- Function to create a todo file if it does not exist
function M.create_todo_file()
	local todo_file = vim.fn.expand("%:p:h") .. "/todo.txt"
	if vim.fn.filereadable(todo_file) == 0 then
		local file = io.open(todo_file, "w")
		file:write("Project: \n")
		file:close()
	end
end

-- Function to add a task to the todo list
function M.add_task(task)
	local todo_file = vim.fn.expand("%:p:h") .. "/todo.txt"
	local file = io.open(todo_file, "a")

	-- Task will be a "string" and priority will be an integer
	-- We need to get the string between the quotes
	-- We can use string.match to get the string between the quotes

	task = string.match(task, '"(.-)"')

	-- Priority will then be anything not in the quotes
	priority = 5

	file:write("Task: " .. task .. " Priority: " .. priority .. "\n")
	file:close()
end

-- Function to list all tasks in the todo list
function M.list_tasks()
	-- Open tasks in a buffer that we can then display in a floating window
	-- This will allow us to delete tasks from the list easily, as well as add new tasks

	local todo_file = vim.fn.expand("%:p:h") .. "/todo.txt"
	local file = io.open(todo_file, "r")
	local tasks = {}
	for line in file:lines() do
		if string.match(line, "Task:") then
			table.insert(tasks, line)
		end
	end

	-- Open a floating window to display the tasks
	-- We can use the floating window to add and remove tasks

	-- Create a new buffer
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
	vim.api.nvim_buf_set_option(buf, "swapfile", false)
	vim.api.nvim_buf_set_option(buf, "buflisted", false)
	vim.api.nvim_buf_set_option(buf, "filetype", "todo")

	-- Set the buffer content
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, tasks)

	-- Create a new window
	local width = vim.api.nvim_get_option("columns")
	local height = vim.api.nvim_get_option("lines")
	local win_height = math.ceil(height * 0.8 - 4)
	local win_width = math.ceil(width * 0.8)
	local row = math.ceil((height - win_height) / 2 - 1)
	local col = math.ceil((width - win_width) / 2)
	-- Add shadow to the floating window
	local opts = {
		style = "minimal",
		relative = "editor",
		width = win_width,
		height = win_height,
		row = row,
		col = col,
		border = "shadow",
	}

	local win = vim.api.nvim_open_win(buf, true, opts)
	vim.api.nvim_win_set_option(win, "winblend", 0)

	-- Close the file
	file:close()

	return tasks
end

-- Function to remove a task from the todo list
function M.remove_task(task)
	local todo_file = vim.fn.expand("%:p:h") .. "/todo.txt"
	local file = io.open(todo_file, "r")
	local lines = {}
	for line in file:lines() do
		if not string.match(line, task) then
			table.insert(lines, line)
		end
	end
	file:close()
	file = io.open(todo_file, "w")
	for _, line in ipairs(lines) do
		file:write(line .. "\n")
	end
	file:close()
end

-- Create commands to add, list, and remove tasks. Also to create a new todo file if we want to force it.
vim.cmd([[command! -nargs=+ AddTask lua require("todo-list.utils").add_task(<f-args>)]])
vim.cmd([[command! ListTasks lua print(vim.inspect(require("todo-list.utils").list_tasks()))]])
vim.cmd([[command! -nargs=1 RemoveTask lua require("todo-list.utils").remove_task(<f-args>)]])
vim.cmd([[command! CreateTodoFile lua require("todo-list.utils").create_todo_file()]])

return M

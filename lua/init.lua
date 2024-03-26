local M = {}

-- Define the file name to save todo lists
local TODO_FILE_NAME = "todo_list.json"

-- Function to load todo list from file
local function load_todo_list(project_path)
	local file_path = project_path .. "/" .. TODO_FILE_NAME
	local file = io.open(file_path, "r")
	if file then
		local content = file:read("*a")
		file:close()
		return vim.fn.json_decode(content)
	else
		return {}
	end
end

-- Function to save todo list to file
local function save_todo_list(project_path, todo_list)
	local file_path = project_path .. "/" .. TODO_FILE_NAME
	local file = io.open(file_path, "w")
	if file then
		file:write(vim.fn.json_encode(todo_list))
		file:close()
	end
end

-- Function to add a task to todo list
function M.add_task(project_path, task, priority)
	local todo_list = load_todo_list(project_path)
	table.insert(todo_list, { task = task, priority = priority })
	save_todo_list(project_path, todo_list)
end

-- Function to remove a task from todo list
function M.remove_task(project_path, index)
	local todo_list = load_todo_list(project_path)
	table.remove(todo_list, index)
	save_todo_list(project_path, todo_list)
end

-- Function to list tasks in todo list
function M.list_tasks(project_path)
	local todo_list = load_todo_list(project_path)
	for i, task in ipairs(todo_list) do
		print(i .. ". " .. task.task .. " (Priority: " .. task.priority .. ")")
	end
end

-- Key binding to open todo list in a floating window
vim.api.nvim_set_keymap(
	"n",
	"<leader>tl",
	'<cmd>lua require("todo").list_tasks(vim.fn.getcwd())<CR>',
	{ noremap = true, silent = true }
)

return M

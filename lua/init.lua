-- Our main plugin file, where we set up the plugin and define the commands.

local utils = require("todo-list.plugin.utils")

local M = {}

function M.setup()
	utils.create_todo_file()
end

function M.add_task(task, priority)
	utils.add_task(task, priority)
end

function M.list_tasks()
	return utils.list_tasks()
end

function M.remove_task(task)
	utils.remove_task(task)
end

print("Todo list plugin loaded")

return M

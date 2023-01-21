local dap_status, dap = pcall(require, "dap")
if not dap_status then
	print("dap not loaded!")
	return
end

local dapui_status, dapui = pcall(require, "dapui")
if not dapui_status then
	print("dapui not loaded!")
	return
end

dapui.setup({
	floating = { border = "rounded" },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

local dap_vscode_js_status, dap_vscode_js = pcall(require, "dap-vscode-js")
if not dap_vscode_js_status then
	print("js debugger not loaded!")
	return
end

local result = dap_vscode_js.setup({
	-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
	debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter", -- Path to vscode-js-debug installation.
	debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
	adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
	-- log_file_path = vim.fn.stdpath("cache") .. "/dap_vscode_js.log", -- Path for file logging
	log_file_level = vim.log.levels.DEBUG, -- Logging level for output to file. Set to false to disable file logging.
	log_console_level = vim.log.levels.DEBUG, -- Logging level for output to console. Set to false to disable console output.
})

--[[ dap.adapters["pwa-node"] = {
	type = "executable",
	command = "node",
	args = {
		os.getenv("HOME") .. ".local/share/nvim/mason/packages/js-debug-adapter/out/src/debugServerMain.js",
		"45635",
	},
} ]]

for _, language in ipairs({ "typescript", "javascript" }) do
	dap.configurations[language] = {
		{
			--[[ {
				type = "pwa-node",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				cwd = "${workspaceFolder}",
			}, ]]
			{
				-- type = "pwa-node",
				type = "pwa-node",
				request = "attach",
				name = "Attach",
				processId = require("dap.utils").pick_process,
				-- processId = 23027,
				cwd = "${workspaceFolder}",
				port = 9123,
				-- websocketAddress = "ws://127.0.0.1:9123/34826453-fae3-4054-a6b8-8ac0e00ce3bc",
			},
			--[[ {
				type = "pwa-node",
				request = "launch",
				name = "Debug Jest Tests",
				-- trace = true, -- include debugger info
				runtimeExecutable = "node",
				runtimeArgs = {
					"./node_modules/jest/bin/jest.js",
					"--runInBand",
				},
				rootPath = "${workspaceFolder}",
				cwd = "${workspaceFolder}",
				console = "integratedTerminal",
				internalConsoleOptions = "neverOpen",
			}, ]]
		},
	}
end

dap.set_log_level("DEBUG")

vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })
vim.fn.sign_define(
	"DapBreakpoint",
	{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
	"DapBreakpointCondition",
	{ text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
	"DapBreakpointRejected",
	{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
	"DapLogPoint",
	{ text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
)
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

-- vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "" })
-- vim.fn.sign_define("DapStopped", { text = "", texthl = "", linehl = "", numhl = "" })

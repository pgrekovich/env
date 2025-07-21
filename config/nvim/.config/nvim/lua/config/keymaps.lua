local keymap = vim.keymap.set
if vim.g.vscode then
  -- general keymaps
  keymap({ "n", "v" }, "<leader>e", "<cmd>lua require('vscode').action('workbench.action.toggleSidebarVisibility')<CR>")
  keymap({ "n", "v" }, "<leader>E", "<cmd>lua require('vscode').action('workbench.view.explorer')<CR>")
  keymap({ "n", "v" }, "<leader>t", "<cmd>lua require('vscode').action('workbench.action.terminal.toggleTerminal')<CR>")
  keymap({ "n", "v" }, "<leader>b", "<cmd>lua require('vscode').action('editor.debug.action.toggleBreakpoint')<CR>")
  keymap({ "n", "v" }, "<leader>ca", "<cmd>lua require('vscode').action('editor.action.quickFix')<CR>")
  keymap({ "n", "v" }, "gr", "<cmd>lua require('vscode').action('editor.action.goToReferences')<CR>")
  keymap({ "n", "v" }, "<leader>gg", "<cmd>lua require('vscode').action('workbench.view.scm')<CR>")

  -- harpoon keymaps
  keymap({ "n", "v" }, "<leader>H", "<cmd>lua require('vscode').action('vscode-harpoon.addEditor')<CR>")
  keymap({ "n", "v" }, "<leader>h", "<cmd>lua require('vscode').action('vscode-harpoon.editorQuickPick')<CR>")
  keymap({ "n", "v" }, "<leader>HE", "<cmd>lua require('vscode').action('vscode-harpoon.editEditors')<CR>")
  keymap({ "n", "v" }, "<leader>1", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor1')<CR>")
  keymap({ "n", "v" }, "<leader>2", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor2')<CR>")
  keymap({ "n", "v" }, "<leader>3", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor3')<CR>")
  keymap({ "n", "v" }, "<leader>4", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor4')<CR>")
  keymap({ "n", "v" }, "<leader>5", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor5')<CR>")
else
  keymap("x", "<leader>p", [["_dP]])
  keymap({ "n", "v" }, "<leader>d", '"_d')
end

return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    opts = {
      view = {
        -- Configure the layout for the merge tool
        merge_tool = {
          -- "diff3_mixed" = Ours/Theirs on top, Result on bottom (VS Code style)
          layout = "diff3_mixed",
          disable_diagnostics = true,
        },
      },
    },
    keys = {
      -- Open the 3-pane merge view
      { "<leader>gr", "<cmd>DiffviewOpen<cr>", desc = "Diff View (Merge)" },
      -- Open file history (great for seeing how a file changed over time)
      { "<leader>gR", "<cmd>DiffviewFileHistory<cr>", desc = "Diff File History" },
    },
  },
}

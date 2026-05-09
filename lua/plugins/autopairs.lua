return {
  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    opts = {},
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "scheme",
        callback = function()
          vim.b.minipairs_disable = true
        end,
      })
    end,
  },
}

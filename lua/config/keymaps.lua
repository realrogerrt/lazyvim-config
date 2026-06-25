-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "jj", "<ESC>")

-- Search the current visual selection on Amazon internal code search.
local function url_encode(str)
  return (str:gsub("([^%w%-_%.~])", function(c)
    return string.format("%%%02X", string.byte(c))
  end))
end

local function search_selection_on_code_amazon()
  -- Yank the visual selection into register v, preserving the unnamed register.
  local saved_reg = vim.fn.getreg('"')
  local saved_regtype = vim.fn.getregtype('"')
  vim.cmd('noautocmd normal! "vy')
  local selection = vim.fn.getreg("v")
  vim.fn.setreg('"', saved_reg, saved_regtype)

  -- Collapse newlines/whitespace runs into single spaces and trim.
  selection = selection:gsub("[\r\n]+", " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
  if selection == "" then
    vim.notify("No selection to search", vim.log.levels.WARN)
    return
  end

  local url = "https://code.amazon.com/search?exact=" .. url_encode(selection)
  vim.fn.jobstart({ "open", url }, { detach = true })
end

vim.keymap.set(
  "x",
  "<leader>so",
  search_selection_on_code_amazon,
  { desc = "Code search selection on code.amazon.com" }
)

local server_js = vim.fn.expand(
  "~/.vscode/extensions/mchpatr.datapath-language-server-0.61.0/server/out/server.js"
)

local function noop_handler(_, _, _, _)
  return vim.NIL
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        datapath = {
          cmd = { "node", server_js, "--stdio" },
          filetypes = { "datapath" },
          root_dir = function(fname)
            return vim.fs.root(fname, { "package.json", "Config", ".git" })
              or vim.fs.dirname(fname)
          end,
          single_file_support = true,
          handlers = {
            ["datapath/diagnostics"] = noop_handler,
            ["workspace/diagnostic/refresh"] = noop_handler,
          },
          settings = {
            ["datapath-language-server"] = {
              watcher = false,
              ["go-to-reference"] = false,
              ["go-to-implementations"] = true,
              diagnostics = true,
              ["file-system"] = false,
              ["test-explorer"] = false,
            },
          },
        },
      },
      setup = {
        datapath = function(_, opts)
          if vim.fn.filereadable(server_js) == 0 then
            vim.notify(
              "Datapath LSP not found at " .. server_js .. " — install the VS Code extension first.",
              vim.log.levels.WARN
            )
            return true
          end
          require("lspconfig.configs").datapath = {
            default_config = {
              cmd = opts.cmd,
              filetypes = opts.filetypes,
              root_dir = opts.root_dir,
              single_file_support = opts.single_file_support,
              settings = opts.settings,
              handlers = opts.handlers,
            },
          }
          require("lspconfig").datapath.setup(opts)
          return true
        end,
      },
    },
  },
}

return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      local java21 = "/Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk/Contents/Home/bin/java"
      local lombok_jar = vim.fn.expand("$MASON/share/jdtls/lombok.jar")

      opts.cmd = {
        vim.fn.exepath("jdtls"),
        "--java-executable", java21,
        "--jvm-arg=-javaagent:" .. lombok_jar,
      }

      -- Find the Brazil workspace root (directory containing src/)
      -- so JDTLS sees all sibling packages and resolves cross-project refs
      opts.root_dir = function(path)
        -- First try: find a .classpath going upward
        local cp_root = vim.fs.root(path, { ".classpath" })
        if cp_root then
          -- Go up to the workspace root if we're inside src/PackageName/
          local ws_root = cp_root:match("(.+)/src/[^/]+$")
          if ws_root then return ws_root end
          return cp_root
        end
        return vim.fs.root(path, { "Config" })
          or vim.fs.root(path, vim.lsp.config.jdtls.root_markers)
      end

      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          configuration = {
            runtimes = {
              { name = "JavaSE-17", path = "/Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Home", default = true },
            },
          },
          import = { gradle = { enabled = false }, maven = { enabled = false } },
        },
      })
      opts.handlers = {
        ["$/progress"] = function() end,  -- silence all jdtls progress
      }
    end,
  },
}

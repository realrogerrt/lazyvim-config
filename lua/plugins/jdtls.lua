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

      opts.root_dir = function(path)
        -- Brazil workspace: .classpath -> walk up to workspace root
        local cp_root = vim.fs.root(path, { ".classpath" })
        if cp_root then
          local ws_root = cp_root:match("(.+)/src/[^/]+$")
          if ws_root then return ws_root end
          return cp_root
        end
        -- Standard Java projects
        return vim.fs.root(path, { "build.gradle", "build.gradle.kts", "pom.xml" })
          or vim.fs.root(path, { "Config" })
          or vim.fs.root(path, { ".git", ".project" })
      end

      local is_brazil = vim.fs.root(vim.fn.getcwd(), { "Config" }) ~= nil

      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          configuration = {
            runtimes = {
              { name = "JavaSE-17", path = "/Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Home" },
              { name = "JavaSE-21", path = "/Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk/Contents/Home", default = true },
            },
          },
          import = {
            gradle = { enabled = not is_brazil },
            maven = { enabled = not is_brazil },
          },
        },
      })
      opts.jdtls = vim.tbl_deep_extend("force", opts.jdtls or {}, {
        handlers = {
          ["$/progress"] = function() end,
          ["textDocument/publishDiagnostics"] = function() end,
          ["language/status"] = function() end,
          ["window/logMessage"] = function() end,
          ["window/showMessage"] = function() end,
        },
      })
    end,
  },
}

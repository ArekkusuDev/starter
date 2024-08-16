local jdtls_ok, jdtls = pcall(require, "jdtls")
local mason_get = require("mason-registry").get_package

-- constants
local JDTLS = "jdtls"
local JAVA_DEBUG_ADAPTER = "java-debug-adapter"
local JAVA_TEST = "java-test"

-- jdtls and nvim-jdtls must be installed previously
if not mason_get(JDTLS):is_installed() then
  return print "jdtls not found, run :MasonInstall jdtls"
elseif not jdtls_ok then
  return print "nvim-jdtls not installed: https://github.com/mfussenegger/nvim-jdtls"
end

--- nvchad stuff
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
---
local java_cmds = vim.api.nvim_create_augroup("java_cmds", { clear = true })

local function enable_codelens(bufnr)
  pcall(vim.lsp.codelens.refresh)

  vim.api.nvim_create_autocmd("BufWritePost", {
    buffer = bufnr,
    group = java_cmds,
    desc = "Refresh codelens",
    callback = function()
      pcall(vim.lsp.codelens.refresh)
    end,
  })
end

local jdtls_on_attach = function(_, bufnr)
  -- beside the nvchad on_attach, we also need to do some java specific
  on_attach(_, bufnr)

  -- https://github.com/NvChad/NvChad/blob/c40c5116c4c091f4da620abcd9c58bd5ee4b8497/lua/nvchad/configs/lspconfig.lua#L6
  local function opts(desc)
    return { buffer = bufnr, desc = "JDTLS " .. desc }
  end

  -- java specific
  enable_codelens(bufnr)

  -- keymaps
  vim.keymap.set("n", "<A-o>", function()
    require(JDTLS).organize_imports()
  end, opts "java organize imports")
end

-- expand nvim dat_home and go to mason share dir
local jdtls_path = mason_get(JDTLS):get_install_path()

local bundles = {}
if mason_get(JAVA_DEBUG_ADAPTER):is_installed() and mason_get(JAVA_TEST):is_installed() then
  -- java debug
  local debug_adapter = mason_get(JAVA_DEBUG_ADAPTER):get_install_path()
  local debug_bundle = vim.fn.split(vim.fn.glob(debug_adapter .. "/extension/server/*.jar"), "\n")

  if debug_bundle[1] ~= "" then
    vim.list_extend(bundles, debug_bundle)
  end

  -- java test
  local java_test_path = mason_get(JAVA_TEST):get_install_path()
  local java_test_bundle = vim.fn.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n")

  if java_test_bundle[1] ~= "" then
    vim.list_extend(bundles, java_test_bundle)
  end
end
-- get user local dir to save java workspaces
local java_data_dir = os.getenv "HOME" .. "/.local/share/java_workspaces/"

local path = {
  java_agent = jdtls_path .. "/lombok.jar",
  launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
  config_platform = jdtls_path .. "/config_linux",
}

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = java_data_dir .. project_name

local jdtls_cmd = {
  "java",
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.protocol=true",
  "-Dlog.level=ALL",
  "-javaagent:" .. path.java_agent,
  "-Xmx1g",
  "--add-modules=ALL-SYSTEM",
  "--add-opens",
  "java.base/java.util=ALL-UNNAMED",
  "--add-opens",
  "java.base/java.lang=ALL-UNNAMED",

  -- skull lol
  "-jar",
  path.launcher_jar,

  -- another skull lmao
  "-configuration",
  path.config_platform,

  -- data path
  "-data",
  workspace_dir,
}

local settings = {
  java = {
    -- jdt = {
    --   ls = {
    --     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
    --   }
    -- },
    eclipse = { downloadSources = true },
    configuration = { updateBuildConfiguration = "interactive" },
    maven = { downloadSources = true },
    implementationsCodeLens = { enabled = true },
    referencesCodeLens = { enabled = true },
    references = { includeDecompiledSources = true },
    -- inlayHints = {
    --   parameterNames = {
    --     enabled = 'all' -- literals, all, none
    --   }
    -- },
    format = { enabled = true },
  },
  signatureHelp = { enabled = true },
  contentProvider = { preferred = "fernflower" },
  extendedClientCapabilities = extendedClientCapabilities,
  codeGeneration = {
    toString = {
      template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
    },
    useBlocks = true,
  },
  flags = {
    allow_incremental_sync = true,
    server_side_fuzzy_completion = true,
  },
}

local config = {
  cmd = jdtls_cmd,
  settings = settings,
  on_init = on_init,
  on_attach = jdtls_on_attach,
  capabilities = capabilities,
  root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
  init_options = { bundles = bundles },
}

jdtls.start_or_attach(config)

---@brief
---
--- Flutter / Dart Language Server (analysis_server)

-- ============================================================================
-- Environment
-- ============================================================================

local flutter_sdk = os.getenv("FLUTTER_ROOT")

if not flutter_sdk then
  error("FLUTTER_ROOT is not set. Please set it to your Flutter SDK path.")
end

-- ============================================================================
-- Paths
-- ============================================================================

local analysis_server =
  flutter_sdk .. "/bin/cache/dart-sdk/bin/snapshots/analysis_server.dart.snapshot"

-- ============================================================================
-- LSP Configuration
-- ============================================================================

---@type vim.lsp.Config
return {
  cmd = {
    "dart",
    analysis_server,
    "--lsp",
  },
  filetypes = { "dart" },
  root_markers = { "pubspec.yaml" },
  init_options = {
    onlyAnalyzeProjectsWithOpenFiles = true,
    suggestFromUnimportedLibraries = true,
    closingLabels = true,
    outline = true,
    flutterOutline = true,
  },

  settings = {
    dart = {
      completeFunctionCalls = true,
      showTodos = true,
    },
  },
}

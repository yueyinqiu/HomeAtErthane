{ ... }:
{
  programs.vscode.profiles.default.userSettings = {
    "[python]" = {
      "editor.autoClosingQuotes" = "languageDefined";
      "editor.autoIndent" = "advanced";
    };
    "python.analysis.autoFormatStrings" = true;
    "python.analysis.autoImportCompletions" = true;
    "python.analysis.diagnosticMode" = "workspace";
    "python.analysis.inlayHints.functionReturnTypes" = true;
    "python.analysis.inlayHints.pytestParameters" = true;
    "python.analysis.typeCheckingMode" = "standard";
    "python.terminal.activateEnvironment" = false;
    "flake8.enabled" = false;
    "debugpy.debugJustMyCode" = false;
  };
}

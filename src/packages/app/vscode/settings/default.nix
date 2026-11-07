{ ... }:
{
  programs.vscode.profiles.default = {
    mutableUserSettings = true;

    userSettings = {
      "workbench.colorTheme" = "Visual Studio 2019 Dark (Extracted From C# Extension)";
      "editor.semanticTokenColorCustomizations" = {
        "[Visual Studio 2019 Dark (Extracted From C# Extension)]" = {
          rules = {
            "builtinConstant:python" = "#569CD6";
          };
        };
      };

      "workbench.activityBar.location" = "top";
      "workbench.secondarySideBar.defaultVisibility" = "hidden";

      "editor.acceptSuggestionOnCommitCharacter" = false;
      "editor.autoClosingBrackets" = "never";
      "editor.autoClosingDelete" = "never";
      "editor.autoClosingQuotes" = "never";
      "editor.autoIndentOnPaste" = true;
      "editor.copyWithSyntaxHighlighting" = false;
      "editor.formatOnPaste" = true;
      "editor.formatOnType" = true;
      "editor.largeFileOptimizations" = false;
      "editor.minimap.autohide" = "mouseover";
      "editor.minimap.enabled" = false;
      "workbench.editor.enablePreview" = false;
      "workbench.tree.enableStickyScroll" = false;
      "diffEditor.ignoreTrimWhitespace" = false;

      "explorer.autoReveal" = false;
      "explorer.compactFolders" = false;
      "explorer.copyPathSeparator" = "/";
      "explorer.copyRelativePathSeparator" = "/";
      "explorer.fileNesting.enabled" = true;
      "explorer.sortOrder" = "type";

      "files.autoSave" = "afterDelay";
      "files.autoSaveWorkspaceFilesOnly" = true;
      "files.hotExit" = "off";

      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.decorations.enabled" = false;
      "git.enableSmartCommit" = true;
      "scm.compactFolders" = false;

      "debug.inlineValues" = "off";
      "debug.terminal.clearBeforeReusing" = true;

      "terminal.integrated.enablePersistentSessions" = false;
      "terminal.integrated.initialHint" = false;
      "terminal.integrated.persistentSessionReviveProcess" = "never";
      "terminal.integrated.stickyScroll.enabled" = false;

      "window.restoreWindows" = "none";

      "chat.disableAIFeatures" = true;
    };
  };
}

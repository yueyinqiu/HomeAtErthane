{ ... }:
{
  # i don't really install latex locally
  # check https://github.com/yueyinqiu/HomeYueyinqiuAtLabG3080Nix/blob/main/src/packages/vscode-server/languages/latex.nix
  programs.vscode.profiles.default.userSettings = {
    "[latex]" = {
      "editor.formatOnPaste" = false;
      "editor.suggestSelection" = "recentlyUsedByPrefix";
      "editor.wordWrap" = "on";
    };
  };
}

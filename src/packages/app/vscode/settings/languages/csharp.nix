{ pkgs, config, ... }:
{
  programs.vscode.profiles.default.userSettings = {
    "dotnet.server.path" = "${pkgs.roslyn-ls}/bin/Microsoft.CodeAnalysis.LanguageServer";
    "dotnetAcquisitionExtension.sharedExistingDotnetPath" = "${config.my.packages.dotnet}/bin/dotnet";
  };
}

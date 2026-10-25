{
  name,
  pkgs,
  ...
}:

pkgs.writeShellApplication {
  name = name;
  text = ''
    exec ${pkgs.json-diff}/bin/json-diff -j \
      <(
        ${pkgs.python3Packages.json5}/bin/pyjson5 --as-json \
          "''${XDG_CONFIG_HOME:-$HOME/.config}/Code/User/settings.json"
      ) \
      <(
        nix eval --json \
          '.#homeConfigurations."yueyinqiu@erthane".config.programs.vscode.profiles.default.userSettings'
      )
  '';
}

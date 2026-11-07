{
  pkgs,
  config,
  lib,
  ...
}:
let
  ghostty = "${config.my.packages.ghostty}/bin/ghostty";
  bash = "${config.my.packages.bash}/bin/bash";
  yazi = "${config.programs.yazi.shellWrapperName}";
  ya = "${config.my.packages.yazi}/bin/ya";

  yazi-in-ghostty-bash-escaped = lib.escapeShellArgs [
    ghostty
    "-e"
    bash
    "-lic"
    ''${lib.escapeShellArg yazi} "$@"; exec ${lib.escapeShellArg bash} -l''
    "_"
  ];

  yazi-wrapper = pkgs.writeShellApplication {
    name = "yazi-wrapper";
    text = ''
      BDUS_METHOD="$1"
      shift 1

      paths=()
      for arg in "$@"; do
        decoded=$(printf '%b' "''${arg//%/\\x}")
        paths+=("$decoded")
      done

      case "$BDUS_METHOD" in
      "ShowFolders" | "ShowItems")
        ${yazi-in-ghostty-bash-escaped} "''${paths[@]}" &
        disown
        ;;
      "ShowItemProperties")
        ${yazi-in-ghostty-bash-escaped} --client-id $$ "''${paths[@]}" &
        disown
        for _ in {1..30}; do
          ${lib.escapeShellArg ya} emit-to $$ spot && break
          sleep 0.2
        done
        ;;
      esac
    '';
  };
in
{
  xdg.configFile."org.freedesktop.FileManager1.common/config".text = ''
    cmd=${lib.escapeShellArg (lib.getExe yazi-wrapper)}
  '';
  dbus.packages = [
    pkgs.org-freedesktop-filemanager1-common
  ];
}

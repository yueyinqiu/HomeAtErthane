{
  pkgs,
  config,
  ...
}:
{
  home.packages = [
    (pkgs.symlinkJoin {
      name = "aliyunpan";
      paths = [ pkgs.aliyunpan ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/aliyunpan \
          --set-default ALIYUNPAN_CONFIG_DIR "${config.xdg.configHome}/aliyunpan"
      '';
    })
  ];
}

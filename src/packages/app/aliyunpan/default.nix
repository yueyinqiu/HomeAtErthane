{
  pkgs,
  config,
  ...
}:
let
  aliyunpan = pkgs.symlinkJoin {
    name = "aliyunpan";
    paths = [ pkgs.aliyunpan ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/aliyunpan \
        --set-default ALIYUNPAN_CONFIG_DIR "${config.xdg.configHome}/aliyunpan"
    '';
  };
in
{
  my.packages.aliyunpan = aliyunpan;

  home.packages = [
    config.my.packages.aliyunpan
  ];
}

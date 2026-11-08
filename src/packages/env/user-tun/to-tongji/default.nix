{
  config,
  pkgs,
  lib,
  ...
}:
{
  my.packages.easytier = pkgs.easytier;

  home-manager-mihomo-manager.instances.to-tongji = {
    port = 11410;
    configuration = ./config;
  };

  systemd.user.services.easytier-tongji-proxy = {
    Unit = {
      Description = "EasyTier network for Tongji proxy";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      EnvironmentFile = "${config.xdg.configHome}/home-manager-mihomo-manager/to-tongji/easytier-tongji-proxy.env";
      ExecStart = lib.hm.strings.escapeSystemdExecArgs [
        "${config.my.packages.easytier}/bin/easytier-core"
        "-c"
        ./easytier-tongji-proxy.toml
      ];
      Restart = "on-failure";
    };
  };

  systemd.user.services.easytier-naxior = {
    Unit = {
      Description = "EasyTier network for naxior";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      EnvironmentFile = "${config.xdg.configHome}/home-manager-mihomo-manager/to-tongji/easytier-naxior.env";
      ExecStart = lib.hm.strings.escapeSystemdExecArgs [
        "${config.my.packages.easytier}/bin/easytier-core"
        "-c"
        ./easytier-naxior.toml
      ];
      Restart = "on-failure";
    };
  };
}

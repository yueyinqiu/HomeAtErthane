{ pkgs, config, ... }:
let 
  file = pkgs.writeText "user-tun-controller.yaml" "mihomo-api: unix:/run/user-tun/controller/sock";
in 
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "user-tun-control";
      text = ''
        ${config.home-manager-mihomo-manager.mihomo-tui.package}/bin/mihomo-tui -c ${file}
      '';
    })
  ];
}
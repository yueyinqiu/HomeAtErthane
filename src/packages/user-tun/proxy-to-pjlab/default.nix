{ config, pkgs, ... }:
{
  home-manager-mihomo-manager.instances.to-pjlab = {
    port = 44911;
    configuration = ./config;
  };

  home.packages = [
    (pkgs.writeShellApplication {
      name = "my-proxy-to-pjlab-atrust-up";
      text = ''
        ${pkgs.podman-compose}/bin/podman-compose -f ${config.xdg.configHome}/pjlab-atrust/compose.yml up -d
        echo "VNC: '${pkgs.remmina}/bin/remmina' -c vnc://127.0.0.1:52495"
        echo "Password: 1"
      '';
    })
  ];

  xdg.configFile."pjlab-atrust/compose.yml".text = ''
    name: pjlab-atrust
    services:
      pjlab-atrust:
        container_name: pjlab-atrust
        image: docker.io/hagb/docker-atrust
        hostname: pjlab-atrust
        restart: unless-stopped
        ports:
          - "127.0.0.1:52495:5901"
          - "127.0.0.1:59553:1080"
        environment:
          URLWIN: "1"
          PASSWORD: "1"
          FAKE_HWADDR: "BE:D3:BD:24:71:D8"
        devices:
          - "/dev/net/tun"
        cap_add:
          - "NET_ADMIN"
        sysctls:
          - "net.ipv4.conf.default.route_localnet=1"
        dns:
          - "114.114.114.114"
  '';
}

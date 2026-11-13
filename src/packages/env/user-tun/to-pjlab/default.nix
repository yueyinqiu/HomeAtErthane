{
  config,
  pkgs,
  lib,
  ...
}:
let
  # LD_PRELOAD shim：让 pasta 出站强制绑到物理网卡，绕开宿主 fake-ip tun。
  force-bind = pkgs.stdenv.mkDerivation {
    name = "force-bind";
    dontUnpack = true;
    buildPhase = ''
      $CC -shared -fPIC -O2 -o force-bind.so ${./force-bind.c}
    '';
    installPhase = ''
      mkdir -p $out/lib
      cp force-bind.so $out/lib/
    '';
  };
in
{
  home-manager-mihomo-manager.instances.to-pjlab = {
    port = 44911;
    configuration = ./config;
  };

  home.packages = [
    (pkgs.writeShellApplication {
      name = "my-proxy-to-pjlab-atrust-up";
      text = ''
        LD_PRELOAD="${force-bind}/lib/force-bind.so" ${lib.escapeShellArgs [
          "${config.my.packages.podman-compose}/bin/podman-compose"
          "-f"
          "${config.xdg.configHome}/pjlab-atrust/compose.yml"
          "up"
          "-d"
        ]}
        echo "VNC: '${config.my.packages.remmina}/bin/remmina' -c vnc://127.0.0.1:52495"
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
        extra_hosts:
          - "localhost.sangfor.com.cn:127.0.0.1"
          # curl -s 'https://dns.alidns.com/resolve?name=vpn.pjlab.org.cn&type=A'
          - "vpn.pjlab.org.cn:140.206.167.137"
  '';
}

{
  config,
  pkgs,
  lib,
  ...
}:
{
  home-manager-mihomo-manager.instances.to-pjlab = {
    port = 44911;
    configuration = ./config;
  };

  home.packages = [
    (pkgs.writeShellApplication {
      name = "my-proxy-to-pjlab-atrust-up";
      text = ''
        ${lib.escapeShellArgs [
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
        dns:
          - "114.114.114.114"
        # aTrust 用它自己的本地 HTTPS/RPC 服务，服务就监听在容器内的 127.0.0.1 上，
        # 证书域名是 localhost.sangfor.com.cn（真实 DNS 解析为 127.0.0.1）。
        # 宿主机的 fake-ip tun 会把所有 53 端口 DNS 劫持成 198.18.x.x/2001:2::x，
        # 导致该域名被解析成假 IP，本地服务连不上（"couldn't resolve host name"）。
        # 这里直接写 hosts 绕过 DNS 劫持，固定解析到容器内回环地址。
        extra_hosts:
          - "localhost.sangfor.com.cn:127.0.0.1"
  '';
}

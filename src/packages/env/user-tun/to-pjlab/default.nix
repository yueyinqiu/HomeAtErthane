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
        # 宿主机的 fake-ip tun（sing-box auto_route）会劫持所有 53 端口 DNS，
        # 把域名解析成 198.18.x.x/2001:2::x 的假 IP，再交给 mihomo 去真实解析。
        # 对 aTrust 这两个域名是坏事：
        #   1. localhost.sangfor.com.cn 本该解析成 127.0.0.1（容器内本地 HTTPS/RPC
        #      服务的回环证书域名），被假 IP 化后本地服务连不上 → "network unavailable"。
        #   2. vpn.pjlab.org.cn 由 mihomo 用半内网 DNS 解析会得到连不通的内网 IP；
        #      这里直接写死解析成公网 IP（140.206.167.137），绕过整个 fake-ip 链路，
        #      之后 mihomo 收到的是这个公网 IP，按 MATCH→DIRECT 直接出去即可登录。
        # 用 extra_hosts 写 /etc/hosts 是用户态改法，不动 sing-box。
        extra_hosts:
          - "localhost.sangfor.com.cn:127.0.0.1"
          - "vpn.pjlab.org.cn:140.206.167.137"
  '';
}

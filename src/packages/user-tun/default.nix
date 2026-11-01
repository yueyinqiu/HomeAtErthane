{ config, lib, pkgs, ... }:
let
  yaml = pkgs.formats.yaml { };

  # 与 NixosErthane 的 user-tun 部分保持一致（system 侧 gost 把 uid1000 流量转发到这个 unix socket）
  unixSock = "/run/user-tun/1000/sock";
  mihomoSocksPort = 37260;   # mihomo 的 mixed-in 重入端口

  gostConfig = yaml.generate "user-tun-gost.yaml" {
    services = [
      {
        name = "user-1000-in";
        addr = unixSock;                       # 裸路径，别加 unix://
        handler = { type = "socks5"; chain = "to-mihomo"; };
        listener = { type = "unix"; };
      }
    ];
    chains = [
      {
        name = "to-mihomo";
        hops = [
          {
            name = "hop-0";
            nodes = [
              {
                name = "mihomo-socks-in";
                addr = "127.0.0.1:${toString mihomoSocksPort}";
                connector = { type = "socks5"; };
                dialer = { type = "tcp"; };
              }
            ];
          }
        ];
      }
    ];
  };
in
{
  # 用户级桥：听用户自己的 unix socket，解析 socks5，喂回 mihomo 重入点
  systemd.user.services.user-tun-gost = {
    Unit = {
      Description = "user-tun gost bridge (unix socket -> mihomo socks-in)";
    };
    Service = {
      ExecStart = "${pkgs.gost}/bin/gost -C ${gostConfig}";
      Restart = "on-failure";
      RestartSec = 3;
      UMask = "0000";   # socket 世界可写（0777），靠上层目录 0770 兜底
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
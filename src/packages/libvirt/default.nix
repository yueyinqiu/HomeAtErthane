{
  pkgs,
  lib,
  config,
  nixvirt,
  ...
}:
{
  home.packages = with pkgs; [
    virt-manager
    virt-viewer
  ];

  virtualisation.libvirt.enable = true;
  virtualisation.libvirt.swtpm.enable = true;

  virtualisation.libvirt.connections."qemu:///session".domains = [
    {
      # if there is no disk displayed during installation, click Load Driver, select viostor/w11/amd64 in virtio-win
      # for network: netkvm
      # after installation: virtio-win-guest-tools.exe

      # To activate: irm https://get.activated.win | iex

      # To share files: use syncthing
      definition =
        let
          base = nixvirt.lib.domain.templates.windows {
            name = "w11";
            uuid = "fbcd0e7c-c37b-404f-b7ec-16e609927087";
            memory = {
              count = 3;
              unit = "GiB";
            };
            storage_vol = "${config.home.homeDirectory}/.local/share/libvirt/images/w11/storage.raw";
            install_vol = "${config.home.homeDirectory}/.local/share/libvirt/images/w11/install.iso";
            nvram_path = "${config.home.homeDirectory}/.local/share/libvirt/images/w11/nvram.nvram";
            virtio_net = true;
            virtio_drive = true;
            install_virtio = true;
          };
        in
        nixvirt.lib.domain.writeXML (
          base
          // {
            cpu = base.cpu // {
              topology = {
                sockets = 1;
                cores = 2;
                threads = 1;
              };
            };
            devices = base.devices // {interface = {
                type = "user";
                model = {
                  type = "virtio";
                };
                source = null;
              };
              disk = lib.lists.imap0 (
                i: disk:
                if i == 0 then
                  disk
                  // {
                    driver = disk.driver // {
                      type = "raw";
                      discard = "ignore";
                    };
                  }
                else
                  disk
              ) base.devices.disk;
              controller = (base.devices.controller or [ ]) ++ [
                {
                  type = "scsi";
                  index = 0;
                  model = "virtio-scsi";
                }
              ];
            };
          }
        );
    }
  ];
}

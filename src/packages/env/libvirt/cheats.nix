{ ... }: {
  programs.snavi.cheats = {
    "libvirt-attach" = {
      src = ./cheats;
      entry = "attach.json";
    };
    "libvirt-create" = {
      src = ./cheats;
      entry = "create.json";
    };
    "libvirt-destroy" = {
      src = ./cheats;
      entry = "destroy.json";
    };
    "libvirt-shutdown" = {
      src = ./cheats;
      entry = "shutdown.json";
    };
    "libvirt-start" = {
      src = ./cheats;
      entry = "start.json";
    };
  };
}

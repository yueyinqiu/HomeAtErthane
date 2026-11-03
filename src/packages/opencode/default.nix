{ config, pkgs, ... }:
let
  home = config.home.homeDirectory;

  shell = pkgs.writeShellApplication {
    name = "opencode-sandbox-shell";
    text = ''
      exec ${pkgs.bubblewrap}/bin/bwrap \
        --unshare-user \
        --bind / / \
        --dev /dev --proc /proc \
        --tmpfs ${home}/.local/share/opencode \
        -- /bin/sh "$@"
    '';
  };
in
{
  my.packages.opencode = pkgs.writeShellApplication {
    name = "opencode";
    text = ''
      extra_args=()
      if [ -n "''${OPENCODE_RW_DIRS-}" ]; then
        IFS=':' read -r -a dirs <<< "$OPENCODE_RW_DIRS"
        for d in "''${dirs[@]}"; do
          if [ -n "$d" ]; then
            extra_args+=(--bind "$d" "$d")
          fi
        done
      fi
      exec ${pkgs.bubblewrap}/bin/bwrap \
        "''${extra_args[@]}" \
        --unshare-user --unshare-ipc --unshare-pid --unshare-uts --unshare-cgroup \
        --ro-bind / / \
        --dev /dev --proc /proc \
        --tmpfs /tmp \
        --bind "$PWD" "$PWD" \
        --bind ${home}/.local/share/opencode ${home}/.local/share/opencode \
        --bind ${home}/.local/state/opencode ${home}/.local/state/opencode \
        --bind ${home}/.cache ${home}/.cache \
        --tmpfs ${home}/.ssh \
        --ro-bind /dev/null ${home}/.pi/agent/auth.json \
        -- ${pkgs.opencode}/bin/opencode "$@"
    '';
  };

  programs.opencode.enable = true;

  programs.opencode.package = config.my.packages.opencode;
  programs.opencode.settings.shell = "${shell}/bin/opencode-sandbox-shell";
}

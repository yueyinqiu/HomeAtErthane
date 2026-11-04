{ config, pkgs, ... }:
let
  home = config.home.homeDirectory;

  shell = pkgs.writeShellApplication {
    name = "opencode-sandbox-shell";
    text = ''
      before=$(nix profile list)
      set +e
      ${pkgs.bubblewrap}/bin/bwrap \
        --unshare-user \
        --bind / / \
        --dev /dev --proc /proc \
        --tmpfs ${home}/.local/share/opencode \
        -- ${config.my.packages.bash}/bin/bash "$@"
      rc=$?
      set -e
      after=$(nix profile list)
      if [ "$before" != "$after" ]; then
        echo "!! nix profile changed — killing opencode"
        kill -9 "$PPID"
      fi
      exit "$rc"
    '';
  };

  sandboxed = pkgs.writeShellApplication {
    name = "opencode-sandbox";
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
        --unshare-user --uid 100000 --gid 100000 \
        --unshare-ipc --unshare-pid --unshare-uts --unshare-cgroup \
        --ro-bind /nix /nix \
        --ro-bind /usr /usr \
        --ro-bind /etc /etc \
        --ro-bind /run/current-system /run/current-system \
        --ro-bind ${home}/.nix-profile ${home}/.nix-profile \
        --ro-bind ${home}/.local/state/nix/profiles ${home}/.local/state/nix/profiles \
        --bind ${home}/.local/share/opencode ${home}/.local/share/opencode \
        --bind ${home}/.local/state/opencode ${home}/.local/state/opencode \
        --dev /dev --proc /proc \
        --bind "$PWD" "$PWD" \
        -- ${pkgs.opencode}/bin/opencode "$@"
    '';
  };
in
{
  my.packages.opencode = pkgs.symlinkJoin {
    name = "opencode";
    paths = [ pkgs.opencode ];
    version = pkgs.opencode.version;
    postBuild = ''
      rm "$out/bin/opencode"
      cp ${sandboxed}/bin/opencode-sandbox "$out/bin/opencode"
      chmod +x "$out/bin/opencode"
    '';
  };

  programs.opencode.enable = true;

  programs.opencode.package = config.my.packages.opencode;
  programs.opencode.settings.shell = "${shell}/bin/opencode-sandbox-shell";
}

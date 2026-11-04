{ config, pkgs, ... }:
let
  home = config.home.homeDirectory;

  shell = pkgs.writeShellApplication {
    name = "opencode-sandbox-shell";
    text = ''
      before=$(nix profile list)
      args=()
      if [ -z "''${OPENCODE_SANDBOX_ALLOW_OPENCODE_CONFIG:-}" ]; then
        args+=(
          --tmpfs ${config.xdg.configHome}/opencode
          --tmpfs ${config.xdg.dataHome}/opencode
          --tmpfs ${config.xdg.stateHome}/opencode
        )
      fi
      set +e
      ${pkgs.bubblewrap}/bin/bwrap \
        --unshare-user \
        --bind / / \
        --dev /dev --proc /proc \
        "''${args[@]}" \
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
      before=$(nix profile list)
      args=()
      IFS=':'
      for d in ''${OPENCODE_SANDBOX_DIRECTORIES:-$PWD}; do
        if [ -n "$d" ]; then
          args+=(--bind "$d" "$d")
        fi
      done
      unset IFS
      set +e
      ${pkgs.bubblewrap}/bin/bwrap \
        --unshare-user \
        --unshare-ipc --unshare-pid --unshare-uts --unshare-cgroup \
        --ro-bind /nix /nix \
        --ro-bind /usr /usr \
        --ro-bind /etc /etc \
        --ro-bind /run/current-system /run/current-system \
        --ro-bind ${home}/.nix-profile ${home}/.nix-profile \
        --ro-bind ${config.xdg.stateHome}/nix/profiles ${config.xdg.stateHome}/nix/profiles \
        --bind ${config.xdg.dataHome}/opencode ${config.xdg.dataHome}/opencode \
        --bind ${config.xdg.stateHome}/opencode ${config.xdg.stateHome}/opencode \
        --ro-bind ${config.xdg.configHome}/opencode ${config.xdg.configHome}/opencode \
        --ro-bind ${config.xdg.configHome}/git ${config.xdg.configHome}/git \
        --dev /dev --proc /proc \
        "''${args[@]}" \
        -- ${pkgs.opencode}/bin/opencode "$@"
      rc=$?
      set -e
      after=$(nix profile list)
      if [ "$before" != "$after" ]; then
        echo "!! nix profile changed during opencode session"
        if [ -t 0 ]; then
          read -r -p "press Enter after checking/rolling back... " _
        fi
      fi
      exit "$rc"
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

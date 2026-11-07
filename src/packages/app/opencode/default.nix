{ config, pkgs, lib, ... }:
let
  home = config.home.homeDirectory;

  shellTmpfsArgs = lib.escapeShellArgs [
    "--tmpfs" "${config.xdg.configHome}/opencode"
    "--tmpfs" "${config.xdg.dataHome}/opencode"
    "--tmpfs" "${config.xdg.stateHome}/opencode"
  ];

  bwrapArgs = lib.escapeShellArgs [
    "--unshare-user"
    "--unshare-ipc" "--unshare-pid" "--unshare-uts" "--unshare-cgroup"
    "--ro-bind" "/nix" "/nix"
    "--ro-bind" "/usr" "/usr"
    "--ro-bind" "/etc" "/etc"
    "--ro-bind" "/run/current-system" "/run/current-system"
    "--ro-bind" "${home}/.nix-profile" "${home}/.nix-profile"
    "--ro-bind" "${config.xdg.stateHome}/nix/profiles" "${config.xdg.stateHome}/nix/profiles"
    "--bind" "${config.xdg.dataHome}/opencode" "${config.xdg.dataHome}/opencode"
    "--bind" "${config.xdg.stateHome}/opencode" "${config.xdg.stateHome}/opencode"
    "--ro-bind" "${config.xdg.configHome}/opencode" "${config.xdg.configHome}/opencode"
    "--ro-bind" "${config.xdg.configHome}/git" "${config.xdg.configHome}/git"
    "--dev" "/dev" "--proc" "/proc"
    "--dev-bind" "/dev/kvm" "/dev/kvm"
  ];

  shell = pkgs.writeShellApplication {
    name = "opencode-sandbox-shell";
    text = ''
      before=$(${lib.escapeShellArg "${config.my.packages.nix}/bin/nix"} profile list)
      args=()
      if [ -z "''${OPENCODE_SANDBOX_ALLOW_OPENCODE_CONFIG:-}" ]; then
        args+=( ${shellTmpfsArgs} )
      fi
      set +e
      ${lib.escapeShellArg "${pkgs.bubblewrap}/bin/bwrap"} \
        --unshare-user \
        --bind / / \
        --dev /dev --proc /proc \
        --dev-bind /dev/kvm /dev/kvm \
        "''${args[@]}" \
        -- ${lib.escapeShellArg "${config.my.packages.bash}/bin/bash"} "$@"
      rc=$?
      set -e
      after=$(${lib.escapeShellArg "${config.my.packages.nix}/bin/nix"} profile list)
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
      before=$(${lib.escapeShellArg "${config.my.packages.nix}/bin/nix"} profile list)
      args=( ${lib.escapeShellArgs [ "--bind" config.my.paths.s config.my.paths.s ]} )
      IFS=':'
      for d in ''${OPENCODE_SANDBOX_DIRECTORIES:-}; do
        if [ -n "$d" ]; then
          args+=(--bind "$d" "$d")
        fi
      done
      unset IFS
      set +e
      ${lib.escapeShellArg "${pkgs.bubblewrap}/bin/bwrap"} \
        ${bwrapArgs} \
        "''${args[@]}" \
        -- ${lib.escapeShellArg "${pkgs.opencode}/bin/opencode"} "$@"
      rc=$?
      set -e
      after=$(${lib.escapeShellArg "${config.my.packages.nix}/bin/nix"} profile list)
      if [ "$before" != "$after" ]; then
        ${lib.escapeShellArg "${pkgs.libnotify}/bin/notify-send"} \
          "OPENCODE WARNING" "nix profile changed during the session" || true
        if [ -t 0 ] && [ -t 2 ]; then
          printf '\n\n\n\n'
          printf '%s\n' \
            '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!' \
            '!!  NIX PROFILE CHANGED DURING THIS SESSION  !!' \
            '!!  a package may now shadow your commands   !!' \
            '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!' >&2
          printf 'inspect: nix profile list   revert: nix profile rollback\n' >&2
          read -r -p 'press Enter when ready... ' _
        else
          echo '!! nix profile changed during opencode session' >&2
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
      cp ${lib.escapeShellArg "${sandboxed}/bin/opencode-sandbox"} "$out/bin/opencode"
      chmod +x "$out/bin/opencode"
    '';
  };

  programs.opencode.enable = true;

  programs.opencode.package = config.my.packages.opencode;
  programs.opencode.settings.shell = "${shell}/bin/opencode-sandbox-shell";
}

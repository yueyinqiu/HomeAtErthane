{ config, pkgs, ... }:
let
  home = config.home.homeDirectory;
  piDirectory = "${home}/.pi/agent";

  nixProfileSha256sum = pkgs.writeShellApplication {
    name = "nix-profile-sha256sum";
    text = ''
      ${pkgs.nix}/bin/nix profile list --json | ${pkgs.coreutils}/bin/sha256sum
    '';
  };

  piNixProfileGuardRun = pkgs.writeShellApplication {
    name = "pi-nix-profile-guard-run";
    text = ''
      hash="''${PI_SANDBOX_NIX_PROFILE_HASH:-}"
      if [ "$(${nixProfileSha256sum}/bin/nix-profile-sha256sum)" != "$hash" ]; then
        echo "Commands cannot be executed until the nix profile is rolled back. Please report this to the user." >&2
        exit 1
      fi

      set +e
      ${config.my.packages.bash}/bin/bash "$@"
      rc=$?
      set -e

      if [ "$(${nixProfileSha256sum}/bin/nix-profile-sha256sum)" != "$hash" ]; then
        echo "The nix profile has been changed! Please stop any other operation and report this to the user!" >&2
      fi
      exit "$rc"
    '';
  };

  sandboxed = pkgs.writeShellApplication {
    name = "pi-sandbox";
    text = ''
      args=(
        --unshare-user
        --unshare-ipc
        --unshare-pid
        --unshare-uts
        --unshare-cgroup

        --dev /dev
        --proc /proc
        --tmpfs /tmp
        --ro-bind /nix /nix
        --ro-bind /usr /usr
        --ro-bind /etc /etc

        --ro-bind /run/current-system /run/current-system
        --ro-bind ${home}/.nix-profile ${home}/.nix-profile
        --ro-bind ${config.xdg.stateHome}/nix/profiles ${config.xdg.stateHome}/nix/profiles

        --bind ${piDirectory} ${piDirectory}

        --dev-bind /dev/kvm /dev/kvm
        --ro-bind ${config.xdg.configHome}/git ${config.xdg.configHome}/git

        --bind ${config.my.paths.s} ${config.my.paths.s}
      )

      IFS=':'
      for d in ''${PI_SANDBOX_EXTRA_DIRECTORIES:-}; do
        if [ -n "$d" ]; then
          args+=(--bind "$d" "$d")
        fi
      done
      unset IFS

      exec ${pkgs.bubblewrap}/bin/bwrap \
        --setenv PI_CLIPBOARD_OSC52 1 \
        --setenv PI_SANDBOX_NIX_PROFILE_HASH "$(${nixProfileSha256sum}/bin/nix-profile-sha256sum)" \
        "''${args[@]}" \
        -- ${pkgs.pi-coding-agent}/bin/pi "$@"
    '';
  };
in
{
  my.packages.pi-coding-agent = pkgs.symlinkJoin {
    name = "pi-coding-agent";
    paths = [ pkgs.pi-coding-agent ];
    version = pkgs.pi-coding-agent.version;
    postBuild = ''
      rm "$out/bin/pi"
      cp ${sandboxed}/bin/pi-sandbox "$out/bin/pi"
      chmod +x "$out/bin/pi"
    '';
  };

  programs.pi-coding-agent = {
    enable = true;
    package = config.my.packages.pi-coding-agent;
    settings.shellPath = "${piNixProfileGuardRun}/bin/pi-nix-profile-guard-run";
  };
}

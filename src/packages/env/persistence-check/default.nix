{ config, pkgs, lib, ... }:
let
  # User-level persistence check: on NixOS + Home Manager every legitimate
  # service/autostart entry in ~/.config is a *symlink* into the immutable nix
  # store. A manually-dropped file (regular file or a symlink pointing outside
  # the store) is the signature of malware trying to survive a reboot. So we
  # don't parse contents — we just ask "is this file itself inside /nix/store?".
  check = pkgs.writeShellApplication {
    name = "check-persistence";
    text = ''
      set -uo pipefail

      findings=0
      reports=()

      report() {
        reports+=("$1")
        findings=$((findings + 1))
      }

      # flag $1 unless it resolves (through symlinks) into /nix/store
      check_entry() {
        local what="$1" resolved
        resolved="$(${pkgs.coreutils}/bin/readlink -f -- "$what" 2>/dev/null)"
        case "$resolved" in
          /nix/store/*) return ;;
          "") report "$what (unresolvable / dangling)" ;;
          *)  report "$what -> $resolved" ;;
        esac
      }

      # recursively scan every file and symlink (not dirs) under $1
      scan_dir() {
        local dir="$1" e
        [ -d "$dir" ] || return 0
        while IFS= read -r e; do
          check_entry "$e"
        done < <(${pkgs.findutils}/bin/find "$dir" -mindepth 1 ! -type d 2>/dev/null)
      }

      scan_dir "${config.xdg.configHome}/systemd/user"
      scan_dir "${config.xdg.configHome}/autostart"

      if [ "$findings" -eq 0 ]; then
        echo "persistence-check: OK (everything is a nix-store entry)"
        exit 0
      fi

      # always print and notify on every run — better annoyed than to miss it
      {
        echo "persistence-check: $findings suspicious persistence entr(y/ies):"
        printf '%s\n' "''${reports[@]}"
      } >&2

      ${pkgs.libnotify}/bin/notify-send \
        -u critical \
        "⚠️ persistence check ($findings)" \
        "$(printf '%s\n' "''${reports[@]}" | ${pkgs.coreutils}/bin/head -n 3 | ${pkgs.coreutils}/bin/tr '\n' ' ')" \
        || true

      exit 1
    '';
  };
in
{
  my.packages.check-persistence = check;

  home.packages = [ check ];

  systemd.user.services.persistence-check = {
    Unit.Description = "Check for non-declarative persistence (possible malware)";
    Service = {
      Type = "oneshot";
      ExecStart = lib.getExe check;
    };
  };

  systemd.user.timers.persistence-check = {
    Unit.Description = "Periodically check for persistence anomalies";
    Timer = {
      OnBootSec = "5min";
      OnUnitActiveSec = "1h";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
{ config, pkgs, ... }:
let
  bwrap = pkgs.bubblewrap;
  home = config.home.homeDirectory;

  innerShell = pkgs.writeShellApplication {
    name = "opencode-sandbox-shell";
    text = ''
      exec ${bwrap}/bin/bwrap \
        --unshare-user \
        --bind / / \
        --dev /dev --proc /proc \
        --tmpfs ${home}/.local/share/opencode \
        -- /bin/sh "$@"
    '';
  };

  opencodeSandboxed = pkgs.writeShellApplication {
    name = "opencode-sandboxed";
    text = ''
      exec ${bwrap}/bin/bwrap \
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
in
{
  programs.opencode = {
    enable = true;

    cli = {
      tabs.mode = "off";
    };

    context = ''
      # Host Context

      ## Host Environment (NixOS)

      - The host runs **NixOS**, with the system environment managed declaratively by Nix / Home Manager.
      - **Do not** mutate the system environment dynamically: avoid commands that change system state, such as `nix profile install`, `nixos-rebuild`, or editing `/etc`.
      - When a CLI tool is missing, invoke it **on demand** rather than installing it persistently:
        - `nix shell nixpkgs#<pkg>` — enter a shell with the tool available
        - `nix run nixpkgs#<pkg>` — run the tool directly
      - **Do not** recursively traverse or search `/` or `/nix/store` (very slow). To look up Nix package definitions, options, or modules, query online instead (e.g. search.nixos.org, the nixpkgs repo on GitHub) rather than grepping the local store.

      ## Network Environment (Restricted)

      - This device's network is restricted. If you encounter network issues — i.e., a website you are certain should be reachable is actually inaccessible — please contact the user to adjust the network configuration.

      ## Git Conventions

      - **Do not** touch the git repository of the user's project. The user uses git to track your own changes, so you must not run any git operations (commit/push/pull, etc.) against the project's repo.
    '';

    settings = {
      provider = {
        tensoris = {
          name = "Tensoris";
          npm = "@ai-sdk/openai-compatible";
          options = {
            baseURL = "https://api.tensoris.ai/v1";
          };
          models = {
            "deepseek-v4-pro-0813" = {
              name = "DeepSeek V4 Pro";
              limit = {
                context = 900000;
                output = 384000;
              };
              options = {
                reasoningEffort = "low";
              };
            };
            "deepseek-v4.1-flash-1017" = {
              name = "DeepSeek V4.1 Flash";
              options = {
                reasoningEffort = "low";
              };
            };
          };
        };

        tongji = {
          name = "Tongji";
          npm = "@ai-sdk/openai-compatible";
          options = {
            baseURL = "https://agi.tongji.edu.cn/v1";
          };
          models = {
            "DeepSeek-V4.1-Flash" = {
              name = "DeepSeek-V4.1-Flash";
              limit = {
                context = 900000;
                output = 384000;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                ];
              };
              options = {
                reasoningEffort = "low";
              };
            };
          };
        };
      };

      model = "tensoris/deepseek-v4-pro-0813";
      shell = "${innerShell}/bin/opencode-sandbox-shell";
    };
  };

  home.packages = [ opencodeSandboxed ];

  xdg.configFile."opencode/service.json".text = ''
    {
      "disabled": true
    }
  '';
}

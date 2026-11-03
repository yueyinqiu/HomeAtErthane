{ pkgs, ... }: {
  programs.pi-coding-agent = {
    enable = true;

    extraPackages = [
      pkgs.nodejs_latest
      pkgs.wl-clipboard
      pkgs.bubblewrap
      pkgs.socat
    ];

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
      defaultProvider = "35-220-164-252-3888";
      defaultModel = "deepseek-v4-pro";
      defaultThinkingLevel = "low";
      packages = [
        "npm:@xzzpig/pi-sandbox"
      ];
    };

    models = {
      providers = {
        "tongji" = {
          baseUrl = "https://agi.tongji.edu.cn/v1";
          api = "openai-completions";
          compat = {
            supportsDeveloperRole = false;
          };
          models = [
            {
              id = "DeepSeek-V4.1-Flash";
              name = "DeepSeek-V4.1-Flash";
              contextWindow = 900000;
              maxTokens = 384000;
              reasoning = true;
              input = [
                "text"
                "image"
              ];
            }
          ];
        };
        "tensoris" = {
          baseUrl = "https://api.tensoris.ai/v1";
          api = "openai-completions";
          compat = {
            supportsDeveloperRole = false;
          };
          models = [
            {
              id = "deepseek-v4-pro-0813";
              name = "deepseek-v4-pro-0813";
              contextWindow = 900000;
              maxTokens = 384000;
              reasoning = true;
              input = [ "text" ];
            }
            {
              id = "deepseek-v4.1-flash";
              name = "deepseek-v4.1-flash";
              contextWindow = 900000;
              maxTokens = 384000;
              reasoning = true;
              input = [
                "text"
                "image"
              ];
            }
            {
              id = "gpt-6-luna";
              name = "gpt-6-luna";
              contextWindow = 900000;
              maxTokens = 384000;
              reasoning = true;
              input = [
                "text"
                "image"
              ];
            }
          ];
        };
      };
    };
  };
}

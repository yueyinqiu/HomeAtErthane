{ pkgs, ... }: {
  programs.pi-coding-agent = {
    enable = true;

    extraPackages = [
      pkgs.nodejs_latest
      pkgs.wl-clipboard
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

      ## Network Environment (Mainland China)

      - The device is located in Mainland China; some overseas resources may be blocked or very slow.
      - To route a command through a proxy, wrap it with `mihomo-manager`, which injects `HTTP(S)_PROXY` / `ALL_PROXY`:
        - `mihomo-manager with for-firefox <command>` — general proxy (preferred)
        - `mihomo-manager with for-nix-daemon <command>` — for Nix commands (The nix-daemon always uses the `for-nix-daemon` proxy; for consistency, prefer using this same proxy when running Nix commands.)
      - When cloning from GitHub, **prefer SSH** (`git@github.com:user/repo.git`) over HTTPS — it is more reliable and less prone to network issues in this environment.

      ## Git Conventions

      - **Do not** touch the git repository of the user's project. The user uses git to track your own changes, so you must not run any git operations (commit/push/pull, etc.) against the project's repo.
    '';

    settings = {
      defaultProvider = "35-220-164-252-3888";
      defaultModel = "deepseek-v4-pro";
      defaultThinkingLevel = "low";
      packages = [
      ];
    };

    models = {
      providers = {
        "35-220-164-252-3888" = {
          baseUrl = "https://api.boyuerichdata.opensphereai.com/v1";
          api = "openai-completions";
          compat = {
            supportsDeveloperRole = false;
          };
          models = [
            {
              id = "deepseek-v4-pro";
              name = "deepseek-v4-pro";
              contextWindow = 900000;
              maxTokens = 384000;
              reasoning = true;
              input = [ "text" ];
            }
            {
              id = "deepseek-v4-pro-0813";
              name = "deepseek-v4-pro-0813";
              contextWindow = 900000;
              maxTokens = 384000;
              reasoning = true;
              input = [ "text" ];
            }
            {
              id = "gpt-5.6-luna";
              name = "gpt-5.6-luna";
              contextWindow = 900000;
              maxTokens = 384000;
              reasoning = true;
              input = [ "text" ];
            }
          ];
        };
        "35-220-164-252-3888-http" = {
          baseUrl = "https://35.220.164.252:3888/v1";
          api = "openai-completions";
          compat = {
            supportsDeveloperRole = false;
          };
          models = [
            {
              id = "deepseek-v4-pro";
              name = "deepseek-v4-pro";
              contextWindow = 900000;
              maxTokens = 384000;
              reasoning = true;
              input = [ "text" ];
            }
          ];
        };
      };
    };
  };
}

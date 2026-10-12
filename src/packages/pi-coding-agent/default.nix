{ pkgs, ... }: {
  programs.pi-coding-agent = {
    enable = true;

    extraPackages = [
      pkgs.nodejs_latest
      pkgs.wl-clipboard
    ];

    programs.pi-coding-agent.context = ''
      Host Context:
      1. The current device is NixOS; do not dynamically modify the system environment.
      2. Do not perform traversal operations under `/` or `/nix/store`, as this is extremely time-consuming.
      3. Unless explicitly requested by the user, do not manipulate `git`.
      4. In case of network issues, use the `mihomo-manager with for-firefox` command-line proxy.
    '';

    settings = {
      defaultProvider = "workbuddy";
      defaultModel = "hy3";
      defaultThinkingLevel = "low";
      packages = [
        "git:github.com/icekale/pi-workbuddy-connect"
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
      };
    };
  };
}

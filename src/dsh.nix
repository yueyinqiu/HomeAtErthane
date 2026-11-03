{ deepseek-harness, ... }:
let
  dsh = deepseek-harness.dsh;
in
{
  programs.dsh = {
    enable = true;
    package = dsh;

    profiles.tui = {
      bundles = [ dsh.passthru.bundles.tui ];
      mode = "managed";
    };

    defaultProfile = "nix-tui";

    patch = [
      {
        id = "llm-pi-ai";
        config = {
          providers = {
            tensoris = {
              api = "openai-completions";
              baseURL = "https://api.tensoris.ai/v1";
              models = [
                {
                  id = "deepseek-v4-pro-0813";
                  contextWindow = 900000;
                  maxTokens = 384000;
                  input = [ "text" ];
                }
              ];
            };
          };
        };
      }
      {
        id = "agent-default-model";
        config = {
          provider = "tensoris";
          model = "deepseek-v4-pro-0813";
        };
      }
    ];
  };
}
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
        name = "@deepseek-ai/dsh-llm-pi-ai";
        config = {
          providers = {
            tensoris = {
              apiKeyEnv = "TENSORIS_API_KEY";
              baseURL = "https://api.tensoris.ai/v1";
              api = "openai-completions";
              models = [
                {
                  id = "deepseek-v4-pro-0813";
                  contextWindow = 900000;
                  maxTokens = 384000;
                  input = [ "text" ];
                }
                {
                  id = "deepseek-v4.1-flash-1017";
                }
              ];
              retryPolicy = {
                mode = "normal";
                maxRetries = 5;
                retryableCodes = [
                  "EMPTY_RESPONSE"
                  "RATE_LIMIT"
                  "SERVER"
                  "TIMEOUT"
                  "TRANSPORT"
                  "STREAM_CLOSED"
                ];
              };
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
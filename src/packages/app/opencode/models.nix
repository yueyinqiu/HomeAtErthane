{ ... }:
{
  programs.opencode.settings.model = "tensoris/deepseek-v4-pro-0813";
  programs.opencode.settings.provider = {
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
}

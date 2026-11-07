{ ... }:
{
  programs.pi-coding-agent.settings = {
    defaultProvider = "tensoris";
    defaultModel = "deepseek-v4-pro-0813";
    defaultThinkingLevel = "low";
  };

  programs.pi-coding-agent.models = {
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
}

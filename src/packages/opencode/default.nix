{ ... }: {
  programs.opencode = {
    enable = true;

    settings = {
      provider = {
        tensoris = {
          name = "Tensoris";
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
      };

      model = "tensoris/deepseek-v4-pro-0813";
    };
  };
}
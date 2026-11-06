{ pkgs, ... }:
let
  jsonFormat = pkgs.formats.json { };

  sandboxConfig = {
    enabled = true;
    network = {
      allowAllUnixSockets = true;
      allowedDomains = [
        "*.nixos.org"
        "*.cachix.org"

        "github.com"
        "*.github.com"
        "*.githubusercontent.com"
        "gitlab.com"

        "*.npmjs.org"
        "registry.yarnpkg.com"
        "nodejs.org"

        "pypi.org"
        "*.pypi.org"
        "*.pythonhosted.org"

        "crates.io"
        "*.crates.io"
        "*.rust-lang.org"
        "docs.rs"

        "*.golang.org"

        "*.maven.org"
        "*.gradle.org"
        "*.nuget.org"

        "huggingface.co"
        "*.huggingface.co"

        "*.docker.io"
        "production.cloudflare.docker.com"
      ];
    };
    filesystem = {
      allowRead = [ ];
      allowWrite = [
        "."
        "/tmp"
      ];
      denyRead = [ "~/.pi/agent" ];
      denyWrite = [ ];
    };
  };
in
{
  programs.pi-coding-agent.settings.packages = [
    "npm:@xzzpig/pi-sandbox"
  ];

  programs.pi-coding-agent.extraPackages = [
    pkgs.nodejs_latest
    pkgs.bubblewrap
    pkgs.socat
    pkgs.ripgrep
  ];

  home.file.".pi/agent/sandbox.json".source = jsonFormat.generate "pi-sandbox.json" sandboxConfig;
}

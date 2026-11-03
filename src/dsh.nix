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
  };
}
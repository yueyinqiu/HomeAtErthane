{ ... }:
{
  programs.opencode.cli = {
    tabs.mode = "off";
  };

  programs.opencode.context = ''
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

  xdg.configFile."opencode/service.json".text = ''
    {
      "disabled": true
    }
  '';
}

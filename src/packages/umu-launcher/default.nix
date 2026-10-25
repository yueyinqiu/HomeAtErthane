{ pkgs, config, ... }:
let
  games = "${config.xdg.dataHome}/umu-games";
in
{
  home.packages = [
    (pkgs.symlinkJoin {
      name = "umu-launcher";
      paths = [ pkgs.umu-launcher ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram "$out/bin/umu-run" \
          --run '
            if [ -z "''${WINEPREFIX:-}" ]; then
              if [ -n "''${STORE:-}" ]; then
                export WINEPREFIX="${games}/$STORE"
              else
                export WINEPREFIX="${games}/umu/''${GAMEID:-umu-default}"
              fi
            fi
          '
      '';
    })
  ];
}

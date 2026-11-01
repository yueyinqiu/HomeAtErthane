{ pkgs, config, ... }:
{
  # https://github.com/Beriholic/nix-wpsoffice-cn/issues/1#issuecomment-3706931491
  home.packages = [
    (pkgs.symlinkJoin {
      name = "wps-fcitx";
      paths = [ pkgs.wpsoffice-cn ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/wps \
          --set GTK_IM_MODULE "fcitx" \
          --set QT_IM_MODULE "fcitx" \
          --set SDL_IM_MODULE "fcitx"
      '';
    })
  ];
}

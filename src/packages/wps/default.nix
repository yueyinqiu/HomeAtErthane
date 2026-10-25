{ pkgs, config, ... }: {
  # https://github.com/Beriholic/nix-wpsoffice-cn/issues/1#issuecomment-3706931491
  # https://bbs.wps.cn/topic/61831
  # Don't Login! It will create a fucking Documents directory!

  home.packages = [
    (pkgs.symlinkJoin {
      name = "wps-fcitx-fake-xdg";
      paths = [ pkgs.wpsoffice-cn ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/wps \
          --set-default GTK_IM_MODULE "fcitx" \
          --set-default QT_IM_MODULE "fcitx" \
          --set-default SDL_IM_MODULE "fcitx" \
          --set-default XDG_CONFIG_HOME "${config.xdg.configHome}/wps-fake-xdg"
      '';
    })
  ];

  xdg.configFile."wps-fake-xdg/user-dirs.dirs".text = ''
    XDG_DOCUMENTS_DIR="${config.xdg.dataHome}/wps-fake-xdg/Documents"
  '';

}

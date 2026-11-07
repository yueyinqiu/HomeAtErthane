{ pkgs, nix-wpsoffice-cn, ... }: {
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    corefonts
    nix-wpsoffice-cn.chinese-fonts
    maple-mono.Normal-NF-CN

    (pkgs.writeShellApplication {
      name = "my-fontconfig-find-family";
      text = ''
        fc-list : family | sort -u | grep -i "''$1"
      '';
    })
  ];

  fonts.fontconfig = {
    enable = true;

    antialiasing = true;
    hinting = "full";
    subpixelRendering = "rgb";

    defaultFonts = {
      serif = [ "NSimSun" ];
      sansSerif = [ "Microsoft YaHei" ];
      monospace = [ "NSimSun" ];
    };
  };

}

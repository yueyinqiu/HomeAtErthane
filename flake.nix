{
  nixConfig = {
    extra-substituters = [
      "https://yueyinqiu.cachix.org"
      "https://nvf.cachix.org"
      "https://niri.cachix.org"
      "https://niri-epireyn.cachix.org"
      "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys = [
      "yueyinqiu.cachix.org-1:iooLFYpS7e6KAU4+QM5Zoj6Tq76jRGo+kjeAbu8JxAc="
      "nvf.cachix.org-1:GMQWiUhZ6ux9D5CvFFMwnc2nFrUHTeGaXRlVBXo+naI="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "niri-epireyn.cachix.org-1:tlVyFN7CtsDT+ZcLPS+ekFWeT1X6X4OqvWqbBMyIzFA="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  inputs = {
    import-tree.url = "github:denful/import-tree";

    os.url = "github:yueyinqiu/NixosEarthLatitude7490";
    nixpkgs.follows = "os/nixpkgs";
    NixVirt.follows = "os/NixVirt";
    nur.follows = "os/nur";

    home-manager.url = "github:nix-community/home-manager/master";

    niri.url = "github:epireyn/niri-flake";
    
    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/latest";
    nix-wpsoffice-cn.url = "github:Beriholic/nix-wpsoffice-cn";
    nvf.url = "github:notashelf/nvf";
    mindustry-bin.url = "github:yueyinqiu/MindustryBinNix";
    nix-airgap.url = "github:bitbloxhub/nix-airgap";
    sub-nix.url = "github:yueyinqiu/SubNix";
    snavi.url = "github:yueyinqiu/Snavi-Nix";
    home-manager-mihomo-manager.url = "github:MihomoManager/HomeManagerMihomoManager";
    baidunetdisk.url = "github:yueyinqiu/BaidunetdiskNix";
  };

  outputs = inputs: {
    homeConfigurations."yueyinqiu@earth-latitude7490" =
      let
        system = "x86_64-linux";
      in
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {
          nixvirt = inputs.NixVirt;
          nur = inputs.nur.legacyPackages.${system}.repos;
          nix-wpsoffice-cn = inputs.nix-wpsoffice-cn.packages.${system};
          mindustry-bin = inputs.mindustry-bin.packages.${system};
          nix-airgap = inputs.nix-airgap.packages.${system};
          niri = inputs.niri.packages.${system};
          baidunetdisk = inputs.baidunetdisk.packages.${system};
        };
        modules = [
          inputs.NixVirt.homeModules.default
          inputs.flatpaks.homeModules.default
          inputs.nvf.homeManagerModules.default
          inputs.sub-nix.homeManagerModules.sub-nix
          inputs.snavi.homeManagerModules.snavi
          inputs.home-manager-mihomo-manager.homeManagerModules.home-manager-mihomo-manager
          (inputs.import-tree ./src)
        ];
      };

    devShells = inputs.nixpkgs.lib.genAttrs inputs.nixpkgs.lib.systems.flakeExposed (system: {
      default = import ./dev {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      };
    });
  };
}

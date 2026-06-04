# SPDX-FileCopyrightText: NONE
# SPDX-License-Identifier: NONE
#
{
  description = "Home Manager Configurations";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-home-modules = {
      url = "github:robinwalterfit/nix-home-modules";
      inputs.flake-parts.follows = "flake-parts";
    };
    nix-modules = {
      url = "github:robinwalterfit/nix-modules";
      inputs.flake-parts.follows = "flake-parts";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    # See: https://flake.parts/getting-started.html
    flake-parts.lib.mkFlake { inherit inputs; } (
      { self, ... }:
      let
        inherit (inputs)
          home-manager
          nix-home-modules
          nix-modules
          nixpkgs
          sops-nix
          ;

        lib = import ./nix/lib.nix { inherit self; };

        homeModules = {
          nixpkgs-config = ./nix/modules/nixpkgs-config.nix;
        };

        homeConfigurations = {
          "<HM_USERNAME>" = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs { system = "<HM_SYSTEM>"; };

            # Specify your home configuration modules here, for example, the path to your home.nix.
            modules = [
              nix-home-modules.homeModules.delta-base
              nix-home-modules.homeModules.direnv-base
              nix-home-modules.homeModules.eza-base
              nix-home-modules.homeModules.fastfetch-base
              nix-home-modules.homeModules.fd-base
              nix-home-modules.homeModules.git-base
              nix-home-modules.homeModules.ripgrep-base
              nix-home-modules.homeModules.starship-base
              nix-home-modules.homeModules.zsh-base
              sops-nix.homeManagerModules.sops

              self.homeModules.nixpkgs-config

              ./nix/home/home.nix
            ];

            # Optionally use extraSpecialArgs to pass through arguments to home.nix
            extraSpecialArgs = { inherit nix-home-modules nix-modules; };
          };
        };
      in
      {
        systems = [ ];

        imports = [
          # Activate partitions
          flake-parts.flakeModules.partitions
          home-manager.flakeModules.home-manager
        ];

        partitionedAttrs = {
          checks = "dev";
          devShells = "dev";
          formatter = "dev";
        };
        partitions = {
          dev = {
            extraInputsFlake = ./nix/dev;
            module =
              { ... }:
              {
                imports = [ ./nix/dev/flake-module.nix ];
              };
          };
        };

        flake = { inherit homeConfigurations homeModules lib; };
      }
    );
}

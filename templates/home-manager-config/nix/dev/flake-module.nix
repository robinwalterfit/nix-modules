# SPDX-FileCopyrightText: NONE
# SPDX-License-Identifier: NONE
#
{
  config,
  inputs,
  self,
  ...
}:
let
  inherit (inputs)
    devenv
    nix-modules
    nixpkgs
    treefmt-nix
    ;
in
{
  # https://github.com/NixOS/nixpkgs/blob/master/lib/systems/flake-systems.nix
  systems = nixpkgs.lib.systems.flakeExposed;

  imports = [
    devenv.flakeModule
    treefmt-nix.flakeModule
    nix-modules.flakeModules.treefmt
  ];

  perSystem =
    {
      config,
      pkgs,
      treefmtConfigFiles,
      ...
    }:
    {
      # Project's devenv shell definitions
      devenv.shells = {
        default = {
          name = "${self.lib.projectName}-${self.lib.shortRev}";

          # Import our own devenv modules
          imports = [
            nix-modules.devenvModules.git-hooks
            nix-modules.devenvModules.shell-base
          ];

          enterShell = ''
            ln --force --symbolic '${treefmtConfigFiles.biome}' './biome.json'
            ln --force --symbolic '${treefmtConfigFiles.taplo}' './.taplo.toml'
            ln --force --symbolic '${treefmtConfigFiles.yamllint}' './.yamllint'
          '';

          # Use treefmt wrapper with our configuration and tools in git-hooks
          git-hooks.hooks.treefmt.package = config.treefmt.build.wrapper;

          languages = {
            # Enable Shell development
            shell.enable = true;
            shell.lsp.enable = true;
          };

          # Install additional packages
          packages =
            with pkgs;
            [
              # Add GitHub CLI
              gh

              # sops-nix
              age
              sops

              # Add treefmt
              config.treefmt.build.wrapper
            ]
            ++ builtins.attrValues config.treefmt.build.programs;
        };
      };

      # Project's treefmt configuration
      treefmt = {
        programs = {
          biome.enable = true;

          taplo = {
            enable = true;

            settings = {
              include = [ "**/REUSE.toml" ];
            };
          };

          yamllint.enable = true;
        };
      };
    };

  flake = {
    # For repl exploration / debug
    config.config = config;
  };
}

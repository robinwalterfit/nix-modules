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
    # Import own modules
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
            ln --force --symbolic '${treefmtConfigFiles.taplo}' './.taplo.toml'
          '';

          # Use treefmt wrapper with our configuration and tools in git-hooks
          git-hooks.hooks.treefmt.package = config.treefmt.build.wrapper;

          # Install additional packages
          packages =
            with pkgs;
            [
              # Add treefmt
              config.treefmt.build.wrapper
            ]
            ++ builtins.attrValues config.treefmt.build.programs;
        };
      };

      # Project's treefmt configuration
      treefmt = {
        programs = {
          taplo = {
            enable = true;

            settings = {
              include = [ "**/REUSE.toml" ];
            };
          };
        };
      };
    };

  flake = {
    # For repl exploration / debug
    config.config = config;
  };
}

# SPDX-FileCopyrightText: 2026 Robin Walter <hello@robinwalter.me>
# SPDX-License-Identifier: MIT
#
{
  description = "Reusable Nix Modules for all of my projects.";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    # See: https://flake.parts/getting-started.html
    flake-parts.lib.mkFlake { inherit inputs; } (
      { self, ... }:
      let
        lib =
          let
            meta = import ./nix/lib/meta.nix { inherit self; };
            packages = import ./nix/lib/packages.nix { };
          in
          meta // packages;

        # Provide devenv modules
        devenvModules = {
          git-hooks = ./nix/modules/devenv/git-hooks.nix;
          shell-base = ./nix/modules/devenv/shell-base.nix;
        };

        # Provide flake modules
        flakeModules = {
          treefmt = ./nix/modules/treefmt.nix;
        };

        # Provide templates
        templates = {
          simple = {
            description = "A simple template to start from scratch.";
            path = ./templates/simple;
          };

          defaultTemplate = self.templates.simple;
        };
      in
      {
        systems = [ ];

        imports = [
          # Activate partitions
          flake-parts.flakeModules.partitions
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

        flake = {
          inherit
            devenvModules
            flakeModules
            lib
            templates
            ;
        };
      }
    );
}

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
          home-manager-config = {
            description = "A Home-Manager Configuration template based on Nix Flakes, flake-parts and using robinwalterfit/nix-home-modules";
            path = ./templates/home-manager-config;

            # REUSE-IgnoreStart
            welcomeText = ''
              # Home Manager Configuration Template

              A Home-Manager Configuration template based on Nix Flakes, flake-parts and using robinwalterfit/nix-home-modules.

              ## Prerequisites

              - **Check the README for any template content and replace it with your own**
              - **[Choose a license](https://choosealicense.com/) and update the [LICENSE file](./LICENSE)**
              - **Search for the following and replace the content accordingly:**
                  - `SPDX-FileCopyrightText: NONE`
                  - `SPDX-License-Identifier: NONE`
                  - `SPDX-FileCopyrightText = 'NONE'`
                  - `SPDX-License-Identifier = 'NONE'`
                  - `<GITHUB_HANDLE>`
                  - `<HM_SYSTEM>`
                  - `<HM_USERNAME>`
                  - `<PROJECT_DESCRIPTION>`
                  - `<PROJECT_NAME>`
                  - `'NONE'`
              - **If you want to keep the Contributor Covenant, review the [Code of Conduct](./.github/CODE_OF_CONDUCT.md) and replace any template placeholders**
              - **In order for the flake with the `dev` partition to work, a `flake.lock` is required in `nix/dev`. Run `cd nix/dev` followed by `nix flake lock` to create the lock file**
              - **Run `fd --hidden --type file '.gitkeep' --exec rm` or `find . -name '.gitkeep' -delete` to remove all `.gitkeep` files in the template**
            '';
            # REUSE-IgnoreEnd
          };
          simple = {
            description = "A simple template to start from scratch.";
            path = ./templates/simple;
          };

          default = self.templates.simple;
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
            module = { ... }: { imports = [ ./nix/dev/flake-module.nix ]; };
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

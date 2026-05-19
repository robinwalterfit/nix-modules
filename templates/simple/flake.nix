# SPDX-FileCopyrightText: NONE
# SPDX-License-Identifier: NONE
#
{
  description = "<PROJECT_DESCRIPTION>";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    # See: https://flake.parts/getting-started.html
    flake-parts.lib.mkFlake { inherit inputs; } (
      { self, ... }:
      let
        inherit (inputs) nixpkgs;

        lib = {
          projectName = "<PROJECT_NAME>";
          rev = toString (self.rev or self.dirtyRev or self.lastModified or "unknown");
          shortRev = toString (self.shortRev or self.dirtyShortRev or self.lastModified or "unknown");
        };

        # Provide flake modules
        flakeModules = { };
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

        flake = { inherit flakeModules lib; };
      }
    );
}

# SPDX-FileCopyrightText: NONE
# SPDX-License-Identifier: NONE
#
{
  description = "Private inputs for development purposes. These are used by the top level flake in the `dev` partition, but do not appear in consumers' lock files.";

  inputs = {
    # Flakes don't give us a good way to depend on .., so we don't.
    # As a consequence, this flake only provides dependencies, and
    # we can't use the `nix` CLI as expected.

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "";
    };
    devenv = {
      url = "github:cachix/devenv";
      inputs = {
        git-hooks.follows = "git-hooks";
        nixpkgs.follows = "";
      };
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "";
    };
    nix-modules.url = "github:robinwalterfit/nix-modules";
  };

  outputs = _: {
    # The dev tooling is in ./flake-module.nix
    # See comment at `inputs` above.
    # It is loaded into partitions.dev by the root flake.
  };
}

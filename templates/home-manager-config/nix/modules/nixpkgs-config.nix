# SPDX-FileCopyrightText: NONE
# SPDX-License-Identifier: NONE
#
{ config, lib, ... }:
let
  inherit (lib)
    literalExpression
    literalMD
    mkIf
    mkOption
    types
    ;
in
{
  options.home-modules.allowedUnfreePackages = mkOption {
    default = [ ];
    description = literalMD "List of allowed \"unfree\" packages (`lib.getName`).";
    example = literalExpression ''
      [
        "proton-pass-cli"
      ]
    '';
    type = types.listOf types.str;
  };

  config = mkIf (config.home-modules.allowedUnfreePackages != [ ]) {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.home-modules.allowedUnfreePackages;
  };
}

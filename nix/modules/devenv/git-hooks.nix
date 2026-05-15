# SPDX-FileCopyrightText: 2026 Robin Walter <hello@robinwalter.me>
# SPDX-License-Identifier: MIT
#
# Reusable collection of git hooks
#
# See also:
#   - https://devenv.sh/git-hooks/
#   - https://github.com/cachix/git-hooks.nix
{ lib, pkgs, ... }:
let
  inherit (lib) mkDefault;
in
{
  git-hooks = {
    default_stages = [ "pre-commit" ];

    hooks = {
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2026 Zachary Rice
      # SPDX-SnippetCopyrightText: 2026 Robin Walter <hello@robinwalter.me>
      # SPDX-License-Identifier: MIT
      #
      # Betterleaks - custom hook
      #
      # See: https://github.com/betterleaks/betterleaks/blob/2736d9d8e9932c7b787a678cd2f64bd124671854/.pre-commit-hooks.yaml#L15-L19
      betterleaks = {
        description = mkDefault "Detect hardcoded secrets using Betterleaks";
        enable = mkDefault true;
        entry = mkDefault "${pkgs.betterleaks}/bin/betterleaks git --pre-commit --redact --staged --verbose";
        language = mkDefault "system";
        name = mkDefault "Detect hardcoded secrets";
        pass_filenames = mkDefault false;
        stages = [ "pre-push" ];
      };
      # SPDX-SnippetEnd

      # Cocogitto - custom hook
      cog-verify = {
        description = mkDefault "Check, if provided commit message is conventional commit compliant";
        enable = mkDefault true;
        entry = mkDefault "${pkgs.cocogitto}/bin/cog verify --file";
        language = mkDefault "system";
        name = mkDefault "Cocogitto verification";
        stages = [ "commit-msg" ];
      };
      cog-check = {
        description = mkDefault "Check, if all past commit messages are conventional commit compliant";
        enable = mkDefault true;
        entry = mkDefault "${pkgs.cocogitto}/bin/cog check";
        language = mkDefault "system";
        name = mkDefault "Cocogitto check commit message";
        pass_filenames = mkDefault false;
        stages = [ "pre-push" ];
      };

      # REUSE
      reuse = {
        enable = mkDefault true;
        stages = [ "pre-push" ];
      };

      # Scan for secrets
      trufflehog = {
        enable = mkDefault true;
        stages = [ "pre-push" ];
      };

      # Use treefmt.nix
      treefmt = {
        enable = mkDefault true;
      };
    };

    # Use prek as alternative pre-commit implementation
    package = pkgs.prek;
  };
}

# SPDX-FileCopyrightText: 2026 Robin Walter <hello@robinwalter.me>
# SPDX-License-Identifier: MIT
#
# Reusable collection of git hooks
#
# See also:
#   - https://devenv.sh/git-hooks/
#   - https://github.com/cachix/git-hooks.nix
{ pkgs, ... }:
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
        description = "Detect hardcoded secrets using Betterleaks";
        enable = true;
        entry = "${pkgs.betterleaks}/bin/betterleaks git --pre-commit --redact --staged --verbose";
        language = "system";
        name = "Detect hardcoded secrets";
        pass_filenames = false;
        stages = [ "pre-push" ];
      };
      # SPDX-SnippetEnd

      # Cocogitto - custom hook
      cog-verify = {
        description = "Check, if provided commit message is conventional commit compliant";
        enable = true;
        entry = "${pkgs.cocogitto}/bin/cog verify --file";
        language = "system";
        name = "Cocogitto verification";
        stages = [ "commit-msg" ];
      };
      cog-check = {
        description = "Check, if all past commit messages are conventional commit compliant";
        enable = true;
        entry = "${pkgs.cocogitto}/bin/cog check";
        language = "system";
        name = "Cocogitto check commit message";
        pass_filenames = false;
        stages = [ "pre-push" ];
      };

      # REUSE
      reuse = {
        enable = true;
        stages = [ "pre-push" ];
      };

      # Scan for secrets
      trufflehog = {
        enable = true;
        stages = [ "pre-push" ];
      };

      # Use treefmt.nix
      treefmt = {
        enable = true;
      };
    };

    # Use prek as alternative pre-commit implementation
    package = pkgs.prek;
  };
}

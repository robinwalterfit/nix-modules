# SPDX-FileCopyrightText: 2026 Robin Walter <hello@robinwalter.me>
# SPDX-License-Identifier: MIT
#
# Meta information
{ self, ... }:
{
  # See for more information: https://github.com/NixOS/nixpkgs/tree/master/maintainers
  maintainers = {
    robinwalterfit = {
      email = "hello@robinwalter.me";
      github = "robinwalterfit";
      githubId = "27889073";
      name = "Robin Walter";
    };
  };

  projectName = "nix-modules";
  rev = toString (self.rev or self.dirtyRev or self.lastModified or "unknown");
  shortRev = toString (self.shortRev or self.dirtyShortRev or self.lastModified or "unknown");
}

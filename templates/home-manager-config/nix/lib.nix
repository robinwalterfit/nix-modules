# SPDX-FileCopyrightText: NONE
# SPDX-License-Identifier: NONE
#
# Meta information
{ self, ... }:
{
  projectName = "home-manager-config";

  # Use (short) git revision hash or "unknown", if there are uncommitted changes
  #
  # See https://discourse.nixos.org/t/flakes-accessing-selfs-revision/11237/8
  rev = toString (self.rev or self.dirtyRev or self.lastModified or "unknown");
  shortRev = toString (self.shortRev or self.dirtyShortRev or self.lastModified or "unknown");
}

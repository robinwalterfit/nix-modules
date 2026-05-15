# SPDX-FileCopyrightText: 2026 Robin Walter <hello@robinwalter.me>
# SPDX-License-Identifier: MIT
#
# Universally reusable definitions of packages
_: {
  cargoPluginPackages =
    pkgs: with pkgs; [
      cargo-about
      cargo-audit
      cargo-auditable
      cargo-crev
      cargo-cyclonedx
      cargo-deny
      cargo-edit
      cargo-expand
      cargo-hakari
      cargo-insta
      cargo-lock
      cargo-modules
      cargo-msrv
      cargo-mutants
      cargo-nextest
      cargo-tarpaulin
      cargo-vet
    ];

  corePackages =
    {
      pkgs,
      useRustReimplementations ? false,
    }:
    with pkgs;
    let
      conditionalCoreutils = if useRustReimplementations then uutils-coreutils-noprefix else coreutils-full;
      conditionalFindutils = if useRustReimplementations then uutils-findutils else findutils;
    in
    [
      conditionalCoreutils
      conditionalFindutils
    ];

  debugPackages =
    {
      pkgs,
      useRustReimplementations ? false,
    }:
    with pkgs;
    let
      # TODO(hello@robinwalter.me): uutils-procps currently depends on systemd-minimal-libs-259.3 which is obviously unavailable on macOS
      inherit (pkgs.stdenv.hostPlatform) isLinux;
      useRustOnLinux = useRustReimplementations && isLinux;
      conditionalProcps = if useRustOnLinux then uutils-procps else procps;

      linuxOnlyPackages =
        if isLinux then
          [
            ltrace
            strace
          ]
        else
          [ ];
    in
    [ conditionalProcps ] ++ linuxOnlyPackages;

  developmentPackages =
    {
      pkgs,
      useRustReimplementations ? false,
    }:
    with pkgs;
    let
      conditionalDiffutils = if useRustReimplementations then uutils-diffutils else diffutils;
    in
    [
      cocogitto
      conditionalDiffutils
      delta
      git
      go-task
      grex
      just
      melody
      prek
      reuse
      secretspec
      shellcheck
    ];

  devShellPackages =
    pkgs: with pkgs; [
      git-lfs
      nixfmt
    ];

  essentialPackages =
    pkgs: with pkgs; [
      bat
      curl
      eza
      jq
      ripgrep
      yq
      zstd
    ];

  securityAnalysisPackages =
    pkgs: with pkgs; [
      betterleaks
      cosign
      grype
      syft
      trivy
      trufflehog
    ];

  usefulPackages =
    pkgs: with pkgs; [
      bottom
      gdu
      rm-improved
      rsync
    ];
}

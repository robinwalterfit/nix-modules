# SPDX-FileCopyrightText: 2026 Robin Walter <hello@robinwalter.me>
# SPDX-License-Identifier: MIT
#
{
  config,
  inputs,
  self,
  ...
}:
let
  inherit (inputs) devenv nixpkgs treefmt-nix;
in
{
  # https://github.com/NixOS/nixpkgs/blob/master/lib/systems/flake-systems.nix
  systems = nixpkgs.lib.systems.flakeExposed;

  imports = [
    devenv.flakeModule
    treefmt-nix.flakeModule
    # Import own modules
    self.flakeModules.treefmt
  ];

  perSystem =
    {
      config,
      pkgs,
      treefmtConfigFiles,
      ...
    }:
    {
      # Project's devenv shell definitions
      devenv.shells = {
        default = {
          name = "${self.lib.projectName}-${self.lib.shortRev}";

          # Import our own devenv modules
          imports = [
            self.devenvModules.git-hooks
            self.devenvModules.shell-base
          ];

          enterShell = ''
            ln --force --symbolic '${treefmtConfigFiles.biome}' './biome.json'
            ln --force --symbolic '${treefmtConfigFiles.taplo}' './.taplo.toml'
          '';

          # Use treefmt wrapper with our configuration and tools in git-hooks
          git-hooks.hooks.treefmt.package = config.treefmt.build.wrapper;

          languages = {
            # Enable Shell development
            shell.enable = true;
            shell.lsp.enable = true;
          };

          # Install additional packages
          packages =
            with pkgs;
            [
              # Add GitHub CLI
              gh

              # Add treefmt
              config.treefmt.build.wrapper
            ]
            ++ builtins.attrValues config.treefmt.build.programs;

          # Declare default options of the projects own development shells
          robinwalterfit = {
            nix-modules = {
              devenv.zed = {
                enable = true;
                extraConfig = {
                  languages = {
                    JSON = {
                      format_on_save = "on";
                      formatter = {
                        language_server = {
                          name = "biome";
                        };
                      };
                      tab_size = 2;
                    };
                    JSONC = {
                      format_on_save = "on";
                      formatter = {
                        language_server = {
                          name = "biome";
                        };
                      };
                      tab_size = 2;
                    };
                    TOML = {
                      tab_size = 2;
                    };
                    YAML = {
                      tab_size = 2;
                    };
                  };
                  lsp = {
                    biome = {
                      binary = {
                        arguments = [ "lsp-proxy" ];
                        path = "${pkgs.biome}/bin/biome";
                      };
                      settings = {
                        require_config_file = true;
                      };
                    };
                  };
                };
              };

              useRustReimplementations = true;
            };
          };
        };
      };

      # Project's treefmt configuration
      treefmt = {
        programs = {
          biome.enable = true;

          taplo = {
            enable = true;

            settings = {
              include = [ "**/REUSE.toml" ];
            };
          };
        };

        settings.formatter = {
          nufmt.enable = true;
        };
      };
    };

  flake = {
    # For repl exploration / debug
    config.config = config;
  };
}

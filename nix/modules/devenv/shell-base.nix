# SPDX-FileCopyrightText: 2026 Robin Walter <hello@robinwalter.me>
# SPDX-License-Identifier: MIT
#
# Base configuration for devenv shells
#
# See also:
#   - https://devenv.sh/guides/using-with-flake-parts/
#   - https://flake.parts/options/devenv.html
{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (lib)
    literalExpression
    literalMD
    mkDefault
    mkIf
    mkOption
    recursiveUpdate
    types
    ;

  cfg = config.robinwalterfit.nix-modules;

  # SPDX-SnippetBegin
  # SPDX-SnippetCopyrightText: 2026 Robin Walter <hello@robinwalter.me>
  # SPDX-License-Identifier: CC0-1.0
  defaultVSCodeExtensionRecommendations = [ "jnoortheen.nix-ide" ];
  # SPDX-SnippetEnd

  # SPDX-SnippetBegin
  # SPDX-SnippetCopyrightText: 2026 Robin Walter <hello@robinwalter.me>
  # SPDX-License-Identifier: CC0-1.0
  defaultVSCodeSettings = { };
  # SPDX-SnippetEnd

  # SPDX-SnippetBegin
  # SPDX-SnippetCopyrightText: 2026 Robin Walter <hello@robinwalter.me>
  # SPDX-License-Identifier: CC0-1.0
  #
  # Folder-specific settings
  #
  # For a full list of overridable settings, and general information on folder-specific
  # settings, see the documentation: https://zed.dev/docs/configuring-zed#settings-files
  defaultZedSettings = {
    languages = {
      Nix = {
        format_on_save = mkDefault "on";
        tab_size = mkDefault 2;
      };
    };
  };
  # SPDX-SnippetEnd
in
{
  _file = ./shell-base.nix;
  options.robinwalterfit.nix-modules = {
    devenv = {
      vscode = {
        enable = mkOption {
          default = false;
          description = literalMD "If `true`, create and symlink `.vscode/` files in project folder.";
          type = types.bool;
        };

        extraConfig = mkOption {
          default = { };
          description = literalMD "Additional settings to include in `.vscode/settings.json`.";
          example = literalExpression ''
            {
              "biome.lsp" = {
                bin = "''${pkgs.biome}/bin/biome";
              };
              "biome.requireConfiguration" = true;
              "editor.codeActionsOnSave" = {
                "source.fixAll.biome" = "explicit";
                "source.organizeImports.biome" = "explicit";
              };
            }
          '';
          type = types.attrsOf types.anything;
        };

        extraExtensionRecommendations = mkOption {
          default = [ ];
          description = literalMD "Additional extension recommendations to include in `.vscode/extensions.json`.";
          example = literalExpression ''
            [
              "alefragnani.bookmarks"
              "arrterian.nix-env-selector"
              "bierner.github-markdown-preview"
              "biomejs.biome"
              "mads-hartmann.bash-ide-vscode"
            ]
          '';
          type = types.listOf types.str;
        };
      };

      zed = {
        enable = mkOption {
          default = false;
          description = literalMD "If `true`, create and symlink `.zed/settings.json` in project folder.";
          type = types.bool;
        };

        extraConfig = mkOption {
          default = { };
          description = literalMD ''
            Additional settings to include in `.zed/settings.json`.

            For a full list of overridable settings, and general information on folder-specific
            settings, see the documentation: https://zed.dev/docs/configuring-zed#settings-files
          '';
          example = literalExpression ''
            {
              languages = {
                Astro = {
                  formatter = {
                    language_server = {
                      name = "biome";
                    };
                  };
                };
                CSS = {
                  formatter = {
                    language_server = {
                      name = "biome";
                    };
                  };
                };
                GraphQL = {
                  formatter = {
                    language_server = {
                      name = "biome";
                    };
                  };
                };
                HTML = {
                  formatter = {
                    language_server = {
                      name = "biome";
                    };
                  };
                };
                JSON = {
                  formatter = {
                    language_server = {
                      name = "biome";
                    };
                  };
                };
                JSONC = {
                  formatter = {
                    language_server = {
                      name = "biome";
                    };
                  };
                };
                JSX = {
                  code_actions_on_format = {
                    "source.fixAll.biome" = true;
                    "source.organizeImports.biome" = true;
                  };
                  formatter = {
                    language_server = {
                      name = "biome";
                    };
                  };
                };
                JavaScript = {
                  code_actions_on_format = {
                    "source.fixAll.biome" = true;
                    "source.organizeImports.biome" = true;
                  };
                  formatter = {
                    language_server = {
                      name = "biome";
                    };
                  };
                };
                Svelte = {
                  formatter = {
                    language_server = {
                      name = "biome";
                    };
                  };
                };
                TSX = {
                  code_actions_on_format = {
                    "source.fixAll.biome" = true;
                    "source.organizeImports.biome" = true;
                  };
                  formatter = {
                    language_server = {
                      name = "biome";
                    };
                  };
                };
                TypeScript = {
                  code_actions_on_format = {
                    "source.fixAll.biome" = true;
                    "source.organizeImports.biome" = true;
                  };
                  formatter = {
                    language_server = {
                      name = "biome";
                    };
                  };
                };
                "Vue.js" = {
                  formatter = {
                    language_server = {
                      name = "biome";
                    };
                  };
                };
              };
              lsp = {
                biome = {
                  binary = {
                    arguments = [ "lsp-proxy" ];
                    path = "''${pkgs.biome}/bin/biome";
                  };
                  settings = {
                    require_config_file = true;
                  };
                };
              };
            }
          '';
          type = types.attrsOf types.anything;
        };
      };
    };

    useRustReimplementations = mkOption {
      default = false;
      description = literalMD "If `true`, use `uutils` instead of GNU tools (if available).";
      type = types.bool;
    };
  };
  config = {
    # Disable cachix
    cachix.enable = false;

    # Enable git-delta for diffs
    delta.enable = true;

    files = {
      ".vscode/extensions.json" = mkIf cfg.devenv.vscode.enable {
        json = {
          recommendations = defaultVSCodeExtensionRecommendations ++ cfg.devenv.vscode.extraExtensionRecommendations;
        };
      };

      ".vscode/settings.json" = mkIf cfg.devenv.vscode.enable {
        json = recursiveUpdate defaultVSCodeSettings cfg.devenv.vscode.extraConfig;
      };

      ".zed/settings.json" = mkIf cfg.devenv.zed.enable {
        json = recursiveUpdate defaultZedSettings cfg.devenv.zed.extraConfig;
      };
    };

    languages = {
      # Enable nix development
      nix.enable = true;
      nix.lsp.enable = true;
    };

    # Define list of packages that should always be available in devenv shells
    packages =
      (self.lib.corePackages {
        inherit pkgs;
        inherit (cfg) useRustReimplementations;
      })
      ++ (self.lib.debugPackages {
        inherit pkgs;
        inherit (cfg) useRustReimplementations;
      })
      ++ (self.lib.developmentPackages {
        inherit pkgs;
        inherit (cfg) useRustReimplementations;
      })
      ++ (self.lib.devShellPackages pkgs)
      ++ (self.lib.essentialPackages pkgs)
      ++ (self.lib.securityAnalysisPackages pkgs);
  };
}

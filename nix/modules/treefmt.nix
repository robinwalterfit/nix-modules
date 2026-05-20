# SPDX-FileCopyrightText: 2026 Robin Walter <hello@robinwalter.me>
# SPDX-License-Identifier: MIT
#
# Reusable treefmt configuration
#
# See also:
#   - https://treefmt.com/latest/
{ flake-parts-lib, lib, ... }:
let
  inherit (lib)
    literalExpression
    literalMD
    mkOption
    recursiveUpdate
    types
    ;
  inherit (flake-parts-lib) mkPerSystemOption;

  # Default nufmtConfig
  nufmtConfigFile = toString ../../.config/nufmt.nuon;
in
{
  options = {
    perSystem = mkPerSystemOption (
      { config, pkgs, ... }:
      let
        inherit (pkgs.formats) json toml yaml;

        cfg = config.robinwalterfit.nix-modules.treefmt;

        # SPDX-SnippetBegin
        # SPDX-SnippetCopyrightText: 2026 Robin Walter <hello@robinwalter.me>
        # SPDX-License-Identifier: MIT OR Apache-2.0
        defaultBiomeConfig = {
          "$schema" = "${pkgs.biome}/share/schema.json";
          css = {
            formatter = {
              enabled = true;
              indentStyle = "space";
              indentWidth = 2;
            };
            linter = {
              enabled = true;
            };
            parser = {
              cssModules = true;
              tailwindDirectives = true;
            };
          };
          files = {
            includes = [
              "**"
              "!!/nix/store"
            ];
          };
          formatter = {
            attributePosition = "auto";
            enabled = true;
            formatWithErrors = true;
            indentStyle = "space";
            indentWidth = 2;
            lineEnding = "lf";
            lineWidth = 120;
          };
          graphql = {
            formatter = {
              enabled = true;
              indentStyle = "space";
            };
            linter = {
              enabled = true;
            };
          };
          javascript = {
            formatter = {
              jsxQuoteStyle = "double";
            };
          };
          json = {
            formatter = {
              enabled = true;
              trailingCommas = "none";
            };
          };
          linter = {
            rules = {
              a11y = {
                noAriaUnsupportedElements = "warn";
                useAltText = "warn";
                useAriaPropsForRole = "warn";
                useValidAriaProps = "warn";
                useValidAriaValues = "warn";
              };
              correctness = {
                noChildrenProp = "error";
                useExhaustiveDependencies = "warn";
                useHookAtTopLevel = "error";
                useJsxKeyInIterable = "error";
              };
              recommended = false;
              security = {
                noDangerouslySetInnerHtmlWithChildren = "error";
                noBlankTarget = "error";
              };
              style = {
                noImplicitBoolean = "error";
                useFragmentSyntax = "error";
              };
              suspicious = {
                noCommentText = "error";
                noDuplicateJsxProps = "error";
              };
            };
          };
          overrides = [
            {
              includes = [ "**/*.astro" ];
              linter = {
                rules = {
                  correctness = {
                    noUnusedImports = "off";
                    noUnusedVariables = "off";
                  };
                };
              };
            }
          ];
          root = true;
          vcs = {
            clientKind = "git";
            enabled = true;
            useIgnoreFile = true;
          };
        };
        # SPDX-SnippetEnd

        # SPDX-SnippetBegin
        # SPDX-SnippetCopyrightText: 2026 Robin Walter <hello@robinwalter.me>
        # SPDX-License-Identifier: CC0-1.0
        defaultClippyConfig = {
          # See https://doc.rust-lang.org/clippy/lint_configuration.html for all available lints
          allow-expect-in-tests = true;
          allow-unwrap-in-tests = true;
          check-private-items = true;
          disallowed-macros = [
            {
              path = "std::dbg";
              reason = "use the log or tracing for debug outputs";
            }
            { path = "std::debug_assert"; }
            { path = "std::debug_assert_eq"; }
            { path = "std::debug_assert_ne"; }
            {
              path = "std::eprint";
              reason = "use the log or tracing crate instead";
            }
            {
              path = "std::eprintln";
              reason = "use the log or tracing crate instead";
            }
            # Usage of include seems kinda dirty
            { path = "std::include"; }
            { path = "std::include_bytes"; }
            { path = "std::include_str"; }
            {
              path = "std::panic";
              reason = "never panic, raise an error instead";
            }
            {
              path = "std::print";
              reason = "use the log or tracing crate instead";
            }
            {
              path = "std::println";
              reason = "use the log or tracing crate instead";
            }
            {
              path = "std::try";
              reason = "use ? operator";
            }
          ];
          disallowed-types = [ ];
          max-include-file-size = 0;
          missing-docs-in-crate-items = true;
          inherit (cfg.clippy) msrv;
          type-complexity-threshold = cfg.clippy.typeComplexityThreshold;
          warn-on-all-wildcard-imports = true;
        };
        # SPDX-SnippetEnd

        # SPDX-SnippetBegin
        # SPDX-SnippetCopyrightText: 2026 Robin Walter <hello@robinwalter.me>
        # SPDX-License-Identifier: CC0-1.0
        defaultRuffConfig = {
          # Exclude a variety of commonly ignored directories
          extend-exclude = [ ];

          line-length = cfg.ruff.lineLength;

          # Define the output format -> this should be changed via the CLI in CI tests to `sarif`
          output-format = cfg.ruff.outputFormat;

          target-version = cfg.ruff.targetVersion;

          format = {
            indent-style = "space";
            skip-magic-trailing-comma = true;
          };

          lint = {
            preview = cfg.ruff.lintPreview;
            # Rulesets enabled:
            select = [
              "A" # -> flake8-builtins
              "ANN" # -> annotations
              "ASYNC" # -> flake8-async
              "B" # -> bugbear
              "BLE" # -> flake8-blind-except
              "C4" # -> flake8-comprehensions
              "C90" # -> McCabe complexity
              "COM" # -> flake8-commas
              "CPY" # -> copyright
              "D" # -> Pydocstyle
              "DOC" # -> pydoclint
              "DTZ" # -> flake8-datetimetz
              "E" # -> Pycodestyle
              "EM" # -> errmsg
              "ERA" # -> eradicate
              "EXE" # -> flake8-executable
              "F" # -> Pyflakes
              "FA" # -> flake8-future-annotations
              "FAST" # -> FastAPI
              "FIX" # -> flake8-fixme
              "FURB" # -> refurb
              "G" # -> logging-format
              "I" # -> isort
              "ICN" # -> flake8-import-conventions
              "INP" # -> flake8-non-pep420
              "ISC" # -> flake8-implicit-str-concat
              "LOG" # -> logging
              "N" # -> pep8-naming
              "NPY" # -> NumPy-specific rules
              "PD" # -> pandas-vet
              "PERF" # -> Perflint
              "PL" # -> Pylint
              "PLC" # -> Pylint: Convention
              "PLE" # -> Pylint: Error
              "PLR" # -> Pylint: Refactor
              "PLW" # -> Pylint: Warning
              "PT" # -> pytest-style
              "PTH" # -> use-pathlib
              "PYI" # -> flake8-pyi
              "RUF" # -> ruff
              "S" # -> Bandit Ruleset
              "SIM" # -> flake8-simplify
              "SLF" # -> flake8-self
              "TC" # -> flake8-type-checking
              "TD" # -> todos
              "TRY" # -> tryceratops
              "UP" # -> pyupgrade
              "W" # -> Pycodestyle Warnings
              "YTT" # -> flake8-2020
            ];
            ignore = [ "COM812" ];
          };

          lint.flake8-copyright = {
            notice-regex = "(?i)(?:SPDX-(?:File|Snippet)CopyrightText:|Copyright|©)\\s+((?:\\(C\\)|©)\\s+)?(?:\\d{4}((-|,\\s)\\d{4})*)?";
          };

          lint.flake8-quotes = {
            docstring-quotes = "double";
          };

          lint.isort = {
            case-sensitive = true;
            split-on-trailing-comma = false;
          };

          # Ignore `E402` (import violations) in all `__init__.py` files and in selected subdirectories
          # Ignore `S101` (use of `assert` detected) in tests
          lint.per-file-ignores = {
            # Ignore `E402` (import violations) in all `__init__.py` files, and in `path/to/file.py`.
            "__init__.py" = [ "E402" ];
            "**/{tests,docs,tools}/*" = [
              "E402"
              "INP001"
              "PLC2701"
              "PLR6301"
              "S101"
            ];
            # Ignore `D` rules everywhere except for the `src/` directory.
            "!src/**.py" = [ "D" ];
          };

          lint.pydocstyle = {
            convention = cfg.ruff.pydocstyleConvention;
          };
        };
        # SPDX-SnippetEnd

        # SPDX-SnippetBegin
        # SPDX-SnippetCopyrightText: 2026 Robin Walter <hello@robinwalter.me>
        # SPDX-License-Identifier: CC0-1.0
        defaultRustfmtConfig = {
          # See https://rust-lang.github.io/rustfmt/ for all available options
          edition = "2024";
          match_block_trailing_comma = true;
          newline_style = "Unix";
          style_edition = "2021";
          use_try_shorthand = true;

          # Unstable, but in the future probably useful
          # group_imports = "StdExternalCrate" # Matches Python isort conventions
          # imports_granularity = "Crate"
          # normalize_comments = true
          # reorder_impl_items = true
          # style_edition = "2024" # Listed as unstable option, however, CLI lists this as an option
        };
        # SPDX-SnippetEnd

        # SPDX-SnippetBegin
        # SPDX-SnippetCopyrightText: 2026 Robin Walter <hello@robinwalter.me>
        # SPDX-License-Identifier: CC0-1.0
        defaultTaploConfig = {
          formatting = {
            column_width = 100;
            indent_string = "  ";
            indent_tables = true;
            reorder_keys = true;
            trailing_newline = false;
          };
        };
        # SPDX-SnippetEnd

        # SPDX-SnippetBegin
        # SPDX-SnippetCopyrightText: 2026 Robin Walter <hello@robinwalter.me>
        # SPDX-License-Identifier: CC0-1.0
        defaultTyConfig = {
          terminal = {
            error-on-warning = true;
          };
        };
        # SPDX-SnippetEnd

        # SPDX-SnippetBegin
        # SPDX-SnippetCopyrightText: 2026 Robin Walter <hello@robinwalter.me>
        # SPDX-License-Identifier: CC0-1.0
        defaultYamllintConfig = {
          extends = "default";
          rules = {
            braces = {
              level = "error";
              max-spaces-inside = 1;
            };
            brackets = {
              level = "error";
              max-spaces-inside = 1;
            };
            comments = {
              min-spaces-from-content = 1;
            };
            comments-indentation = false;
            line-length = {
              level = "warning";
              max = 160;
            };
            octal-values = {
              forbid-explicit-octal = true;
              forbid-implicit-octal = true;
            };
            truthy = "disable";
          };
        };
        # SPDX-SnippetEnd

        biomeConfigFile = (json { }).generate "biome.json" (recursiveUpdate defaultBiomeConfig cfg.biome.extraConfig);
        clippyConfigFile = (toml { }).generate ".clippy.toml" (recursiveUpdate defaultClippyConfig cfg.clippy.extraConfig);
        ruffConfigFile = (toml { }).generate "ruff.toml" (recursiveUpdate defaultRuffConfig cfg.ruff.extraConfig);
        rustfmtConfigFile = (toml { }).generate "rustfmt.toml" (recursiveUpdate defaultRustfmtConfig cfg.rustfmt.extraConfig);
        taploConfigFile = (toml { }).generate ".taplo.toml" (
          recursiveUpdate defaultTaploConfig config.treefmt.programs.taplo.settings
        );
        tyConfigFile = (toml { }).generate "ty.toml" (recursiveUpdate defaultTyConfig cfg.ty.extraConfig);
        yamllintConfigFile = (yaml { }).generate ".yamllint" (
          recursiveUpdate defaultYamllintConfig config.treefmt.programs.yamllint.settings
        );

        # clippy requires its configuration file to be named clippy.toml or .clippy.toml exactly
        clippyConfDir = pkgs.runCommandLocal "clippy-config" { } ''
          mkdir --parents "$out"
          cp '${clippyConfigFile}' "$out/.clippy.toml"
        '';
      in
      {
        _file = ./treefmt.nix;
        options.robinwalterfit.nix-modules.treefmt = {
          biome = {
            extraConfig = mkOption {
              default = { };
              description = literalMD ''
                Additional `biome` configuration that gets merged with the default config.
                See [`biome` configuration reference](https://biomejs.dev/reference/configuration/)
              '';
              example = literalExpression ''
                {
                  vcs = {
                    root = toString ./.;
                  };
                }
              '';
              type = types.attrsOf types.anything;
            };
          };
          clippy = {
            extraConfig = mkOption {
              default = { };
              description = literalMD ''
                Additional `clippy` configuration that gets merged with the default config.
                See [`clippy` configuration reference](https://doc.rust-lang.org/clippy/lint_configuration.html)
              '';
              example = literalExpression ''
                {
                  disallowed-types = [
                    # Can use a string as the path of the disallowed type.
                    { path = "std::collections::BTreeMap"; }
                    # Can also use an inline table with a `path` key.
                    { path = "std::net::TcpListener"; }
                    # When using an inline table, can add a `reason` for why the type is disallowed.
                    { path = "std::net::Ipv4Addr"; reason = "no IPv4 allowed"; }
                    # Can also add a `replacement` that will be offered as a suggestion.
                    { path = "std::sync::Mutex"; reason = "prefer faster & simpler non-poisonable mutex"; replacement = "parking_lot::Mutex"; }
                    # This would normally error if the path is incorrect, but with `allow-invalid` = `true`, it will be silently ignored
                    { path = "std::invalid::Type"; reason = "use alternative instead"; allow-invalid = true; }
                  ];
                }
              '';
              type = types.attrsOf types.anything;
            };

            msrv = mkOption {
              default = "1.85.0"; # Edition 2024
              description = literalMD "Minimum Supported Rust Version for `clippy.";
              example = "1.80.0";
              type = types.str;
            };

            typeComplexityThreshold = mkOption {
              default = 300;
              description = literalMD ''
                Custom types complexity threshold

                NOTE: because the clippy devs also acknowledge that complexity is hard to define:
                [Clippy Issue#5418 comment on complexity](https://github.com/rust-lang/rust-clippy/issues/5418#issuecomment-610054361)
              '';
              example = 42;
              type = types.int;
            };
          };

          ruff = {
            extraConfig = mkOption {
              default = { };
              description = literalMD ''
                Additional `ruff` configuration that gets merged with the default config.
                See [`ruff` configuration reference](https://docs.astral.sh/ruff/settings/) for all available options.
              '';
              example = literalExpression ''
                {
                  line-length = 79;
                  lint.flake8-copyright.author = "Robin Walter";
                }
              '';
              type = types.attrsOf types.anything;
            };

            # Allow lines to be as long as 100 characters -> this matches Rust conventions
            lineLength = mkOption {
              default = 100;
              description = "Maximum line length";
              example = 79;
              type = types.int;
            };

            lintPreview = mkOption {
              default = true;
              description = literalMD "If `true`, enable linting preview rules";
              type = types.bool;
            };

            outputFormat = mkOption {
              default = "grouped";
              description = "The style in which violation messages should be formatted";
              example = "sarif";
              type = types.enum [
                "azure"
                "concise"
                "full"
                "github"
                "gitlab"
                "grouped"
                "json"
                "junit"
                "pylint"
                "sarif"
              ];
            };

            pydocstyleConvention = mkOption {
              default = "google";
              description = "Whether to use Google-style, NumPy-style conventions, or the PEP 257";
              example = "pep257";
              type = types.enum [
                "google"
                "numpy"
                "pep257"
              ];
            };

            targetVersion = mkOption {
              default = "py310";
              description = "The minimum Python version to target, e.g., when considering automatic code upgrades, like rewriting type annotations";
              example = "py313";
              type = types.str;
            };
          };

          rustfmt = {
            extraConfig = mkOption {
              default = { };
              description = literalMD ''
                Additional `rustfmt` configuration that gets merged with the default config.
                See [`rustfmt` configuration reference](https://rust-lang.github.io/rustfmt/) for all available options.
              '';
              example = literalExpression ''
                {
                  array_width = 60;
                }
              '';
              type = types.attrsOf types.anything;
            };
          };

          ty = {
            extraConfig = mkOption {
              default = { };
              description = ''
                Additional `ty` configuration that gets merged with the default config.
                See [`ty` configuration reference](https://docs.astral.sh/ty/reference/configuration/#__tabbed_1_2) for all available options.
              '';
              example = literalExpression ''
                {
                  rules = {
                    division-by-zero = "ignore";
                    possibly-unresolved-reference = "warn";
                  };
                }
              '';
              type = types.attrsOf types.anything;
            };
          };
        };
        config = {
          # Provide paths to all configuration files for external access
          #
          # This allows to create symlinks into the root repository, e.g.
          #
          # ```sh
          # ln --force --symbolic '${treefmtConfigFiles.ruff}' '${self.outPath}/ruff.toml'
          # ```
          _module.args.treefmtConfigFiles = {
            biome = biomeConfigFile;
            clippy = clippyConfigFile;
            nufmt = nufmtConfigFile;
            ruff = ruffConfigFile;
            rustfmt = rustfmtConfigFile;
            taplo = taploConfigFile;
            ty = tyConfigFile;
            yamllint = yamllintConfigFile;
          };

          treefmt = {
            # Built-in formatters
            programs = {
              biome = {
                settings = recursiveUpdate (recursiveUpdate defaultBiomeConfig { vcs.root = toString ../../.; }) cfg.biome.extraConfig;
                validate = {
                  schema = pkgs.fetchurl {
                    url = "https://biomejs.dev/schemas/2.3.10/schema.json";
                    hash = "sha256-BxZjQ2rAndtYWOIARnlHPjllRzxIZRp+yjBXHjD83g8=";
                  };
                };
              };

              # Experimental
              just = { };

              nixfmt = {
                enable = true;
                indent = 2;
                strict = true;
                width = 120;
              };

              shellcheck = { };
              shfmt = {
                indent_size = 0; # 0 = use tabs
                simplify = true;
              };

              statix = {
                enable = true;
              };

              taplo = {
                settings = defaultTaploConfig;
              };

              yamlfmt = { };
              yamllint = {
                settings = defaultYamllintConfig;
              };
            };

            settings = {
              excludes = [
                "*.lock"
                "result"
              ];

              # Custom formatters
              formatter = {
                # Clippy currently is not supported
                clippy = {
                  command = "${pkgs.bash}/bin/bash";
                  includes = [ "*.rs" ];
                  options = [
                    "-euc"
                    ''
                      export CLIPPY_CONF_DIR="$(dirname "${toString clippyConfDir}")"
                      exec ${pkgs.clippy}/bin/cargo-clippy \
                        "$@"
                    ''
                    "--"
                    "--deny"
                    "warnings"
                    "--fix"
                  ];
                };

                # The Ruff configuration support is currently very limited, therefore we create a custom formatter
                ruff = {
                  command = "${pkgs.ruff}/bin/ruff";
                  includes = [
                    "*.ipynb"
                    "*.py"
                    "*.pyi"
                  ];
                  options = [
                    "--config"
                    "${ruffConfigFile}"
                    "check"
                    "--fix"
                    "--respect-gitignore"
                  ];
                };

                # Nushell formatting
                nufmt = {
                  command = "${pkgs.nufmt}/bin/nufmt";
                  includes = [ "*.nu" ];
                  options = [
                    "--config"
                    "${nufmtConfigFile}"
                  ];
                };

                # The rustfmt configuration support is currently very limited, therefore we create a custom formatter
                rustfmt = {
                  command = "${pkgs.rustfmt}/bin/rustfmt";
                  includes = [ "*.rs" ];
                  options = [
                    "--config-file"
                    "${rustfmtConfigFile}"
                    "--config"
                    "skip_children=true"
                    "--style-edition"
                    "2024"
                  ];
                };

                # Ty currently is not supported
                ty = {
                  command = "${pkgs.ty}/bin/ty";
                  includes = [
                    "*.ipynb"
                    "*.py"
                    "*.pyi"
                  ];
                  options = [
                    "check"
                    "--config-file"
                    "${tyConfigFile}"
                    "--respect-ignore-files"
                  ];
                };
              };
            };
          };
        };
      }
    );
  };
}

# Shared Nix Modules

[![Conventional Branch](https://img.shields.io/badge/Conventional%20Branch-1.0.0-blue.svg?style=flat-square)](https://conventional-branch.github.io/)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg?style=flat-square)](https://conventionalcommits.org)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-3.0-4BAAAA.svg?style=flat-square)](./.github/CODE_OF_CONDUCT.md)
[![prek](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/j178/prek/master/docs/assets/badge-v0.json)](https://github.com/j178/prek)
[![Latest Release](https://img.shields.io/github/v/release/robinwalterfit/nix-modules?style=flat-square)](https://github.com/robinwalterfit/nix-modules/releases)
[![Built with Nix](https://img.shields.io/badge/NixOS-5277C3?style=for-the-badge&logo=nixos&logoColor=white)](https://github.com/NixOS/nixpkgs)
[![Zed](https://img.shields.io/badge/Zed-white?style=flat-square&logo=zedindustries&logoColor=084CCF)](https://zed.dev/)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/robinwalterfit/nix-modules)

Reusable Nix Modules for all of my projects.

## What This Is

This project provides reusable modules for development with [Nix Flakes](https://nix.dev/concepts/flakes.html). All modules are meant for the usage with development shells. The modules provide reusable definitions of git hooks used via [`git-hooks.nix`](https://github.com/cachix/git-hooks.nix), linter/formatter configurations via [`treefmt-nix`](https://github.com/numtide/treefmt-nix), grouped package lists and a base configuration for [`devenv` shells](https://devenv.sh/basics/).

## Prerequisites

- [Nix](https://nixos.org/download) with flakes enabled (or an alternative like from [Lix](https://lix.systems/))
- Optional: If the development shell shall be loaded into the current shell instead of replacing it: [`direnv`](https://direnv.net/) and [`nix-direnv`](https://github.com/nix-community/nix-direnv)

## Quick Start

Include this flake in your own flake's `inputs`:

```nix
{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-modules = {
      url = "github:robinwalterfit/nix-modules";
      inputs.flake-parts.follows = "flake-parts";
    };
  };
}
```

However, in order to keep your dependencies as small as possible and because these modules are only relevant for development, it would probably be best to only include `nix-modules` in a [`dev` partition](https://flake.parts/options/flake-parts-partitions.html).

Check [`flake.nix`](./flake.nix), [`nix/dev/flake.nix`](./nix/dev/flake.nix) and [`nix/dev/flake-module.nix`](./nix/dev/flake-module.nix) of this project to see a working example. In your own `nix/dev/flake.nix` add:

```nix
{
  inputs = {
    nix-modules = {
      url = "github:robinwalterfit/nix-modules";
      inputs.flake-parts.follows = "";
    };
  };
}
```

## Development Shell

A development shell with useful tooling is provided:

```bash
nix develop --no-pure-eval
```

The above command will replace the current shell. `direnv` and `nix-direnv` provide an alternative way to load the Nix development shell into the current shell instead. Create a new file `.envrc` in the root of the repository and paste the following content into the file:

```sh
#!/usr/bin/env bash

if ! has nix_direnv_version || ! nix_direnv_version 3.1.0; then
  source_url "https://raw.githubusercontent.com/nix-community/nix-direnv/3.1.0/direnvrc" "sha256-yMJ2OVMzrFaDPn7q8nCBZFRYpL/f0RcHzhmw/i6btJM="
fi

export DEVENV_IN_DIRENV_SHELL=true

watch_file flake.nix
watch_file flake.lock
watch_file nix/dev/flake.lock
# shellcheck disable=SC2046
watch_file $(find './nix' -name '*.nix')

use flake . --no-pure-eval
```

Now run `direnv allow` in the project root, where `.envrc` is located. The development shell will now be loaded into the current shell whenever any directory of this project will be entered and automatically unloaded, when the project space will be left.

**NOTE**: The first time the development shell will be loaded can take a few minutes.

## Project Structure

```text
nix-modules/
├─ .config/
├─ LICENSES/
├─ nix/
│  ├─ dev/
│  │  ├─ flake-module.nix
│  │  ├─ flake.lock
│  │  ├─ flake.nix
│  ├─ lib/
│  │  ├─ meta.nix
│  │  ├─ packages.nix
│  ├─ modules/
│  │  ├─ devenv/
├─ templates/
├─ flake.lock
├─ flake.nix
```

- `.config/`: Holds default configuration files, which use formats, that cannot be generated with Nix.
- `LICENSES/`: Holds all licenses used by this project.
- `nix/dev/`: Holds the "sub-" flake and development shell of the `dev` partition.
- `nix/lib/`: Holds general reusable or project specific values
- `nix/modules/`: Holds the `flakeModules` this project provides.
- `nix/modules/devenv/`: Holds the `devenvModules` this project provides.
- `templates/`: Provides templates which can be used via: `nix flake init --template github:robinwalterfit/nix-modules#<TEMPLATE>`
- `flake.nix`: Main flake file following `flake-parts`.

## Templates

This project provides different templates. The templates themselves are licensed under public domain (see [CC0-1.0](./LICENSES/CC0-1.0.txt)). Choose any template which suits your needs. However, note that some files are provided which cannot be licensed under public domain. Check the `REUSE.toml` file in any template's root directory and review all file's license comment header. Delete any files you do not need or want in your project.

## Contributing

Read the [contributing guide](./CONTRIBUTING.md) to learn about the development process and how to submit changes.

## Links

- `nix-modules` repository: [https://github.com/robinwalterfit/nix-modules](https://github.com/robinwalterfit/nix-modules)
- Issue tracker: [https://github.com/robinwalterfit/nix-modules/issues](https://github.com/robinwalterfit/nix-modules/issues)
- More Links:
    - ASCII Tree Generator: [https://ascii-tree-generator.com/](https://ascii-tree-generator.com/)
    - Biome: [https://biomejs.dev/](https://biomejs.dev/)
    - Cocogitto: [https://docs.cocogitto.io/](https://docs.cocogitto.io/)
    - Collection of useful `.gitattributes` templates: [https://github.com/gitattributes/gitattributes](https://github.com/gitattributes/gitattributes)
    - Conventional Branch: [https://conventional-branch.github.io/](https://conventional-branch.github.io/)
    - Conventional Commits: [https://www.conventionalcommits.org/en/v1.0.0/](https://www.conventionalcommits.org/en/v1.0.0/)
    - contributing-template: [https://github.com/nayafia/contributing-template](https://github.com/nayafia/contributing-template)
    - Contributor Covenant Code of Conduct: [https://www.contributor-covenant.org/version/3/0/code_of_conduct/](https://www.contributor-covenant.org/version/3/0/code_of_conduct/)
    - Developer Certificate of Origin: [https://developercertificate.org/](https://developercertificate.org/)
    - `devenv`: [https://devenv.sh/guides/using-with-flake-parts/](https://devenv.sh/guides/using-with-flake-parts/)
    - `direnv`: [https://direnv.net/](https://direnv.net/)
    - Flakes: [https://nix.dev/concepts/flakes.html](https://nix.dev/concepts/flakes.html)
    - `flake-parts`: [https://flake.parts/](https://flake.parts/)
    - `.gitignore` Generator: [https://gitignore.io](https://gitignore.io)
    - Git Flow: [https://nvie.com/posts/a-successful-git-branching-model/](https://nvie.com/posts/a-successful-git-branching-model/)
    - `git-hooks.nix`: [https://github.com/cachix/git-hooks.nix](https://github.com/cachix/git-hooks.nix)
    - keep a changelog: [https://keepachangelog.com/en/1.1.0/](https://keepachangelog.com/en/1.1.0/)
    - Lix: [https://lix.systems/](https://lix.systems/)
    - Nix Package Search: [https://search.nixos.org/packages](https://search.nixos.org/packages)
    - NixHub: [https://www.nixhub.io/](https://www.nixhub.io/)
    - `nix-direnv`: [https://github.com/nix-community/nix-direnv](https://github.com/nix-community/nix-direnv)
    - `nix-index`: [https://github.com/nix-community/nix-index](https://github.com/nix-community/nix-index)
    - `nix-versions`: [https://nix-versions.oeiuwq.com/](https://nix-versions.oeiuwq.com/)
    - prek: [https://prek.j178.dev/](https://prek.j178.dev/)
    - Renovate: [https://docs.renovatebot.com/](https://docs.renovatebot.com/)
    - REUSE: [https://reuse.software/](https://reuse.software/)
    - Semantic Versioning: [https://semver.org/](https://semver.org/)
    - SPDX-Spec: [https://spdx.github.io/spdx-spec/v3.0.1/](https://spdx.github.io/spdx-spec/v3.0.1/)
    - Taplo: [https://taplo.tamasfe.dev/](https://taplo.tamasfe.dev/)
    - `treefmt-nix`: [https://github.com/numtide/treefmt-nix](https://github.com/numtide/treefmt-nix)
    - Zed: [https://zed.dev/](https://zed.dev/)

## License

`nix-modules` is [MIT licensed](./LICENSE) and moderated under the [Contributor Covenant Code of Conduct](./.github/CODE_OF_CONDUCT.md).

# Simple Template

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-3.0-4BAAAA.svg?style=flat-square)](./.github/CODE_OF_CONDUCT.md)
[![prek](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/j178/prek/master/docs/assets/badge-v0.json)](https://github.com/j178/prek)
[![Built with Nix](https://img.shields.io/badge/NixOS-5277C3?style=for-the-badge&logo=nixos&logoColor=white)](https://github.com/NixOS/nixpkgs)

**This is a simple template to start Nix Flake projects from scratch.**

## What This Is

**Tell users about your project**

## Prerequisites

- **Check this README for any template content and replace it with your own**
- **[Choose a license](https://choosealicense.com/) and update the [LICENSE file](./LICENSE)**
- **Search for the following and replace the content accordingly:**
    - `SPDX-FileCopyrightText: NONE`
    - `SPDX-License-Identifier: NONE`
    - `SPDX-FileCopyrightText = 'NONE'`
    - `<GITHUB_HANDLE>`
    - `<PROJECT_DESCRIPTION>`
    - `<PROJECT_NAME>`
    - `'NONE'`
- **If you want to keep the Contributor Covenant, review the [Code of Conduct](./.github/CODE_OF_CONDUCT.md) and replace any template placeholders**
- **In order for the flake with the `dev` partition to work, a `flake.lock` is required in `nix/dev`. Run `cd nix/dev` followed by `nix flake lock` to create the lock file**
- **Remove all points in this list above and including this one**
- [Nix](https://nixos.org/download) with flakes enabled (or an alternative like from [Lix](https://lix.systems/))
- Optional: If the development shell shall be loaded into the current shell instead of replacing it: [`direnv`](https://direnv.net/) and [`nix-direnv`](https://github.com/nix-community/nix-direnv)

## Quick Start

**Tell users how to quickly get started with your project**

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

## Contributing

**Tell users, if you allow external contributions and how to do so**

## Links

- `<PROJECT_NAME>` repository: [https://github.com/<GITHUB_HANDLE>/<PROJECT_NAME>](https://github.com/<GITHUB_HANDLE>/<PROJECT_NAME>)
- Issue tracker: [https://github.com/<GITHUB_HANDLE>/<PROJECT_NAME>/issues](https://github.com/<GITHUB_HANDLE>/<PROJECT_NAME>/issues)
- More Links:
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
    - `nix-modules`: [https://github.com/robinwalterfit/nix-modules](https://github.com/robinwalterfit/nix-modules)
    - `nix-versions`: [https://nix-versions.oeiuwq.com/](https://nix-versions.oeiuwq.com/)
    - prek: [https://prek.j178.dev/](https://prek.j178.dev/)
    - REUSE: [https://reuse.software/](https://reuse.software/)
    - Semantic Versioning: [https://semver.org/](https://semver.org/)
    - SPDX-Spec: [https://spdx.github.io/spdx-spec/v3.0.1/](https://spdx.github.io/spdx-spec/v3.0.1/)
    - Taplo: [https://taplo.tamasfe.dev/](https://taplo.tamasfe.dev/)
    - `treefmt-nix`: [https://github.com/numtide/treefmt-nix](https://github.com/numtide/treefmt-nix)
    - Zed: [https://zed.dev/](https://zed.dev/)

## License

`<PROJECT_NAME>` is ['NONE' licensed](./LICENSE) and moderated under the [Contributor Covenant Code of Conduct](./.github/CODE_OF_CONDUCT.md).

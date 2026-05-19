# Contributing

First off, thank you for considering contributing to `nix-modules`! Everybody is invited and welcome to contribute to this project.

## General

Following these guidelines helps to communicate that you respect the time of the developer managing and developing this open source project. In return, he should reciprocate that respect in addressing your issue, assessing changes, and helping you finalize your pull requests.

There are many ways to contribute, from writing tutorials and blog posts, improving the (code) documentation, submitting bug reports and feature requests or writing source code which can be incorporated into `nix-modules` itself.

**NOTE**: Any changes made with the help of AI must be marked as such (e.g. source code comment, in your commit message, etc.).

## Ground rules

All activity is subject to the [Code of Conduct](./.github/CODE_OF_CONDUCT.md).

**Responsibilities**

- Create issues for any major changes and enhancements that you wish to make. Discuss things transparently and get feedback first.
- Be welcoming to newcomers and encourage diverse new contributors from all backgrounds.

## Your first contribution

At this point, you are ready to make your changes! Feel free to ask for help! Working on your first Pull Request? Maybe also checkout [https://www.firsttimersonly.com/](https://www.firsttimersonly.com/).

If the maintainer asks you to ["rebase"](https://git-scm.com/docs/git-rebase) your PR, he is saying that a lot of code has changed, and that you need to update your branch so it is easier to merge.

## Getting started

1. Create your own [fork of the code](https://github.com/robinwalterfit/nix-modules/fork)
2. Do the changes in your fork
    - Please do not push your changes directly to `main`
    - Create your own (feature) branch
3. If you like the change and think the project could use it:
    - Be sure you have followed the code and commit style for the project
    - Check that your work is signed-off (DCO; check also [https://developercertificate.org/](https://developercertificate.org/))
    - Send a Pull Request

## How to report a bug

**If you find a security vulnerability, do NOT open an issue. Email &lt;hello&#91;at&#93;robinwalter.me&gt; instead.**

When filing an issue, make sure to answer the following questions:

1. What operating system and processor architecture are you using?
2. What did you do?
3. What did you expect to see?
4. What did you see instead?

## How to suggest a feature or enhancement

Any kind of contributions are welcome. I created this project mainly for my own purposes, however, anything provided by this project might be useful for others as well, which is why I decided to open-source. Open an issue which describes the feature you would like to see, why you need it, and how it should work.

## Code review process

Please note, I am a single developer working on different projects in my free time. It may take some time until I respond and review any contributions. I will review any contributions and give feedback. If your changes are working for me, they'll be merged into the project.

## Code and commit message conventions

One main purpose of this project is to provide defaults for [`treefmt-nix`](https://github.com/numtide/treefmt-nix). These, however, are used by the project itself. Please ensure any contributions are formatted. The default development shell makes also use of [`git-hooks.nix`](https://github.com/cachix/git-hooks.nix) with [`prek`](https://prek.j178.dev/) to set up `git` hooks, which format code automatically.

Additionally, this project makes use of [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) and [Conventional Branch](https://conventional-branch.github.io/). There are additional `git` hooks which will lint the commit message using [Cocogitto](https://docs.cocogitto.io/) and the history before any `git push`. Cocogitto is installed into the default development shell, too. You might use Cocogitto to actually commit your changes. Refer to `cog commit --help` or the official documentation, if you want to learn more.

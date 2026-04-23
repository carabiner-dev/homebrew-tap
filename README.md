# Carabiner Homebrew Tap

Official Homebrew tap for the Carabiner Systems supply-chain tooling.

## Usage

```sh
brew tap carabiner-dev/tap
brew install bnd        # sigstore bundle + attestation toolkit
brew install ampel      # AMPEL policy engine
brew install unpack     # codebase / dependency extractor
brew install snappy     # HTTP snapshot attestation tool
brew install policyctl  # AMPEL policy manager
```

Once a formula is installed, upgrading to the latest release follows the
normal Homebrew flow:

```sh
brew update
brew upgrade bnd       # or any of the above
```

## Formulae

| Formula    | Source                                                                  | Latest stable |
|:-----------|:------------------------------------------------------------------------|:--------------|
| `ampel`    | [carabiner-dev/ampel](https://github.com/carabiner-dev/ampel)           | `v1.2.1`      |
| `bnd`      | [carabiner-dev/bnd](https://github.com/carabiner-dev/bnd)               | `v0.4.2`      |
| `policyctl`| [carabiner-dev/policyctl](https://github.com/carabiner-dev/policyctl)   | `v0.1.0`      |
| `snappy`   | [carabiner-dev/snappy](https://github.com/carabiner-dev/snappy)         | `v0.2.3`      |
| `unpack`   | [carabiner-dev/unpack](https://github.com/carabiner-dev/unpack)         | `v0.2.0`      |

All formulae build from source via the Homebrew-provided `go` toolchain and
install shell completions through the tool's Cobra `completion` subcommand.

## Contributing

Version bumps are driven from the source repos' release workflows (goreleaser
`brews:` blocks push a PR here on every new tag). Manual edits are welcome for
anything else — please run

```sh
brew audit --strict --online Formula/<name>.rb
brew install --build-from-source Formula/<name>.rb
brew test <name>
```

locally before opening a PR. The `brew-audit` workflow in `.github/workflows/`
runs the same checks on every PR.

## License

This repository is released under the Apache-2.0 license (see
[`LICENSE`](LICENSE)). Individual tools retain their own licenses — each is
Apache-2.0 as well.

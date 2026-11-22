<img src="docs/homebrew-carabiner.png" align="right" width="350" style="margin: 2em;">

# Carabiner Homebrew Tap

Official Homebrew tap for the Carabiner Systems supply-chain tooling.

<br><br><br><br>

## Usage

```sh
# Install the carabiner tap
brew tap carabiner-dev/tap

brew install bnd        # sigstore bundle + attestation toolkit
brew install ampel      # AMPEL policy engine
brew install unpack     # codebase / dependency extractor
brew install snappy     # HTTP snapshot attestation tool
brew install policyctl  # AMPEL policy manager
brew install drop       # secure-first installer for GitHub releases
```

Once a formula is installed, upgrading to the latest release follows the
normal Homebrew flow:

```sh
brew update
brew upgrade bnd       # or any of the above
```

## Formulae

| Formula    | Source                                                                  |
|:-----------|:------------------------------------------------------------------------|
| `ampel`    | [policylabs/ampel](https://github.com/policylabs/ampel)                 |
| `bnd`      | [carabiner-dev/bnd](https://github.com/carabiner-dev/bnd)               |
| `drop`     | [carabiner-dev/drop](https://github.com/carabiner-dev/drop)             |
| `policyctl`| [carabiner-dev/policyctl](https://github.com/carabiner-dev/policyctl)   |
| `snappy`   | [carabiner-dev/snappy](https://github.com/carabiner-dev/snappy)         |
| `unpack`   | [carabiner-dev/unpack](https://github.com/carabiner-dev/unpack)         |

## How installs are verified

The formulae install the binaries published in each project's GitHub release
instead of compiling them. Nothing is installed on trust:

1. **`drop` is the bootstrap.** Its formula pins the sha256 of the release
   binary of every platform, and Homebrew checks the download against it
   before anything runs. The hashes are written by
   [`hack/update-drop.sh`](hack/update-drop.sh), which fetches each binary
   with an already installed drop, so a release only gets pinned after its
   SLSA provenance passed
   [drop's release policy](https://github.com/carabiner-dev/.github/blob/main/ampel/policies/release/drop/drop-release.hjson).

2. **Every other formula downloads its binary with `drop`**, which is pulled
   in as a build dependency. drop writes the binary only after its SLSA
   provenance attestation passes the tool's release policy, which drop reads
   from the community policy repository,
   [policylabs/oss](https://github.com/policylabs/oss) (under
   `policies/<org>/<repo>/release/`). Each policy admits
   only provenance signed (sigstore keyless) by the release workflow of the
   tool's repository on a version tag, and then checks the builder, build type
   and source repository with the community SLSA policies from
   [carabiner-dev/policies](https://github.com/carabiner-dev/policies),
   pinned by commit. A binary that fails is never written to disk and the
   install aborts.

The shared logic is in [`lib/drop_install.rb`](lib/drop_install.rb).

drop reads the release and its attestations through the GitHub API. If you hit
the anonymous rate limit, set `HOMEBREW_GITHUB_API_TOKEN`.

Two cases still build from source with the Homebrew-provided `go` toolchain:
`--HEAD` installs, and Intel macs, as the projects publish no `darwin/amd64`
binaries.

## Contributing

Version bumps of the tools are opened as PRs by the release automation, which
updates the source tarball `url` and `sha256` of the formula (the version drop
downloads is taken from it). `drop` is bumped by the same automation, which
runs

```sh
hack/update-drop.sh v1.2.3
```

with the drop release the tap currently pins, so every new drop is verified
by its predecessor before its hashes are written.

For manual edits, please run

```sh
brew style Formula
brew audit --strict --online carabiner-dev/tap/<name>
brew install carabiner-dev/tap/<name>
brew test carabiner-dev/tap/<name>
```

locally before opening a PR. The `brew-audit` workflow in `.github/workflows/`
runs the same checks on every PR.

## License

This repository is released under the Apache-2.0 license (see
[`LICENSE`](LICENSE)). Individual tools retain their own licenses — each is
Apache-2.0 as well.

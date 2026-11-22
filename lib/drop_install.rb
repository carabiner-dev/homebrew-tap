# typed: false
# frozen_string_literal: true

# Shared install logic for the formulae in this tap.
#
# Instead of compiling each tool, the formulae download the binary published
# in the tool's GitHub release with drop (https://github.com/carabiner-dev/drop).
# drop only writes the binary to disk after verifying its SLSA provenance
# attestation against the project's release policy. drop looks the policy up
# itself: in the .github repository of the project's organization first, then
# in the community repository, https://github.com/policylabs/oss, under
# policies/<org>/<repo>/release/. Those policies pin the signer of the
# provenance to the tool's release workflow and reuse the SLSA policies from
# https://github.com/carabiner-dev/policies.
#
# drop itself cannot be installed this way: its formula pins the sha256 of
# the release binaries, which Homebrew checks before anything is run.
#
# HEAD installs, and platforms the projects publish no binaries for (Intel
# macs), still build from source.
module DropInstall
  # Whether a release binary can be downloaded for this install.
  def prebuilt_binary?
    return false if build.head?

    !(OS.mac? && Hardware::CPU.intel?)
  end

  # Installs the tool's binary: downloaded and verified with drop when a
  # prebuilt one exists, compiled from the formula's sources otherwise.
  #
  # repo is the org/repo slug of the GitHub repository publishing the
  # releases, go_package the main package built in the source fallback.
  def install_release(repo, go_package: ".")
    if prebuilt_binary?
      drop_install(repo)
    else
      ldflags = "-s -w -X sigs.k8s.io/release-utils/version.gitVersion=v#{version}"
      system "go", "build", *std_go_args(ldflags: ldflags), go_package
    end
    generate_completions_from_executable(bin/name, "completion")
  end

  # Downloads the release binary of the formula's version with drop, which
  # verifies it before writing it, and installs it.
  def drop_install(repo)
    # Homebrew scrubs the environment of the build, but keeps its own
    # token. Lend it to drop to avoid the anonymous GitHub API rate limit.
    token = ENV.fetch("HOMEBREW_GITHUB_API_TOKEN", nil)
    ENV["GITHUB_TOKEN"] = token if token.present?

    download = buildpath/"drop-download"
    system "drop", "get", "#{repo}@v#{version}", "--directory", download
    chmod 0755, download/name
    bin.install download/name
  end
end

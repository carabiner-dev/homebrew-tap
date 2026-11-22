# typed: false
# frozen_string_literal: true

# drop is the bootstrap of this tap: the other formulae use it to download
# and verify their binaries, so it cannot verify itself. Its release binaries
# are pinned here by sha256 instead, which Homebrew checks before installing
# them. The hashes are written by hack/update-drop.sh, which only takes them
# from binaries that passed drop's own release policy.
class Drop < Formula
  desc "Secure-first installer for GitHub releases, verified with AMPEL policies"
  homepage "https://github.com/carabiner-dev/drop"
  license "Apache-2.0"

  head do
    url "https://github.com/carabiner-dev/drop.git", branch: "main"

    depends_on "go" => :build
  end

  on_macos do
    on_arm do
      url "https://github.com/carabiner-dev/drop/releases/download/v0.2.1/drop-v0.2.1-darwin-arm64"
      sha256 "4f69d41578d4d8778d1c63d29902f907c06233dbe7699fce0028775ccfe92c4d"
    end

    # No darwin/amd64 binary is published, Intel macs build from source.
    on_intel do
      url "https://github.com/carabiner-dev/drop/archive/refs/tags/v0.2.1.tar.gz"
      sha256 "4fa314f537b640bdbf635e785d5ac98e0aeb5da76900c533e415e0d0d9559824"

      depends_on "go" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/carabiner-dev/drop/releases/download/v0.2.1/drop-v0.2.1-linux-arm64"
      sha256 "9cdb67d640798f56295047804f79d19251816943caf2a9a69cee16b5b35107a2"
    end

    on_intel do
      url "https://github.com/carabiner-dev/drop/releases/download/v0.2.1/drop-v0.2.1-linux-amd64"
      sha256 "946a430fca781dd3062a93e9fb7bf93e827e4e39d3a632eec7b5ec2ebde91cf8"
    end
  end

  def install
    if build.head? || (OS.mac? && Hardware::CPU.intel?)
      ldflags = "-s -w -X sigs.k8s.io/release-utils/version.gitVersion=v#{version}"
      system "go", "build", *std_go_args(ldflags: ldflags)
    else
      # The download is the bare binary, named after its tag and platform.
      # It comes without the executable bit.
      binary = Dir["drop-v*"].first
      chmod 0755, binary
      bin.install binary => "drop"
    end
    generate_completions_from_executable(bin/"drop", "completion")
  end

  test do
    assert_match "drop", shell_output("#{bin}/drop --help")
  end
end

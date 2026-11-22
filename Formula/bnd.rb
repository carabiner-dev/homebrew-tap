# typed: false
# frozen_string_literal: true

require_relative "../lib/drop_install"

class Bnd < Formula
  include DropInstall

  desc "Utility to work with sigstore bundles and in-toto attestations"
  homepage "https://github.com/carabiner-dev/bnd"
  url "https://github.com/carabiner-dev/bnd/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "ae3d991cae3e098d4e8d9b5eb5ac03b10bc8d27138f5074f7061c1aa1f3f04ba"
  license "Apache-2.0"

  head do
    url "https://github.com/carabiner-dev/bnd.git", branch: "main"

    depends_on "go" => :build
  end

  depends_on "carabiner-dev/tap/drop" => :build

  # No darwin/amd64 binaries are published, Intel macs build from source.
  on_macos do
    on_intel do
      depends_on "go" => :build
    end
  end

  def install
    install_release "carabiner-dev/bnd"
  end

  test do
    assert_match "bnd", shell_output("#{bin}/bnd --help")
  end
end

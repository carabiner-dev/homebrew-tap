# typed: false
# frozen_string_literal: true

require_relative "../lib/drop_install"

class Ampel < Formula
  include DropInstall

  desc "Amazing Multipurpose Policy Engine for supply-chain attestations"
  homepage "https://github.com/carabiner-dev/ampel"
  url "https://github.com/carabiner-dev/ampel/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "29cf9aa0d4d752d2f690886965587d8de470a9e96e7e0ec4bb98e0c69fa2691c"
  license "Apache-2.0"

  head do
    url "https://github.com/carabiner-dev/ampel.git", branch: "main"

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
    install_release "policylabs/ampel", go_package: "./cmd/ampel"
  end

  test do
    assert_match "ampel", shell_output("#{bin}/ampel --help")
  end
end

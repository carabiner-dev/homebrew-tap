# typed: false
# frozen_string_literal: true

require_relative "../lib/drop_install"

class Snappy < Formula
  include DropInstall

  desc "Take snapshots of HTTP API responses and attest them as evidence"
  homepage "https://github.com/carabiner-dev/snappy"
  url "https://github.com/carabiner-dev/snappy/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "ac0dfbbf4e65ab88ab73bb019d74870342d2512089de5902deb0a76dcf0b36a2"
  license "Apache-2.0"

  head do
    url "https://github.com/carabiner-dev/snappy.git", branch: "main"

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
    install_release "carabiner-dev/snappy"
  end

  test do
    assert_match "snappy", shell_output("#{bin}/snappy --help")
  end
end

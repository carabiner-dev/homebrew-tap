# typed: false
# frozen_string_literal: true

require_relative "../lib/drop_install"

class Unpack < Formula
  include DropInstall

  desc "Discover codebases and extract dependencies from a project directory"
  homepage "https://github.com/carabiner-dev/unpack"
  url "https://github.com/carabiner-dev/unpack/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "96f355ee52654a3a39d55b1e81c01263fe8c91c0fc46cd0fcfb93f328dc9f173"
  license "Apache-2.0"

  head do
    url "https://github.com/carabiner-dev/unpack.git", branch: "main"

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
    install_release "carabiner-dev/unpack"
  end

  test do
    assert_match "unpack", shell_output("#{bin}/unpack --help")
  end
end

# typed: false
# frozen_string_literal: true

require_relative "../lib/drop_install"

class Policyctl < Formula
  include DropInstall

  desc "Tool to manage AMPEL policies"
  homepage "https://github.com/carabiner-dev/policyctl"
  url "https://github.com/carabiner-dev/policyctl/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "8489a4b30c76280465a1a3c1cdff5c1b8daa7689b18c52a04dcecf8bf1b6586f"
  license "Apache-2.0"

  head do
    url "https://github.com/carabiner-dev/policyctl.git", branch: "main"

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
    install_release "carabiner-dev/policyctl"
  end

  test do
    assert_match "policyctl", shell_output("#{bin}/policyctl --help")
  end
end

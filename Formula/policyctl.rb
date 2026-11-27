# typed: false
# frozen_string_literal: true

require_relative "../lib/drop_install"

class Policyctl < Formula
  include DropInstall

  desc "Tool to manage AMPEL policies"
  homepage "https://github.com/carabiner-dev/policyctl"
  url "https://github.com/carabiner-dev/policyctl/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "bcf7405cc69086511c40bccedb84d0c958358ef8f0cd34148d1204d9f3e48145"
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

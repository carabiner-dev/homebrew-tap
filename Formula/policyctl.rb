# typed: false
# frozen_string_literal: true

class Policyctl < Formula
  desc "Tool to manage AMPEL policies"
  homepage "https://github.com/carabiner-dev/policyctl"
  url "https://github.com/carabiner-dev/policyctl/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "8489a4b30c76280465a1a3c1cdff5c1b8daa7689b18c52a04dcecf8bf1b6586f"
  license "Apache-2.0"
  head "https://github.com/carabiner-dev/policyctl.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X sigs.k8s.io/release-utils/version.gitVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin/"policyctl", "completion")
  end

  test do
    assert_match "policyctl", shell_output("#{bin}/policyctl --help")
  end
end

# typed: false
# frozen_string_literal: true

class Policyctl < Formula
  desc "Tool to manage AMPEL policies"
  homepage "https://github.com/carabiner-dev/policyctl"
  url "https://github.com/carabiner-dev/policyctl/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1cf8ca34e12c2a208d9865dda284764de88ca58aa0c1d86637b548975c558849"
  license "Apache-2.0"
  head "https://github.com/carabiner-dev/policyctl.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"policyctl", "completion")
  end

  test do
    assert_match "policyctl", shell_output("#{bin}/policyctl --help")
  end
end

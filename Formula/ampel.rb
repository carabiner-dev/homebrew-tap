# typed: false
# frozen_string_literal: true

class Ampel < Formula
  desc "Amazing Multipurpose Policy Engine for supply-chain attestations"
  homepage "https://github.com/carabiner-dev/ampel"
  url "https://github.com/carabiner-dev/ampel/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "382f6f7cbaa741a595e030f66aa79b53667fd74ff41f56221adcab59e6deb2a3"
  license "Apache-2.0"
  head "https://github.com/carabiner-dev/ampel.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ampel"
    generate_completions_from_executable(bin/"ampel", "completion")
  end

  test do
    assert_match "ampel", shell_output("#{bin}/ampel --help")
  end
end

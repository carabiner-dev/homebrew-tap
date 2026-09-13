# typed: false
# frozen_string_literal: true

class Ampel < Formula
  desc "Amazing Multipurpose Policy Engine for supply-chain attestations"
  homepage "https://github.com/carabiner-dev/ampel"
  url "https://github.com/carabiner-dev/ampel/archive/refs/tags/v1.3.10.tar.gz"
  sha256 "89bf0161ff5ce68d3eed111f90298c5a98011e76b4bb4314511ebec3983b2527"
  license "Apache-2.0"
  head "https://github.com/carabiner-dev/ampel.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X sigs.k8s.io/release-utils/version.gitVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ampel"
    generate_completions_from_executable(bin/"ampel", "completion")
  end

  test do
    assert_match "ampel", shell_output("#{bin}/ampel --help")
  end
end

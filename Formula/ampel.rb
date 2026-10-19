# typed: false
# frozen_string_literal: true

class Ampel < Formula
  desc "Amazing Multipurpose Policy Engine for supply-chain attestations"
  homepage "https://github.com/carabiner-dev/ampel"
  url "https://github.com/carabiner-dev/ampel/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "ba76bc2c8ae6aa2da64252cc762cbd52f9a908cacb8c317396ec38dfd2525fc3"
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

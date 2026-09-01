# typed: false
# frozen_string_literal: true

class Ampel < Formula
  desc "Amazing Multipurpose Policy Engine for supply-chain attestations"
  homepage "https://github.com/carabiner-dev/ampel"
  url "https://github.com/carabiner-dev/ampel/archive/refs/tags/v1.3.7.tar.gz"
  sha256 "3b78b3300983e937a4837c5132bfd6a9a26895d51ad5cded8e518f59aa83d54d"
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

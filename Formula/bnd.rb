# typed: false
# frozen_string_literal: true

class Bnd < Formula
  desc "Utility to work with sigstore bundles and in-toto attestations"
  homepage "https://github.com/carabiner-dev/bnd"
  url "https://github.com/carabiner-dev/bnd/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "a76c83177a8f50154387a06e66bf496f68246791e6353f1dc975f936844bb1eb"
  license "Apache-2.0"
  head "https://github.com/carabiner-dev/bnd.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X sigs.k8s.io/release-utils/version.gitVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin/"bnd", "completion")
  end

  test do
    assert_match "bnd", shell_output("#{bin}/bnd --help")
  end
end

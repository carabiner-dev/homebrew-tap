# typed: false
# frozen_string_literal: true

class Bnd < Formula
  desc "Utility to work with sigstore bundles and in-toto attestations"
  homepage "https://github.com/carabiner-dev/bnd"
  url "https://github.com/carabiner-dev/bnd/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "ae3d991cae3e098d4e8d9b5eb5ac03b10bc8d27138f5074f7061c1aa1f3f04ba"
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

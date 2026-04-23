# typed: false
# frozen_string_literal: true

class Bnd < Formula
  desc "Utility to work with sigstore bundles and in-toto attestations"
  homepage "https://github.com/carabiner-dev/bnd"
  url "https://github.com/carabiner-dev/bnd/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "f32c7120066ad8238110c7f42a7e8047f32101de849992e12650fe473ee4f177"
  license "Apache-2.0"
  head "https://github.com/carabiner-dev/bnd.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"bnd", "completion")
  end

  test do
    assert_match "bnd", shell_output("#{bin}/bnd --help")
  end
end

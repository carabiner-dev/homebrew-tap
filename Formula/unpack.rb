# typed: false
# frozen_string_literal: true

class Unpack < Formula
  desc "Discover codebases and extract dependencies from a project directory"
  homepage "https://github.com/carabiner-dev/unpack"
  url "https://github.com/carabiner-dev/unpack/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "86d07dd0df6164c80ffe4fb65415aff813b2b1bdc5d259bafa179ccff59105ae"
  license "Apache-2.0"
  head "https://github.com/carabiner-dev/unpack.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X sigs.k8s.io/release-utils/version.gitVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin/"unpack", "completion")
  end

  test do
    assert_match "unpack", shell_output("#{bin}/unpack --help")
  end
end

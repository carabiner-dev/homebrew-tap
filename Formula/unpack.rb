# typed: false
# frozen_string_literal: true

class Unpack < Formula
  desc "Discover codebases and extract dependencies from a project directory"
  homepage "https://github.com/carabiner-dev/unpack"
  url "https://github.com/carabiner-dev/unpack/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "b285ef7cc749b4e03956f179e17e72cca34fb3422f88eed30b9b97fc00fe6119"
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

# typed: false
# frozen_string_literal: true

class Unpack < Formula
  desc "Discover codebases and extract dependencies from a project directory"
  homepage "https://github.com/carabiner-dev/unpack"
  url "https://github.com/carabiner-dev/unpack/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "7565cc712b7785eb69af7e85f5314bec28ed954cd9489a56ff1b9fb816759ab8"
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

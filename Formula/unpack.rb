# typed: false
# frozen_string_literal: true

class Unpack < Formula
  desc "Discover codebases and extract dependencies from a project directory"
  homepage "https://github.com/carabiner-dev/unpack"
  url "https://github.com/carabiner-dev/unpack/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "8b9276e7f6428c4ea7eca6436808ccdd6fc1c9327601d6c9ff9cc5c70c2a7522"
  license "Apache-2.0"
  head "https://github.com/carabiner-dev/unpack.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"unpack", "completion")
  end

  test do
    assert_match "unpack", shell_output("#{bin}/unpack --help")
  end
end

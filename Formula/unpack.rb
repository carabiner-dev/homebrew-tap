# typed: false
# frozen_string_literal: true

class Unpack < Formula
  desc "Discover codebases and extract dependencies from a project directory"
  homepage "https://github.com/carabiner-dev/unpack"
  url "https://github.com/carabiner-dev/unpack/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "d8e4502c36f3003fae9c4e84d24c179aa7b244b3f4b6ff98b427ee16c85ba468"
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

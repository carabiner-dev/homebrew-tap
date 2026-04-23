# typed: false
# frozen_string_literal: true

class Snappy < Formula
  desc "Take snapshots of HTTP API responses and attest them as evidence"
  homepage "https://github.com/carabiner-dev/snappy"
  url "https://github.com/carabiner-dev/snappy/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "a42d6bfa892017c2e7385e01039dac7abfc0e4e8d8e28c533dcf70c875efc368"
  license "Apache-2.0"
  head "https://github.com/carabiner-dev/snappy.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"snappy", "completion")
  end

  test do
    assert_match "snappy", shell_output("#{bin}/snappy --help")
  end
end

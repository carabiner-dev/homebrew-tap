# typed: false
# frozen_string_literal: true

class Snappy < Formula
  desc "Take snapshots of HTTP API responses and attest them as evidence"
  homepage "https://github.com/carabiner-dev/snappy"
  url "https://github.com/carabiner-dev/snappy/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "ac0dfbbf4e65ab88ab73bb019d74870342d2512089de5902deb0a76dcf0b36a2"
  license "Apache-2.0"
  head "https://github.com/carabiner-dev/snappy.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X sigs.k8s.io/release-utils/version.gitVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin/"snappy", "completion")
  end

  test do
    assert_match "snappy", shell_output("#{bin}/snappy --help")
  end
end

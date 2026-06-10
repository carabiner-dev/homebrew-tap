# typed: false
# frozen_string_literal: true

class Ampel < Formula
  desc "Amazing Multipurpose Policy Engine for supply-chain attestations"
  homepage "https://github.com/carabiner-dev/ampel"
  url "https://github.com/carabiner-dev/ampel/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "32cffb2f1dbac42bc1df5cb5a9bce05781fea6b3902acd479d7ed8071accf08c"
  license "Apache-2.0"
  head "https://github.com/carabiner-dev/ampel.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ampel"
    generate_completions_from_executable(bin/"ampel", "completion")
  end

  test do
    assert_match "ampel", shell_output("#{bin}/ampel --help")
  end
end

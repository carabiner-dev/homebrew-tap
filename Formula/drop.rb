# typed: false
# frozen_string_literal: true

class Drop < Formula
  desc "Secure-first installer for GitHub releases, verified with AMPEL policies"
  homepage "https://github.com/carabiner-dev/drop"
  url "https://github.com/carabiner-dev/drop/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "101bbb139310e115f6e25be6f0f78fd2f4ee3e81273ec56c227418cfac3264bb"
  license "Apache-2.0"
  head "https://github.com/carabiner-dev/drop.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X sigs.k8s.io/release-utils/version.gitVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin/"drop", "completion")
  end

  test do
    assert_match "drop", shell_output("#{bin}/drop --help")
  end
end

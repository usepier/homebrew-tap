class Pier < Formula
  desc "Give every agent session its own VM. One command up, zero burn when idle"
  homepage "https://github.com/usepier/pier"
  url "https://github.com/usepier/pier/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "94dcc46a02052796606c1ec4fb20ac67b8601e7c421832e537da0e9cf5a3a90a"
  license "MIT"
  head "https://github.com/usepier/pier.git", branch: "main"

  depends_on "go" => :build

  def install
    # make cross-compiles the in-VM supervisors and embeds them into the CLI;
    # the tarball has no .git, so the version is passed in
    system "make", "build", "VERSION=v#{version}"
    bin.install "pier"
    pkgshare.install "skills"
    doc.install "README.md"
  end

  def caveats
    <<~EOS
      pier drives your own AWS or GCP account through that cloud's CLI,
      which it needs on PATH:

        brew install awscli
        brew install --cask session-manager-plugin

      or:

        brew install --cask gcloud-cli

      Then run once:

        pier setup

      The pier-onboard skill ships with the formula. To let your coding
      agent write your repo's pier files:

        cp -r "#{opt_pkgshare}/skills/pier-onboard" ~/.claude/skills/
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pier version")
  end
end

class LeafMarkdownViewer < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_intel do
      url "https://github.com/RivoLink/leaf/releases/download/1.29.3/leaf-macos-x86_64"
      sha256 "099deac16041bcc4174d7b5198f5ccd1b8505f72ef597afcbc9c15fae6ac20e7"
    end
    on_arm do
      url "https://github.com/RivoLink/leaf/releases/download/1.29.3/leaf-macos-arm64"
      sha256 "6df7dfa70a97315cff02b20cbec3edd4f40ea2188d02ee02948212bff52ae1af"
    end
  end

  conflicts_with "leaf", because: "both install `leaf` binaries"
  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  def install
    binary = Dir["leaf-macos-*"].first
    bin.install binary => "leaf"
    (bin/"leaf").chmod 0755
  end

  test do
    (testpath/"test.md").write "# Hello\n\nThis is a **test**."
    output = shell_output("#{bin}/leaf --inline test.md")
    assert_match "Hello", output
  end
end

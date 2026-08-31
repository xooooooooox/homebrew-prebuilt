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
      url "https://github.com/RivoLink/leaf/releases/download/1.28.1/leaf-macos-x86_64"
      sha256 "ca2b34a304c73a9f9bc71ddbf1056388c8334b064db24f37076c45a33fa37ccd"
    end
    on_arm do
      url "https://github.com/RivoLink/leaf/releases/download/1.28.1/leaf-macos-arm64"
      sha256 "90b1906d670c580b1552d5701226b09d9e5d608b1341acf6ec921f44830d3015"
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

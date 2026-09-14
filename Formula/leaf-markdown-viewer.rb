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
      url "https://github.com/RivoLink/leaf/releases/download/1.28.2/leaf-macos-x86_64"
      sha256 "357e28c2d9cab67d2ea4c0232f5afd43835981536e16dbd57fc2646f45509a03"
    end
    on_arm do
      url "https://github.com/RivoLink/leaf/releases/download/1.28.2/leaf-macos-arm64"
      sha256 "db409c712c608e4783073ff12ea6a5417bffd20360b03d7450f0f5bb863aa825"
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

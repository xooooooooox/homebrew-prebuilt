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
      url "https://github.com/RivoLink/leaf/releases/download/1.28.3/leaf-macos-x86_64"
      sha256 "a8737b38b5618561a203c846b23aed20c18984b017bb61adbbcab8518d8267d4"
    end
    on_arm do
      url "https://github.com/RivoLink/leaf/releases/download/1.28.3/leaf-macos-arm64"
      sha256 "dc54bcc39e73f99853f051389481db7396fec95eff69f85db8878518a3fe13df"
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

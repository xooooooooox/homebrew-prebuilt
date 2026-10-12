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
      url "https://github.com/RivoLink/leaf/releases/download/1.29.0/leaf-macos-x86_64"
      sha256 "1f310921d666e0e7a6be9f04143be0ef8bed11b9126592fb65d058630d431bf6"
    end
    on_arm do
      url "https://github.com/RivoLink/leaf/releases/download/1.29.0/leaf-macos-arm64"
      sha256 "a04c5428a207b765d36b6164464671c8b90fefb097e1bb182c23ae6faa0480f3"
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

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
      url "https://github.com/RivoLink/leaf/releases/download/1.28.0/leaf-macos-x86_64"
      sha256 "c17a5ca4acb44feb2efc221bff933de2bc32cd2bd2cacb7f5976d96cf4063e64"
    end
    on_arm do
      url "https://github.com/RivoLink/leaf/releases/download/1.28.0/leaf-macos-arm64"
      sha256 "00039126a37a4b20a3ad56d60e207df8acd09369240de2a2d21f83447b7b42de"
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

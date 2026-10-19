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
      url "https://github.com/RivoLink/leaf/releases/download/1.29.1/leaf-macos-x86_64"
      sha256 "2058732e1e874e3473a2eabb7c425eaa288fba1359ca8db1472f7136d4eb1c62"
    end
    on_arm do
      url "https://github.com/RivoLink/leaf/releases/download/1.29.1/leaf-macos-arm64"
      sha256 "c35a30d42600cc9574b44a39ed71fcf382f8513bf58ceb6cd11b9980b49f130c"
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

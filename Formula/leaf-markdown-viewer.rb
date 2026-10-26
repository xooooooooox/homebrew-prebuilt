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
      url "https://github.com/RivoLink/leaf/releases/download/1.29.2/leaf-macos-x86_64"
      sha256 "8be1a6141bcfef50a7a5dfaff416ad7e9896aed860b113a05397f7c756fc8dbd"
    end
    on_arm do
      url "https://github.com/RivoLink/leaf/releases/download/1.29.2/leaf-macos-arm64"
      sha256 "940b0fcbb57e8fafab0c2ae8a19cee6cefede1e61f72a76a2d93553ae503d85a"
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

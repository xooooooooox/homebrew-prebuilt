class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_intel do
      url "https://github.com/version-fox/vfox/releases/download/v1.0.12/vfox_1.0.12_macos_x86_64.tar.gz"
      sha256 "3577c62c2f681089092d715f4e5021680de32452ca2540078803545f661b9550"
    end
    on_arm do
      url "https://github.com/version-fox/vfox/releases/download/v1.0.12/vfox_1.0.12_macos_aarch64.tar.gz"
      sha256 "aab23403d465806ba532d3b7b882cba3b3685a8d995e6ec888518515ee623f7f"
    end
  end

  def install
    bin.install "vfox"
    bash_completion.install "completions/bash_autocomplete" => "vfox"
    zsh_completion.install "completions/zsh_autocomplete" => "_vfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfox --version")
  end
end

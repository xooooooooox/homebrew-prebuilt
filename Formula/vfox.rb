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
      url "https://github.com/version-fox/vfox/releases/download/v1.0.13/vfox_1.0.13_macos_x86_64.tar.gz"
      sha256 "5327b4ebbca9d9be49454251d5dd44842b8657e218864bf83421cb65b9bf6b18"
    end
    on_arm do
      url "https://github.com/version-fox/vfox/releases/download/v1.0.13/vfox_1.0.13_macos_aarch64.tar.gz"
      sha256 "9f040c5b2cef37c0ce4fb772e552b52be0ed1bcd9b63d2c6aaf4d59f5cc99a05"
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

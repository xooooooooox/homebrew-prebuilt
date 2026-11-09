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
      url "https://github.com/version-fox/vfox/releases/download/v1.1.0/vfox_1.1.0_macos_x86_64.tar.gz"
      sha256 "ac4bcda2224a0f8aedf35e3ae22454dc97cf79b69899f43ef6519255a0feb7f6"
    end
    on_arm do
      url "https://github.com/version-fox/vfox/releases/download/v1.1.0/vfox_1.1.0_macos_aarch64.tar.gz"
      sha256 "9beb733ad636966c6d410c768407c63ffb350106eb23a8151d6fc80b9e84248e"
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

class Armv7UnknownLinuxMusleabihf < Formula
  desc "armv7-unknown-linux-musleabihf Toolchain"
  homepage "https://github.com/leostera/homebrew-macos-cross-toolchains"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  version "13.4.0"

  depends_on "bdw-gc"
  depends_on "guile"
  depends_on "zstd"
  depends_on "python@3.12"

  url "https://github.com/leostera/homebrew-macos-cross-toolchains/releases/download/v13.4.0/armv7-unknown-linux-musleabihf-aarch64-darwin.tar.gz"
  sha256 "a0676c8d61f008174480bef560e4643787d8e37676fe6b176ee1e3feebda2a31"

  def install
    (prefix/"toolchain").install Dir["./*"]
    Dir.glob(prefix/"toolchain/bin/*") {|file| bin.install_symlink file}
  end
end

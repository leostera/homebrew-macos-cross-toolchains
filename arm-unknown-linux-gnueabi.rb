class ArmUnknownLinuxGnueabi < Formula
  desc "arm-unknown-linux-gnueabi Toolchain"
  homepage "https://github.com/leostera/homebrew-macos-cross-toolchains"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  version "13.4.0"

  depends_on "bdw-gc"
  depends_on "guile"
  depends_on "zstd"
  depends_on "python@3.12"

  url "https://github.com/leostera/homebrew-macos-cross-toolchains/releases/download/v13.4.0/arm-unknown-linux-gnueabi-aarch64-darwin.tar.gz"
  sha256 "e925f58cfc404b1ec4d1fdb068591795131a1a6bce4f36a5edf943afc6fa360a"

  def install
    (prefix/"toolchain").install Dir["./*"]
    Dir.glob(prefix/"toolchain/bin/*") {|file| bin.install_symlink file}
  end
end

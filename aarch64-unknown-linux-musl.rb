class Aarch64UnknownLinuxMusl < Formula
  desc "aarch64-unknown-linux-musl Toolchain"
  homepage "https://github.com/leostera/homebrew-macos-cross-toolchains"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  version "13.4.0"

  depends_on "bdw-gc"
  depends_on "guile"
  depends_on "zstd"
  depends_on "python@3.12"

  url "https://github.com/leostera/homebrew-macos-cross-toolchains/releases/download/v13.4.0/aarch64-unknown-linux-musl-aarch64-darwin.tar.gz"
  sha256 "732fa0e14cf2f189e9a56bb605a70eb22069fcfd7ef8d0acb9a676cf3f9e0c7b"

  def install
    (prefix/"toolchain").install Dir["./*"]
    Dir.glob(prefix/"toolchain/bin/*") {|file| bin.install_symlink file}
  end
end

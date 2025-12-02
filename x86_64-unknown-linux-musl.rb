class X8664UnknownLinuxMusl < Formula
  desc "x86_64-unknown-linux-musl Toolchain"
  homepage "https://github.com/leostera/homebrew-macos-cross-toolchains"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  version "13.4.0"

  depends_on "bdw-gc"
  depends_on "guile"
  depends_on "zstd"
  depends_on "python@3.12"

  url "https://github.com/leostera/homebrew-macos-cross-toolchains/releases/download/v13.4.0/x86_64-unknown-linux-musl-aarch64-darwin.tar.gz"
  sha256 "ad1950b0a369e4ae1a74103a5ca4adeb7dbd34b1fad3ab7f24f6bedb46a6c1f1"

  def install
    (prefix/"toolchain").install Dir["./*"]
    Dir.glob(prefix/"toolchain/bin/*") {|file| bin.install_symlink file}
  end
end

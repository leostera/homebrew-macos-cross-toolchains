class I686UnknownLinuxMusl < Formula
  desc "i686-unknown-linux-musl Toolchain"
  homepage "https://github.com/leostera/homebrew-macos-cross-toolchains"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  version "13.4.0"

  depends_on "bdw-gc"
  depends_on "guile"
  depends_on "zstd"
  depends_on "python@3.12"

  url "https://github.com/leostera/homebrew-macos-cross-toolchains/releases/download/v13.4.0/i686-unknown-linux-musl-aarch64-darwin.tar.gz"
  sha256 "2920c0218a8c3f091de15e24f5c07eff9bd14c49590d6517a6f52c505da4a1d1"

  def install
    (prefix/"toolchain").install Dir["./*"]
    Dir.glob(prefix/"toolchain/bin/*") {|file| bin.install_symlink file}
  end
end

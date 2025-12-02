class I686UnknownLinuxGnu < Formula
  desc "i686-unknown-linux-gnu Toolchain"
  homepage "https://github.com/leostera/homebrew-macos-cross-toolchains"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  version "13.4.0"

  depends_on "bdw-gc"
  depends_on "guile"
  depends_on "zstd"
  depends_on "python@3.12"

  url "https://github.com/leostera/homebrew-macos-cross-toolchains/releases/download/v13.4.0/i686-unknown-linux-gnu-aarch64-darwin.tar.gz"
  sha256 "ca2025c585a7dad0fc77cea5d7963a1e90a3e3050d387c8c31431c775e1017a6"

  def install
    (prefix/"toolchain").install Dir["./*"]
    Dir.glob(prefix/"toolchain/bin/*") {|file| bin.install_symlink file}
  end
end

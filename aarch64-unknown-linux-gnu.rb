class Aarch64UnknownLinuxGnu < Formula
  desc "aarch64-unknown-linux-gnu Toolchain"
  homepage "https://github.com/leostera/homebrew-macos-cross-toolchains"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  version "13.4.0"

  depends_on "bdw-gc"
  depends_on "guile"
  depends_on "zstd"
  depends_on "python@3.12"

  url "https://github.com/leostera/homebrew-macos-cross-toolchains/releases/download/v13.4.0/aarch64-unknown-linux-gnu-aarch64-darwin.tar.gz"
  sha256 "9716a73c240d6750defb238d7426ddce9af84ef171bc8cd732062bfdd00d9d1b"

  def install
    (prefix/"toolchain").install Dir["./*"]
    Dir.glob(prefix/"toolchain/bin/*") {|file| bin.install_symlink file}
  end
end

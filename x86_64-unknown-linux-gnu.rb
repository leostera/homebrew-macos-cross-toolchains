class X8664UnknownLinuxGnu < Formula
  desc "x86_64-unknown-linux-gnu Toolchain"
  homepage "https://github.com/leostera/homebrew-macos-cross-toolchains"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  version "13.4.0"

  depends_on "bdw-gc"
  depends_on "guile"
  depends_on "zstd"
  depends_on "python@3.12"

  url "https://github.com/leostera/homebrew-macos-cross-toolchains/releases/download/v13.4.0/x86_64-unknown-linux-gnu-aarch64-darwin.tar.gz"
  sha256 "e20fcc1d11c7455c2575e4dec300c01b3b7b30a72796f02df32a094b71639e72"

  def install
    (prefix/"toolchain").install Dir["./*"]
    Dir.glob(prefix/"toolchain/bin/*") {|file| bin.install_symlink file}
  end
end

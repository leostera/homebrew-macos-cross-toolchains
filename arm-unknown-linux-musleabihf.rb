class ArmUnknownLinuxMusleabihf < Formula
  desc "arm-unknown-linux-musleabihf Toolchain"
  homepage "https://github.com/leostera/homebrew-macos-cross-toolchains"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  version "13.4.0"

  depends_on "bdw-gc"
  depends_on "guile"
  depends_on "zstd"
  depends_on "python@3.12"

  url "https://github.com/leostera/homebrew-macos-cross-toolchains/releases/download/v13.4.0/arm-unknown-linux-musleabihf-aarch64-darwin.tar.gz"
  sha256 "f16e4e5973a74ea895dd34cd1be497860ca03c77e1d9b44811b1c89a3403436b"

  def install
    (prefix/"toolchain").install Dir["./*"]
    Dir.glob(prefix/"toolchain/bin/*") {|file| bin.install_symlink file}
  end
end

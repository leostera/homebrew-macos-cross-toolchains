class ArmUnknownLinuxGnueabihf < Formula
  desc "arm-unknown-linux-gnueabihf Toolchain"
  homepage "https://github.com/leostera/homebrew-macos-cross-toolchains"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  version "13.4.0"

  depends_on "bdw-gc"
  depends_on "guile"
  depends_on "zstd"
  depends_on "python@3.12"

  url "https://github.com/leostera/homebrew-macos-cross-toolchains/releases/download/v13.4.0/arm-unknown-linux-gnueabihf-aarch64-darwin.tar.gz"
  sha256 "47572bac01f651289eae86aabdbec218d4075afe8e2af071cda75e64c497d072"

  def install
    (prefix/"toolchain").install Dir["./*"]
    Dir.glob(prefix/"toolchain/bin/*") {|file| bin.install_symlink file}
  end
end

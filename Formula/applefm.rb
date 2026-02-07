class Applefm < Formula
  desc "Thin CLI wrapper for Apple Foundation Models framework"
  homepage "https://github.com/yoshikouki/applefm"
  url "https://github.com/yoshikouki/applefm/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "e6ef41ca02ea89b25511b4dfb45ad5656303de2ff6f71abfbfa14e9805db715e"
  license "MIT"

  depends_on macos: :tahoe
  depends_on xcode: ["26.0", :build]

  def install
    # FoundationModels macro plugin (libFoundationModelsMacros.dylib) only exists
    # in Xcode's SDK, not in CommandLineTools. Ensure Xcode's developer directory
    # is used for the build.
    ENV["DEVELOPER_DIR"] = Utils.safe_popen_read("xcode-select", "-p").chomp
    ENV["SDKROOT"] = Utils.safe_popen_read("xcrun", "--show-sdk-path").chomp

    system "swift", "build",
           "--disable-sandbox",
           "-c", "release",
           "--arch", "arm64"
    bin.install ".build/release/applefm"
  end

  def caveats
    <<~EOS
      applefm requires:
        - macOS 26+ (Tahoe)
        - Apple Silicon Mac with Apple Intelligence enabled
        - Xcode 26+ (for building)
      Check availability: applefm model availability
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/applefm --version")
  end
end

class HeadphoneDisconnect < Formula
  desc "Disconnect Bluetooth headphones when your Mac sleeps, reconnect when it wakes"
  homepage "https://github.com/mon4our/headphone-disconnect"
  url "https://github.com/mon4our/headphone-disconnect/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "SHA256_PLACEHOLDER"
  license "MIT"
  head "https://github.com/mon4our/headphone-disconnect.git", branch: "main"

  depends_on :macos

  def install
    system "./build.sh"
    bin.install "headphone-disconnect"

    # The app bundle is not cosmetic: macOS kills a bundled app that touches Bluetooth
    # unless its Info.plist carries NSBluetoothAlwaysUsageDescription, and only a bundle
    # can carry one. The menu bar UI therefore has to run from here, not from bin.
    app = prefix/"Headphone Disconnect.app"
    (app/"Contents/MacOS").mkpath
    (app/"Contents/Resources").mkpath
    cp bin/"headphone-disconnect", app/"Contents/MacOS/headphone-disconnect"
    cp "Resources/Info.plist", app/"Contents/Info.plist"
    cp "Resources/AppIcon.icns", app/"Contents/Resources/AppIcon.icns"
    # Ad-hoc signature gives TCC a stable-enough identity for one install.
    system "codesign", "--force", "--sign", "-", app
  end

  service do
    run [opt_prefix/"Headphone Disconnect.app/Contents/MacOS/headphone-disconnect", "menubar"]
    keep_alive crashed: true
    error_log_path var/"log/headphone-disconnect.log"
  end

  def caveats
    <<~EOS
      Start it at login:
        brew services start headphone-disconnect

      Then pick your headphones from the menu bar icon, or check state with:
        headphone-disconnect status

      macOS will ask for Bluetooth permission the first time — allow it, or the app is
      killed the moment it touches Bluetooth.

      For a clickable app in Finder and Spotlight:
        ln -s "#{opt_prefix}/Headphone Disconnect.app" ~/Applications/
    EOS
  end

  test do
    assert_match "usage:", shell_output("#{bin}/headphone-disconnect --help")
  end
end

class Handover < Formula
  desc "Disconnect Bluetooth headphones when your Mac sleeps, reconnect when it wakes"
  homepage "https://github.com/mon4our/handover"
  url "https://github.com/mon4our/handover/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "336f3bd2484e912f392c43156f5e7594b3de0e590f1f4558b9c2692fbd14065a"
  license "MIT"
  head "https://github.com/mon4our/handover.git", branch: "main"

  depends_on :macos

  def install
    system "./build.sh"
    bin.install "handover"

    # The app bundle is not cosmetic: macOS kills a bundled app that touches Bluetooth
    # unless its Info.plist carries NSBluetoothAlwaysUsageDescription, and only a bundle
    # can carry one. The menu bar UI therefore has to run from here, not from bin.
    app = prefix/"Handover.app"
    (app/"Contents/MacOS").mkpath
    (app/"Contents/Resources").mkpath
    cp bin/"handover", app/"Contents/MacOS/handover"
    cp "Resources/Info.plist", app/"Contents/Info.plist"
    cp "Resources/AppIcon.icns", app/"Contents/Resources/AppIcon.icns"
    # Ad-hoc signature gives TCC a stable-enough identity for one install.
    system "codesign", "--force", "--sign", "-", app
  end

  service do
    run [opt_prefix/"Handover.app/Contents/MacOS/handover", "menubar"]
    keep_alive crashed: true
    error_log_path var/"log/handover.log"
  end

  def caveats
    <<~EOS
      Start it at login:
        brew services start handover

      Then pick your headphones from the menu bar icon, or check state with:
        handover status

      macOS will ask for Bluetooth permission the first time — allow it, or the app is
      killed the moment it touches Bluetooth.

      For a clickable app in Finder and Spotlight:
        ln -s "#{opt_prefix}/Handover.app" ~/Applications/
    EOS
  end

  test do
    assert_match "usage:", shell_output("#{bin}/handover --help")
  end
end

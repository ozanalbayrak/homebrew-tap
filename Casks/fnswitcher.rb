cask "fnswitcher" do
  version "0.1.0"
  sha256 "d59a47ba4cb615248918f4b83f00a552e21b10b3081636a3c3ff68dcebb2658c"

  url "https://github.com/ozanalbayrak/fn-key-mod-switcher/releases/download/v#{version}/FnSwitcher-#{version}.zip"
  name "FnSwitcher"
  desc "Toggle F1-F12 between function keys and media keys with a shortcut"
  homepage "https://github.com/ozanalbayrak/fn-key-mod-switcher"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"
  depends_on arch: :arm64

  app "FnSwitcher.app"

  # The app is ad-hoc signed, not notarized. Clear the quarantine flag so it
  # opens without the Gatekeeper "cannot be opened" dialog.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/FnSwitcher.app"]
  end

  zap trash: "~/Library/Preferences/com.ozanalbayrak.FnSwitcher.plist"
end

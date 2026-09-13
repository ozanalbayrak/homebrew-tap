cask "fnswitcher" do
  version "0.1.1"
  sha256 "42b4fac2e4a8bfb55238a9caae687e99aa2f00d9b6ab5ad34790cce62870f29c"

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

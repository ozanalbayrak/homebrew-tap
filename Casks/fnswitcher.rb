cask "fnswitcher" do
  version "0.2.0"
  sha256 "ac8a67a9d150cb00cc8b51930f2d1e33d713fbbca466d309a8e989e5fad6054e"

  url "https://github.com/ozanalbayrak/fn-key-mod-switcher/releases/download/v#{version}/FnSwitcher-#{version}.zip"
  name "FnSwitcher"
  desc "Toggle F1-F12 between function keys and media keys with a shortcut"
  homepage "https://github.com/ozanalbayrak/fn-key-mod-switcher"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :ventura

  app "FnSwitcher.app"

  # The app is ad-hoc signed, not notarized. Clear the quarantine flag so it
  # opens without the Gatekeeper "cannot be opened" dialog.
  #
  # The structured `run` step needs Homebrew >= 6.0.15 (Aug 2026); older
  # installs only understand the legacy block. Drop the fallback once
  # nobody is on the old versions anymore.
  if defined?(Homebrew::InstallSteps::DSL) && Homebrew::InstallSteps::DSL.method_defined?(:run)
    postflight_steps do
      run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/FnSwitcher.app"]
    end
  else
    postflight do
      system_command "/usr/bin/xattr",
                     args: ["-dr", "com.apple.quarantine", "#{appdir}/FnSwitcher.app"]
    end
  end

  zap trash: "~/Library/Preferences/com.ozanalbayrak.FnSwitcher.plist"
end

cask "copystack" do
  version "0.1.1"
  sha256 "f3c2eadcd8c2980e7f3e644b86270eb7bd5af12aa536f55bc2402008cf2e2d81"

  url "https://github.com/ozanalbayrak/copy-stack/releases/download/v#{version}/CopyStack-#{version}.zip"
  name "CopyStack"
  desc "Menu bar app for pasting saved text snippets with global keyboard shortcuts"
  homepage "https://github.com/ozanalbayrak/copy-stack"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "CopyStack.app"

  # The app is ad-hoc signed, not notarized. Clear the quarantine flag so it
  # opens without the Gatekeeper "cannot be opened" dialog.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/CopyStack.app"]
  end

  zap trash: "~/Library/Application Support/CopyStack"

  caveats do
    <<~EOS
      CopyStack needs Accessibility access to paste:
        System Settings → Privacy & Security → Accessibility → enable CopyStack
      Because releases are ad-hoc signed, this has to be granted again after every update.
    EOS
  end
end

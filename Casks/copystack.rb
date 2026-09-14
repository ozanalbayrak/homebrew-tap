cask "copystack" do
  version "0.2.0"
  sha256 "a941bfad11aa755dec9b3cc335af1cca2046fd4cc5d8c01f0014a59bccddeeea"

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
  #
  # The structured `run` step needs Homebrew >= 6.0.15 (Aug 2026); older
  # installs only understand the legacy block. Drop the fallback once
  # nobody is on the old versions anymore.
  if defined?(Homebrew::InstallSteps::DSL) && Homebrew::InstallSteps::DSL.method_defined?(:run)
    postflight_steps do
      run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/CopyStack.app"]
    end
  else
    postflight do
      system_command "/usr/bin/xattr",
                     args: ["-dr", "com.apple.quarantine", "#{appdir}/CopyStack.app"]
    end
  end

  zap trash: "~/Library/Application Support/CopyStack"

  caveats do
    <<~EOS
      CopyStack needs Accessibility access to paste:
        System Settings → Privacy & Security → Accessibility → enable CopyStack
      Snippets marked "Store in Keychain" live in your login Keychain; the first time
      one is used, macOS asks whether CopyStack may access it — choose "Always Allow".
      Because releases are ad-hoc signed, both grants have to be given again after
      every update.
    EOS
  end
end

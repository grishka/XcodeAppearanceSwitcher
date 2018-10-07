# Installation

1. If this is your first time installing an Xcode plugin, you'll need to re-sign your Xcode. See [this](https://github.com/XVimProject/XVim2/blob/master/SIGNING_Xcode.md) for details on how to do that.

2. Download the plugin from the releases section.

3. Copy the plugin bundle to ~/Library/Application Support/Developer/Shared/Xcode/Plug-ins

4. Start Xcode. It should ask you whether you want to load the plugin. If you've mistakenly clicked "No", run this command to reset this choice:

    `defaults delete  com.apple.dt.Xcode DVTPlugInManagerNonApplePlugIns-Xcode-X.X`     (X.X is your Xcode version)

5. You should see a new item, Appearance, under the View menu - that's what you use to switch themes.

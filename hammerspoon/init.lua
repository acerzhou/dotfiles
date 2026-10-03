---------------------------------------
-- HAMMERSPOON CONFIGURATION
---------------------------------------
-- Main configuration file that loads all modules

-- Configuration
hs.window.animationDuration = 0.15

-- Load modules
local windowMgmt = require("modules.window-management")
local clipboard = require("modules.clipboard")
local textExpansion = require("modules.text-expansion")
local appLauncher = require("modules.app-launcher")
local layouts = require("modules.layouts")
local hyperKey = require("modules.hyper-key")
local system = require("modules.system")

-- Initialize modules
windowMgmt.init()
clipboard.init()
textExpansion.init()
appLauncher.init()
layouts.init()
hyperKey.init(windowMgmt.moveWindow, appLauncher.open_app)
system.init()

-- Load optional shortcuts and modules from the active profile.
local profileInit = os.getenv("HOME") .. "/.config/dotfiles/profile/hammerspoon/init.lua"
if hs.fs.attributes(profileInit) then
    local ok, profileError = pcall(dofile, profileInit)
    if not ok then
        hs.alert.show("Profile config error: " .. profileError)
    end
end

-- Startup notification
hs.alert.show("Hammerspoon config loaded!")

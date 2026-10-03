---------------------------------------
-- SYSTEM UTILITIES
---------------------------------------

local M = {}

function M.init()
    hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
        hs.alert.show("Reloading config...")
        hs.timer.doAfter(0.5, function()
            hs.reload()
        end)
    end)

    local function reloadConfig(files)
        local doReload = false
        for _, file in pairs(files) do
            if file:sub(-4) == ".lua" then
                doReload = true
            end
        end
        if doReload then
            hs.reload()
        end
    end
    M.configWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig)
    M.configWatcher:start()

    hs.hotkey.bind({"cmd", "alt", "ctrl"}, "O", function()
        hs.execute("open -a 'Visual Studio Code' ~/.hammerspoon/")
        hs.alert.show("Opening config...")
    end)

    local caffeinateOn = false
    hs.hotkey.bind({"cmd", "alt", "ctrl"}, "C", function()
        caffeinateOn = not caffeinateOn
        if caffeinateOn then
            hs.caffeinate.set("displayIdle", true)
            hs.alert.show("☕ Caffeinate ON")
        else
            hs.caffeinate.set("displayIdle", false)
            hs.alert.show("💤 Caffeinate OFF")
        end
    end)

    hs.hotkey.bind({"cmd", "alt", "ctrl"}, "H", function()
        local helpText = [[
Hammerspoon Shortcuts:

📋 CLIPBOARD:
⌘⌥V - Show clipboard history

✏️ TEXT EXPANSION:
@@ → your email
ddate → current date
ttime → current time
shrug → ¯\_(ツ)_/¯

🖥️ WINDOW LAYOUTS:
⌘⌥⌃1 - Dev layout
⌘⌥⌃2 - Writing layout
⌘⌥⌃3 - Communication layout

⌨️ HYPER KEY (Caps Lock):
Hyper+H/L - Left/Right half
Hyper+K - Maximize
Hyper+J - Center
Hyper+1/2/3 - Thirds
        ]]
        hs.alert.show(helpText, 8)
    end)

    hs.urlevent.bind("someAlert", function(eventName)
        hs.alert.show("Received: " .. eventName)
    end)
end

return M

-- ═══════════════════════════════════════════════════════════
-- Hammerspoon Configuration
-- ═══════════════════════════════════════════════════════════

-- Reload config automatically
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
hs.alert.show("Config loaded")

-- ═══════════════════════════════════════════════════════════
-- Hyper Key Setup
-- ═══════════════════════════════════════════════════════════

-- Define hyper key (Cmd + Ctrl + Alt + Shift)
local hyper = {"cmd", "alt", "ctrl", "shift"}

-- ═══════════════════════════════════════════════════════════
-- Window Management
-- ═══════════════════════════════════════════════════════════

-- Maximize window
hs.hotkey.bind(hyper, "M", function()
    local win = hs.window.focusedWindow()
    if win then
        win:maximize()
    end
end)

-- Left half
hs.hotkey.bind(hyper, "Left", function()
    local win = hs.window.focusedWindow()
    if win then
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()
        
        f.x = max.x
        f.y = max.y
        f.w = max.w / 2
        f.h = max.h
        win:setFrame(f)
    end
end)

-- Right half
hs.hotkey.bind(hyper, "Right", function()
    local win = hs.window.focusedWindow()
    if win then
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()
        
        f.x = max.x + (max.w / 2)
        f.y = max.y
        f.w = max.w / 2
        f.h = max.h
        win:setFrame(f)
    end
end)

-- Top half
hs.hotkey.bind(hyper, "Up", function()
    local win = hs.window.focusedWindow()
    if win then
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()
        
        f.x = max.x
        f.y = max.y
        f.w = max.w
        f.h = max.h / 2
        win:setFrame(f)
    end
end)

-- Bottom half
hs.hotkey.bind(hyper, "Down", function()
    local win = hs.window.focusedWindow()
    if win then
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()
        
        f.x = max.x
        f.y = max.y + (max.h / 2)
        f.w = max.w
        f.h = max.h / 2
        win:setFrame(f)
    end
end)

-- Quarter: Top-left
hs.hotkey.bind(hyper, "1", function()
    local win = hs.window.focusedWindow()
    if win then
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()
        
        f.x = max.x
        f.y = max.y
        f.w = max.w / 2
        f.h = max.h / 2
        win:setFrame(f)
    end
end)

-- Quarter: Top-right
hs.hotkey.bind(hyper, "2", function()
    local win = hs.window.focusedWindow()
    if win then
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()
        
        f.x = max.x + (max.w / 2)
        f.y = max.y
        f.w = max.w / 2
        f.h = max.h / 2
        win:setFrame(f)
    end
end)

-- Quarter: Bottom-left
hs.hotkey.bind(hyper, "3", function()
    local win = hs.window.focusedWindow()
    if win then
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()
        
        f.x = max.x
        f.y = max.y + (max.h / 2)
        f.w = max.w / 2
        f.h = max.h / 2
        win:setFrame(f)
    end
end)

-- Quarter: Bottom-right
hs.hotkey.bind(hyper, "4", function()
    local win = hs.window.focusedWindow()
    if win then
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()
        
        f.x = max.x + (max.w / 2)
        f.y = max.y + (max.h / 2)
        f.w = max.w / 2
        f.h = max.h / 2
        win:setFrame(f)
    end
end)

-- Center window
hs.hotkey.bind(hyper, "C", function()
    local win = hs.window.focusedWindow()
    if win then
        win:centerOnScreen()
    end
end)

-- ═══════════════════════════════════════════════════════════
-- Monitor Management
-- ═══════════════════════════════════════════════════════════

-- Move window to next monitor
hs.hotkey.bind(hyper, "N", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToScreen(win:screen():next())
    end
end)

-- Move window to previous monitor
hs.hotkey.bind(hyper, "P", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToScreen(win:screen():previous())
    end
end)

-- ═══════════════════════════════════════════════════════════
-- Application Launcher
-- ═══════════════════════════════════════════════════════════

-- Quick application launcher
local apps = {
    ["T"] = "iTerm",
    ["B"] = "Firefox",
    ["E"] = "Visual Studio Code",
    ["S"] = "Slack",
    ["N"] = "Notion",
}

for key, app in pairs(apps) do
    hs.hotkey.bind(hyper, key, function()
        hs.application.launchOrFocus(app)
    end)
end

-- ═══════════════════════════════════════════════════════════
-- Caffeine (Prevent sleep)
-- ═══════════════════════════════════════════════════════════

local caffeine = hs.menubar.new()

function setCaffeineDisplay(state)
    if state then
        caffeine:setTitle("☕")
    else
        caffeine:setTitle("💤")
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

-- ═══════════════════════════════════════════════════════════
-- Audio Device Switcher (Optional)
-- ═══════════════════════════════════════════════════════════

-- Toggle audio output
hs.hotkey.bind(hyper, "A", function()
    local current = hs.audiodevice.defaultOutputDevice()
    local speakers = hs.audiodevice.findOutputByName("MacBook Pro Speakers")
    local headphones = hs.audiodevice.findOutputByName("External Headphones")
    
    if current:name() == "MacBook Pro Speakers" and headphones then
        headphones:setDefaultOutputDevice()
        hs.alert.show("🎧 Headphones")
    elseif speakers then
        speakers:setDefaultOutputDevice()
        hs.alert.show("🔊 Speakers")
    end
end)

-- ═══════════════════════════════════════════════════════════
-- Screen Lock
-- ═══════════════════════════════════════════════════════════

hs.hotkey.bind(hyper, "L", function()
    hs.caffeinate.lockScreen()
end)

-- ═══════════════════════════════════════════════════════════
-- Clipboard History (Simple)
-- ═══════════════════════════════════════════════════════════

local clipboardHistory = {}
local maxClipboardSize = 20

local function addToClipboard(item)
    if item and item ~= "" then
        -- Remove if already exists
        for i, v in ipairs(clipboardHistory) do
            if v == item then
                table.remove(clipboardHistory, i)
                break
            end
        end
        -- Add to front
        table.insert(clipboardHistory, 1, item)
        -- Limit size
        while #clipboardHistory > maxClipboardSize do
            table.remove(clipboardHistory)
        end
    end
end

-- Watch clipboard
local clipboardTimer = hs.timer.new(1, function()
    local currentClip = hs.pasteboard.getContents()
    addToClipboard(currentClip)
end)
clipboardTimer:start()

-- Show clipboard history
hs.hotkey.bind(hyper, "V", function()
    local choices = {}
    for i, item in ipairs(clipboardHistory) do
        table.insert(choices, {
            text = item:sub(1, 100),
            subText = string.format("#%d - %d chars", i, #item),
            index = i
        })
    end
    
    local chooser = hs.chooser.new(function(choice)
        if choice then
            hs.pasteboard.setContents(clipboardHistory[choice.index])
            hs.eventtap.keyStroke({"cmd"}, "v")
        end
    end)
    
    chooser:choices(choices)
    chooser:show()
end)

-- ═══════════════════════════════════════════════════════════
-- Helpful Utilities
-- ═══════════════════════════════════════════════════════════

-- Show current WiFi network
hs.hotkey.bind(hyper, "W", function()
    local wifi = hs.wifi.currentNetwork()
    if wifi then
        hs.alert.show("WiFi: " .. wifi)
    else
        hs.alert.show("No WiFi connected")
    end
end)

-- Show battery status
hs.hotkey.bind(hyper, "B", function()
    local battery = hs.battery.percentage()
    local charging = hs.battery.isCharging()
    local status = charging and "⚡ Charging" or "🔋 Battery"
    hs.alert.show(string.format("%s: %.0f%%", status, battery))
end)

-- ═══════════════════════════════════════════════════════════
-- Finish
-- ═══════════════════════════════════════════════════════════

hs.notify.new({title="Hammerspoon", informativeText="Configuration loaded"}):send()

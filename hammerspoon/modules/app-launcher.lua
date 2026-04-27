---------------------------------------
-- APP LAUNCHER & SWITCHING
---------------------------------------

local M = {}

function open_app(name)
    return function()
        local success = hs.application.launchOrFocus(name)
        if not success then
            hs.alert.show("Failed to launch " .. name)
            return
        end
        if name == "Finder" then
            local app = hs.appfinder.appFromName(name)
            if app then
                app:activate()
            end
        end
    end
end

local frontApp = hs.application.frontmostApplication()
local previousActiveBundleId = frontApp and frontApp:bundleID() or nil

local function applicationWatcher(_, eventType, appObject)
    if eventType == hs.application.watcher.deactivated and appObject then
        previousActiveBundleId = appObject:bundleID()
    end
end

local function switch_previous_app()
    return function()
        if previousActiveBundleId then
            hs.application.launchOrFocusByBundleID(previousActiveBundleId)
        else
            hs.alert.show("No previous app")
        end
    end
end

function M.init()
    local appWatcher = hs.application.watcher.new(applicationWatcher)
    appWatcher:start()

    hs.hotkey.bind({"alt", "shift"}, "1", open_app("Firefox"))
    hs.hotkey.bind({"alt", "shift"}, "2", open_app("Calendar"))
    hs.hotkey.bind({"alt", "shift"}, "3", open_app("Reminders"))
    hs.hotkey.bind({"alt", "shift"}, "4", open_app("Notes"))
    hs.hotkey.bind({"alt", "shift"}, "9", open_app("Finder"))
    hs.hotkey.bind({"alt", "shift"}, "0", open_app("Google Chrome"))

    hs.hotkey.bind({"alt", "shift"}, "t", open_app("iTerm"))
    hs.hotkey.bind({"alt", "shift"}, "c", open_app("Visual Studio Code"))
    hs.hotkey.bind({"alt", "shift"}, "m", open_app("Mail"))
    hs.hotkey.bind({"alt", "shift"}, "n", open_app("Notion"))

    hs.hotkey.bind({"alt", "shift"}, "p", switch_previous_app())
end

M.open_app = open_app

return M

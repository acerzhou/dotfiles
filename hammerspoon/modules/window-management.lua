---------------------------------------
-- WINDOW MANAGEMENT
---------------------------------------

local M = {}

-- Window management helper function
local function moveWindow(xRatio, yRatio, wRatio, hRatio)
    return function()
        local win = hs.window.focusedWindow()
        if not win then
            hs.alert.show("No focused window")
            return
        end

        local screen = win:screen()
        local max = screen:frame()

        win:setFrame({
            x = max.x + (max.w * xRatio),
            y = max.y + (max.h * yRatio),
            w = max.w * wRatio,
            h = max.h * hRatio
        })
    end
end

function M.init()
    -- Half screen layouts
    hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", moveWindow(0, 0, 0.5, 1))
    hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", moveWindow(0.5, 0, 0.5, 1))
    hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Up", moveWindow(0, 0, 1, 1))
    hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Down", moveWindow(0.15, 0.15, 0.7, 0.7))

    -- Quarter screen layouts
    hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "Left", moveWindow(0, 0, 0.5, 0.5))
    hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "Right", moveWindow(0.5, 0, 0.5, 0.5))
    hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "Down", moveWindow(0.5, 0.5, 0.5, 0.5))
    hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "Up", moveWindow(0, 0.5, 0.5, 0.5))

    -- Move window to next/previous monitor
    hs.hotkey.bind({"cmd", "alt", "ctrl"}, "N", function()
        local win = hs.window.focusedWindow()
        if win then
            win:moveToScreen(win:screen():next())
            hs.alert.show("Moved to next screen")
        end
    end)

    hs.hotkey.bind({"cmd", "alt", "ctrl"}, "P", function()
        local win = hs.window.focusedWindow()
        if win then
            win:moveToScreen(win:screen():previous())
            hs.alert.show("Moved to previous screen")
        end
    end)

    -- Window hints for quick window switching
    hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Space", function()
        hs.hints.windowHints()
    end)
end

M.moveWindow = moveWindow

return M

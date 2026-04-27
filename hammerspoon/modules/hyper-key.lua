---------------------------------------
-- HYPER KEY (Caps Lock as modifier)
---------------------------------------
-- Install Karabiner-Elements first and map Caps Lock to F18
-- Then F18 will act as Hyper (cmd+alt+ctrl+shift)

local M = {}

function M.init(moveWindow, open_app)
    local hyper = {"cmd", "alt", "ctrl", "shift"}

    -- Hyper + H/J/K/L for window movement (Vim-style)
    hs.hotkey.bind(hyper, "H", moveWindow(0, 0, 0.5, 1))
    hs.hotkey.bind(hyper, "L", moveWindow(0.5, 0, 0.5, 1))
    hs.hotkey.bind(hyper, "K", moveWindow(0, 0, 1, 1))
    hs.hotkey.bind(hyper, "J", moveWindow(0.15, 0.15, 0.7, 0.7))

    -- Hyper + Numbers for thirds
    hs.hotkey.bind(hyper, "1", moveWindow(0, 0, 0.33, 1))
    hs.hotkey.bind(hyper, "2", moveWindow(0.33, 0, 0.34, 1))
    hs.hotkey.bind(hyper, "3", moveWindow(0.67, 0, 0.33, 1))

    -- Hyper + Apps (quick access)
    hs.hotkey.bind(hyper, "T", open_app("iTerm"))
    hs.hotkey.bind(hyper, "B", open_app("Google Chrome"))
    hs.hotkey.bind(hyper, "E", open_app("Visual Studio Code"))
    hs.hotkey.bind(hyper, "N", open_app("Notion"))
    hs.hotkey.bind(hyper, "M", open_app("Mail"))
end

return M

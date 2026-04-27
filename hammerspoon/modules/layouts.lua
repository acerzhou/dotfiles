---------------------------------------
-- SMART WINDOW LAYOUTS (Workspaces)
---------------------------------------

local M = {}

local layouts = {
    dev = {
        {"Visual Studio Code", nil, nil, {0, 0, 0.6, 1}},
        {"iTerm", nil, nil, {0.6, 0, 0.4, 0.4}},
        {"Firefox", nil, nil, {0.6, 0.4, 0.4, 0.3}},
        {"Docker Desktop", nil, nil, {0.6, 0.7, 0.4, 0.3}},
    },
    writing = {
        {"Notion", nil, nil, {0.15, 0.05, 0.7, 0.9}},
        {"Notes", nil, nil, {0.15, 0.05, 0.7, 0.9}},
    },
    comm = {
        {"Mail", nil, nil, {0, 0, 0.5, 1}},
        {"Calendar", nil, nil, {0.5, 0, 0.5, 0.5}},
        {"Slack", nil, nil, {0.5, 0.5, 0.5, 0.5}},
    },
}

local function applyLayout(layoutName)
    local layout = layouts[layoutName]
    if not layout then
        hs.alert.show("Layout '" .. layoutName .. "' not found")
        return
    end

    local screen = hs.screen.mainScreen()
    local screenFrame = screen:frame()

    for _, item in ipairs(layout) do
        local appName = item[1]
        local position = item[4]

        hs.application.launchOrFocus(appName)
        hs.timer.doAfter(0.3, function()
            local app = hs.application.get(appName)
            if app then
                local win = app:mainWindow()
                if win then
                    win:setFrame({
                        x = screenFrame.x + (screenFrame.w * position[1]),
                        y = screenFrame.y + (screenFrame.h * position[2]),
                        w = screenFrame.w * position[3],
                        h = screenFrame.h * position[4]
                    })
                end
            end
        end)
    end

    hs.alert.show("Applied '" .. layoutName .. "' layout")
end

function M.init()
    hs.hotkey.bind({"cmd", "alt", "ctrl"}, "1", function() applyLayout("dev") end)
    hs.hotkey.bind({"cmd", "alt", "ctrl"}, "2", function() applyLayout("writing") end)
    hs.hotkey.bind({"cmd", "alt", "ctrl"}, "3", function() applyLayout("comm") end)
end

function M.addLayout(name, layout)
    layouts[name] = layout
end

return M

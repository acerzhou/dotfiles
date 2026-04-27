---------------------------------------
-- CLIPBOARD MANAGER
---------------------------------------

local M = {}

local clipboardHistory = {}
local maxClipboardSize = 50
local lastClipboard = hs.pasteboard.getContents()

local function addToClipboard(content)
    if content and content ~= "" and content ~= lastClipboard then
        for i, item in ipairs(clipboardHistory) do
            if item == content then
                table.remove(clipboardHistory, i)
                break
            end
        end

        table.insert(clipboardHistory, 1, content)

        if #clipboardHistory > maxClipboardSize then
            table.remove(clipboardHistory, maxClipboardSize + 1)
        end

        lastClipboard = content
    end
end

function M.init()
    clipboardTimer = hs.timer.new(1, function()
        local content = hs.pasteboard.getContents()
        addToClipboard(content)
    end)
    clipboardTimer:start()

    hs.hotkey.bind({"cmd", "alt"}, "V", function()
        if #clipboardHistory == 0 then
            hs.alert.show("Clipboard history is empty")
            return
        end

        local chooser = hs.chooser.new(function(choice)
            if choice then
                hs.pasteboard.setContents(choice.text)
                hs.eventtap.keyStroke({"cmd"}, "V")
            end
        end)

        local choices = {}
        for i, item in ipairs(clipboardHistory) do
            local preview = item:sub(1, 100)
            if #item > 100 then
                preview = preview .. "..."
            end
            table.insert(choices, {
                text = item,
                subText = "Copied " .. (i == 1 and "just now" or "#" .. i),
                preview = preview
            })
        end

        chooser:choices(choices)
        chooser:show()
    end)
end

return M

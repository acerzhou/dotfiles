---------------------------------------
-- TEXT EXPANSION
---------------------------------------

local M = {}

local expansions = {
    ["@@"] = os.getenv("MY_EMAIL") or "your.email@example.com",
    ["ddate"] = function() return os.date("%Y-%m-%d") end,
    ["ttime"] = function() return os.date("%H:%M") end,
    ["dts"] = function() return os.date("%Y-%m-%d %H:%M:%S") end,
    ["shrug"] = "¯\\_(ツ)_/¯",
    ["lenny"] = "( ͡° ͜ʖ ͡°)",
    ["check"] = "✓",
    ["arrow"] = "→",
    ["lambda"] = "λ",
}

function M.init()
    local expansionWatcher = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
        local char = event:getCharacters()
        if not char or char == "" then
            return false
        end

        local currentWord = (hs.eventtap.currentWord or "") .. char
        hs.eventtap.currentWord = currentWord

        for trigger, replacement in pairs(expansions) do
            if currentWord:sub(-#trigger) == trigger then
                for _ = 1, #trigger do
                    hs.eventtap.keyStroke({}, "delete", 0)
                end

                local text = type(replacement) == "function" and replacement() or replacement
                hs.eventtap.keyStrokes(text)

                hs.eventtap.currentWord = ""
                return true
            end
        end

        if char == " " or char == "\n" or char == "\r" or char == "\t" then
            hs.eventtap.currentWord = ""
        end

        return false
    end)
    expansionWatcher:start()
end

function M.addExpansion(trigger, replacement)
    expansions[trigger] = replacement
end

return M

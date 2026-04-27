---------------------------------------
-- WEATHER MENUBAR
---------------------------------------

local M = {}

local weatherMenu = nil
local weatherCity = "San_Francisco"

local function updateWeather()
    hs.http.asyncGet("https://wttr.in/" .. weatherCity .. "?format=%c+%t", nil, function(status, body)
        if status == 200 and body and weatherMenu then
            local weather = body:gsub("^%s*(.-)%s*$", "%1")
            weatherMenu:setTitle(weather)
        elseif weatherMenu then
            weatherMenu:setTitle("⛅ --°")
        end
    end)
end

function M.init()
    weatherMenu = hs.menubar.new()

    if weatherMenu then
        weatherMenu:setTitle("☁️ Loading...")
        weatherMenu:setMenu(function()
            return {
                {title = "Update Weather", fn = updateWeather},
                {title = "Open Weather Forecast", fn = function()
                    hs.execute("open 'https://wttr.in/" .. weatherCity .. "'")
                end},
                {title = "-"},
                {title = "Change Location", fn = function()
                    local button, city = hs.dialog.textPrompt(
                        "Weather Location",
                        "Enter city name (use underscores for spaces):",
                        weatherCity,
                        "OK",
                        "Cancel"
                    )
                    if button == "OK" and city ~= "" then
                        weatherCity = city
                        updateWeather()
                    end
                end}
            }
        end)

        updateWeather()
        hs.timer.doEvery(1800, updateWeather)
    end
end

return M

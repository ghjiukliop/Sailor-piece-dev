local HttpService = game:GetService("HttpService")
local BaseURL = "https://raw.githubusercontent.com/ghjiukliop/Sailor-piece-dev/main/"

_G.AOT_Hub = {
    Settings = { Version = "1.0.0" },
    Utils = {},
    Raid = {},
    Mission = {}
}

-- Hàm nạp file Lua (Dùng cho UI, Raid, Mission)
local function ImportLua(path)
    local success, content = pcall(function()
        return game:HttpGet(BaseURL .. path .. "?t=" .. tick())
    end)
    if success and not content:find("404") then
        local func, err = loadstring(content)
        if func then
            local res = func()
            return (type(res) == "table" and res) or {}
        end
    end
    return {}
end

-- Hàm nạp file JSON (Dùng riêng cho Settings)
local function ImportJSON(path)
    local success, content = pcall(function()
        return game:HttpGet(BaseURL .. path .. "?t=" .. tick())
    end)
    if success and not content:find("404") then
        local decodeSuccess, decodedData = pcall(function()
            return HttpService:JSONDecode(content)
        end)
        if decodeSuccess then return decodedData end
    end
    return { Version = "1.0.0" } -- Giá trị dự phòng nếu lỗi
end

-- Nạp dữ liệu hệ thống
_G.AOT_Hub.Settings = ImportJSON("Settings.json")
_G.AOT_Hub.Raid = ImportLua("Model/Raid.lua")
_G.AOT_Hub.Mission = ImportLua("Model/Mission.lua")

task.wait(0.2)
ImportLua("UI.lua")
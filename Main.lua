-- [[ AOT REVOLUTION - MAIN CLOUD ]] --
local BaseURL = "https://raw.githubusercontent.com/ghjiukliop/AOT_Revolution/main/"

_G.AOT_Hub = {
    Settings = {},
    Utils = {},
    Raid = {},
    Mission = {}
}

-- Hàm nạp file từ GitHub
local function Import(path)
    local success, content = pcall(function()
        return game:HttpGet(BaseURL .. path)
    end)
    
    if success and not content:find("404") then
        local func, err = loadstring(content)
        if func then
            return func()
        else
            warn("Lỗi cú pháp trong " .. path .. ": " .. err)
        end
    else
        warn("Không tìm thấy file trên GitHub: " .. path)
    end
end

-- Bắt đầu liên kết các Module
_G.AOT_Hub.Settings = Import("Settings.lua")
_G.AOT_Hub.Raid = Import("Model/Raid.lua")
_G.AOT_Hub.Mission = Import("Model/Mission.lua")

-- Cuối cùng là load UI
Import("UI.lua") 
--
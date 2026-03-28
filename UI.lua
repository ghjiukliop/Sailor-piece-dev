-- [Giữ nguyên toàn bộ phần code giao diện bên trên của bạn] --

-- Tìm đến đoạn cuối cùng của file UI.lua và thay thế bằng đoạn này:
local success, verText = pcall(function()
    return _G.AOT_Hub.Settings.Version or "Unknown"
end)

-- Tạo một nhãn hiển thị Version ở góc dưới UI để dễ kiểm soát update
local VersionLabel = Instance.new("TextLabel", Main)
VersionLabel.Size = UDim2.new(0, 100, 0, 20)
VersionLabel.Position = UDim2.new(1, -110, 1, -25)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "Version: " .. tostring(verText)
VersionLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5)
VersionLabel.TextSize = 12
VersionLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Mặc định mở trang Settings
ClearContent()
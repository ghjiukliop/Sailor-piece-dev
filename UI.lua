local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")

local UI = Instance.new("ScreenGui")
UI.Name = "AOT_Pro_Hub"
UI.Parent = game.CoreGui

-- BIẾN TOÀN CỤC CỦA UI
local MainColor = Color3.fromRGB(25, 25, 30)
local AccentColor = Color3.fromRGB(0, 120, 215)

-- 1. NÚT TOGGLE (GÓC PHẢI MÀN HÌNH)
local ToggleIcon = Instance.new("ImageButton")
ToggleIcon.Name = "ToggleIcon"
ToggleIcon.Parent = UI
ToggleIcon.Position = UDim2.new(1, -50, 0.5, -20)
ToggleIcon.Size = UDim2.new(0, 40, 0, 40)
ToggleIcon.BackgroundColor3 = MainColor
ToggleIcon.Image = "rbxassetid://6031280225" -- Icon đơn giản
local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 8)
IconCorner.Parent = ToggleIcon

-- 2. KHUNG CHÍNH (MAIN FRAME)
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Parent = UI
Main.BackgroundColor3 = MainColor
Main.BackgroundTransparency = 0.2 -- Độ mờ mặc định
Main.Position = UDim2.new(0.5, -300, 0.5, -200)
Main.Size = UDim2.new(0, 600, 0, 400)
Main.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Color = AccentColor
Stroke.Parent = Main

-- 3. LOGIC KÉO THẢ TỪ MỌI KHOẢNG TRỐNG (EMPTY SPACE DRAGGING)
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        -- Chỉ kéo nếu không click trúng TextBox hoặc Button (Empty Space)
        if not UIS:GetFocusedTextBox() then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end
end)

Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- 4. Ô TÌM KIẾM (TOP)
local TopBar = Instance.new("Frame")
TopBar.Parent = Main
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundTransparency = 1

local SearchBar = Instance.new("TextBox")
SearchBar.Parent = TopBar
SearchBar.PlaceholderText = "Search features..."
SearchBar.Text = ""
SearchBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
SearchBar.Position = UDim2.new(0.02, 0, 0.2, 0)
SearchBar.Size = UDim2.new(0.96, 0, 0.6, 0)
SearchBar.TextColor3 = Color3.new(1, 1, 1)
local SBCorner = Instance.new("UICorner")
SBCorner.CornerRadius = UDim.new(0, 8)
SBCorner.Parent = SearchBar

-- 5. SIDEBAR & CONTENT
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Parent = Main
Sidebar.Position = UDim2.new(0, 10, 0, 60)
Sidebar.Size = UDim2.new(0, 140, 1, -70)
Sidebar.BackgroundTransparency = 1
Sidebar.ScrollBarThickness = 0

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.Padding = UDim.new(0, 5)

local Content = Instance.new("ScrollingFrame")
Content.Parent = Main
Content.Position = UDim2.new(0, 160, 0, 60)
Content.Size = UDim2.new(1, -170, 1, -70)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 2

-- 6. HÀM TẠO TAB & SETTING
local function ClearContent()
    for _, child in pairs(Content:GetChildren()) do
        if not child:IsA("UIListLayout") then child:Destroy() end
    end
end

local function CreateTab(name, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = Sidebar
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Btn.Text = name
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    Btn.MouseButton1Click:Connect(function()
        ClearContent()
        callback()
    end)
end

-- 7. TRANG SETTING (DASHBOARD)
CreateTab("Settings", function()
    -- Chỉnh độ mờ (Transparency)
    local Label1 = Instance.new("TextLabel", Content)
    Label1.Text = "Độ mờ UI (Transparency):"
    Label1.Size = UDim2.new(1, 0, 0, 20)
    Label1.TextColor3 = Color3.new(1, 1, 1)
    Label1.BackgroundTransparency = 1

    local TransBtn = Instance.new("TextButton", Content)
    TransBtn.Text = "Toggle Glass Mode"
    TransBtn.Size = UDim2.new(0.9, 0, 0, 30)
    TransBtn.MouseButton1Click:Connect(function()
        Main.BackgroundTransparency = (Main.BackgroundTransparency == 0.2) and 0.6 or 0.2
    end)

    -- Chỉnh kích thước (Size)
    local ResizeBtn = Instance.new("TextButton", Content)
    ResizeBtn.Text = "Phóng to / Thu nhỏ"
    ResizeBtn.Size = UDim2.new(0.9, 0, 0, 30)
    ResizeBtn.MouseButton1Click:Connect(function()
        local TargetSize = (Main.Size.X.Offset == 600) and UDim2.new(0, 450, 0, 300) or UDim2.new(0, 600, 0, 400)
        TS:Create(Main, TweenInfo.new(0.3), {Size = TargetSize}):Play()
    end)

    -- Đổi màu (Color)
    local ColorBtn = Instance.new("TextButton", Content)
    ColorBtn.Text = "Đổi màu chủ đạo (RGB)"
    ColorBtn.Size = UDim2.new(0.9, 0, 0, 30)
    ColorBtn.MouseButton1Click:Connect(function()
        local NewColor = Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
        Stroke.Color = NewColor
        AccentColor = NewColor
    end)
end)

-- 8. LOGIC ẨN/HIỆN
ToggleIcon.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Mặc định mở trang Setting khi load
ClearContent()
print("UI đã sẵn sàng, " .. _G.AOT_Hub.Config.Version)
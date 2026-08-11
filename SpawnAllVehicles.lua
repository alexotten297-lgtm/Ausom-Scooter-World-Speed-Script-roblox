local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Altes GUI sauber bereinigen
if CoreGui:FindFirstChild("ShadowVehicleHub") then
    CoreGui.ShadowVehicleHub:Destroy()
end

-- Haupt GUI im Shadow Design erstellen
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShadowVehicleHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame (Shadow Design Layout)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 420)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 55)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Topbar (Fensterleiste)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 14)
TopBarCorner.Parent = TopBar

local TopbarFix = Instance.new("Frame")
TopbarFix.Size = UDim2.new(1, 0, 0, 10)
TopbarFix.Position = UDim2.new(0, 0, 1, -10)
TopbarFix.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
TopbarFix.BorderSizePixel = 0
TopbarFix.Parent = TopBar

-- Fenster verschieben (Drag & Drop)
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Titel
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -45, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "[ 🚗 ] SHADOW VEHICLE SPAWNER"
Title.TextColor3 = Color3.fromRGB(235, 235, 245)
Title.TextSize = 12
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Schließen-Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(24, 24, 32)}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Suchfeld (Search Bar)
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -30, 0, 36)
SearchBox.Position = UDim2.new(0, 15, 0, 52)
SearchBox.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
SearchBox.PlaceholderText = "Fahrzeug suchen..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(235, 235, 245)
SearchBox.TextSize = 11
SearchBox.Font = Enum.Font.Gotham
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = MainFrame

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 8)
SearchCorner.Parent = SearchBox

local SearchStroke = Instance.new("UIStroke")
SearchStroke.Color = Color3.fromRGB(45, 45, 55)
SearchStroke.Thickness = 1
SearchStroke.Parent = SearchBox

-- Scrollable List Container für die Fahrzeuge
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, -30, 1, -104)
ScrollContainer.Position = UDim2.new(0, 15, 0, 98)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.BorderSizePixel = 0
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollContainer.ScrollBarThickness = 3
ScrollContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ScrollContainer

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

-- Fahrzeuge dynamisch aus ScooterConfig laden
local spawnedButtons = {}
local vehicleNames = {}

local successConfig, scooterConfigMod = pcall(function()
    return require(ReplicatedStorage:WaitForChild("ScooterConfig"))
end)

if successConfig and scooterConfigMod and scooterConfigMod.Scooters then
    for scooterName, _ in pairs(scooterConfigMod.Scooters) do
        table.insert(vehicleNames, scooterName)
    end
    table.sort(vehicleNames)
else
    -- Fallback Liste falls Konfiguration nicht direkt lesbar ist
    vehicleNames = {
        "Ausom Gallop", "Ausom Apex Wingman", "Ausom L2 Max DM", "AusomL1", "Ausom F1 Max", 
        "Ausom L1 Pro", "Ausom Leopard", "Ausom G4", "Dualtron Togo", "Dualtron Storm", 
        "Kukirin S1 MAX", "Kukirin G2", "Kukirin G2 Master", "Kukirin G4", "Sur-Ron"
    }
end

-- Erstellt für jedes Fahrzeug einen Button mit dynamischem Spawner-Script
for _, vName in ipairs(vehicleNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    btn.Text = "   [ ⚡ ] " .. vName
    btn.TextColor3 = Color3.fromRGB(210, 210, 220)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = ScrollContainer

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(45, 45, 55)
    btnStroke.Thickness = 1
    btnStroke.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(26, 26, 36), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(18, 18, 24), TextColor3 = Color3.fromRGB(210, 210, 220)}):Play()
    end)

    -- Client-Spawn Logik (Ersetzt den Namen dynamisch per Klick)
    btn.MouseButton1Click:Connect(function()
        local eventsFolder = ReplicatedStorage:FindFirstChild("ScooterEvents")
        if eventsFolder then
            for _, remote in ipairs(eventsFolder:GetChildren()) do
                if remote:IsA("RemoteEvent") then
                    pcall(function()
                        remote:FireServer(vName)
                    end)
                end
            end
        end
    end)

    table.insert(spawnedButtons, {Button = btn, Name = string.lower(vName)})
end

-- Funktionierende Suchfilter-Logik
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(SearchBox.Text)
    for _, item in ipairs(spawnedButtons) do
        if query == "" or string.find(item.Name, query) then
            item.Button.Visible = true
        else
            item.Button.Visible = false
        end
    end
end)

-- UI per LeftControl ein/ausblenden
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

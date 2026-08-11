local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Altes GUI sauber bereinigen
if CoreGui:FindFirstChild("ScooterControllerUI") then
    CoreGui.ScooterControllerUI:Destroy()
end

-- Haupt GUI im Shadow Design erstellen (Design-Stil, kein Name)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScooterControllerUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame (Sleek Shadow Design mit Tiefe)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 580, 0, 380)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 55)
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

-- Topbar (Sleek Shadow Design Leiste)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

local TopbarFix = Instance.new("Frame")
TopbarFix.Size = UDim2.new(1, 0, 0, 10)
TopbarFix.Position = UDim2.new(0, 0, 1, -10)
TopbarFix.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
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
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SHADOW DESIGN // VEHICLE SYSTEM"
Title.TextColor3 = Color3.fromRGB(240, 240, 245)
Title.TextSize = 11
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Schließen-Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 25, 32)}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Sidebar (Linke Navigation)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- Content Container (Rechts)
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -150, 1, -40)
ContentContainer.Position = UDim2.new(0, 150, 0, 40)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Tabs verwalten
local Pages = {}
local function createPage(name)
    local page = Instance.new("Frame")
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = ContentContainer
    Pages[name] = page
    return page
end

local homePage = createPage("Home")
local spawnPage = createPage("Spawn")
local speedPage = createPage("Geschwindigkeit")
local settingsPage = createPage("Einstellungen")

local function switchTab(tabName)
    for name, page in pairs(Pages) do
        page.Visible = (name == tabName)
    end
end

-- Sidebar Buttons
local function createTabButton(text, yPos, tabName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 36)
    btn.Position = UDim2.new(0, 8, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(170, 170, 185)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = Sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 25, 32), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(18, 18, 22), TextColor3 = Color3.fromRGB(170, 170, 185)}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
end

createTabButton("   [ 🏠 ] HOME", 15, "Home")
createTabButton("   [ 🚗 ] SPAWN", 56, "Spawn")
createTabButton("   [ ⚡ ] GESCHWINDIGKEIT", 97, "Geschwindigkeit")
createTabButton("   [ ⚙️ ] EINSTELLUNGEN", 138, "Einstellungen")

switchTab("Home")

---------------------------------------------------
-- HOME TAB
---------------------------------------------------
local homeWelcome = Instance.new("TextLabel")
homeWelcome.Size = UDim2.new(1, -30, 0, 40)
homeWelcome.Position = UDim2.new(0, 15, 0, 20)
homeWelcome.BackgroundTransparency = 1
homeWelcome.Text = "Willkommen im Shadow Design System."
homeWelcome.TextColor3 = Color3.fromRGB(220, 220, 230)
homeWelcome.TextSize, homeWelcome.Font = 12, Enum.Font.GothamBold
homeWelcome.TextXAlignment = Enum.TextXAlignment.Left
homeWelcome.Parent = homePage

---------------------------------------------------
-- SPAWN TAB (Mit funktionierender Suchfunktion & allen Fahrzeugen)
---------------------------------------------------
local spawnTitle = Instance.new("TextLabel")
spawnTitle.Size = UDim2.new(1, -30, 0, 24)
spawnTitle.Position = UDim2.new(0, 15, 0, 12)
spawnTitle.BackgroundTransparency = 1
spawnTitle.Text = "[ 🚗 ] FAHRZEUG SPAWN LISTE (CLIENT)"
spawnTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
spawnTitle.TextSize = 11
spawnTitle.Font = Enum.Font.GothamBold
spawnTitle.TextXAlignment = Enum.TextXAlignment.Left
spawnTitle.Parent = spawnPage

-- Suchfeld (Search Bar)
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -30, 0, 32)
SearchBox.Position = UDim2.new(0, 15, 0, 42)
SearchBox.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
SearchBox.PlaceholderText = "Fahrzeug suchen..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(240, 240, 245)
SearchBox.TextSize = 11
SearchBox.Font = Enum.Font.Gotham
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = spawnPage

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 8)
SearchCorner.Parent = SearchBox

local SearchStroke = Instance.new("UIStroke")
SearchStroke.Color = Color3.fromRGB(50, 50, 65)
SearchStroke.Thickness = 1
SearchStroke.Parent = SearchBox

-- Scrollable List Container für die Fahrzeuge
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, -30, 1, -88)
ScrollContainer.Position = UDim2.new(0, 15, 0, 82)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.BorderSizePixel = 0
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollContainer.ScrollBarThickness = 3
ScrollContainer.Parent = spawnPage

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ScrollContainer

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

-- Vollständige Fahrzeugliste (alle client)
local vehicleList = {
    {Name = "DUALTRON TOGO (client)", Arg = "Dualtron Togo"},
    {Name = "SURON (client)", Arg = "kukurins1max"},
    {Name = "DUALTRON THUNDER (client)", Arg = "Dualtron Thunder"},
    {Name = "DUALTRON X (client)", Arg = "Dualtron X"},
    {Name = "XIAOMI M365 (client)", Arg = "Xiaomi M365"},
    {Name = "NINEBOT MAX (client)", Arg = "Ninebot Max"}
}

local spawnedButtons = {}

local function createSpawnItem(data)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    btn.Text = "   " .. data.Name
    btn.TextColor3 = Color3.fromRGB(230, 230, 240)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = ScrollContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 50, 65)
    stroke.Thickness = 1
    stroke.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(28, 28, 38)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 20, 26)}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        local eventsFolder = ReplicatedStorage:FindFirstChild("ScooterEvents")
        if eventsFolder then
            for _, remote in ipairs(eventsFolder:GetChildren()) do
                if remote:IsA("RemoteEvent") then
                    pcall(function()
                        remote:FireServer(data.Arg)
                    end)
                end
            end
        end
    end)

    table.insert(spawnedButtons, {Button = btn, Name = string.lower(data.Name)})
end

for _, v in ipairs(vehicleList) do
    createSpawnItem(v)
end

-- Suchfunktion Logik
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

---------------------------------------------------
-- GESCHWINDIGKEIT TAB
---------------------------------------------------
local speedVal = 100

local speedTitle = Instance.new("TextLabel")
speedTitle.Size = UDim2.new(1, -30, 0, 30)
speedTitle.Position = UDim2.new(0, 15, 0, 15)
speedTitle.BackgroundTransparency = 1
speedTitle.Text = "[ ⚡ ] GESCHWINDIGKEITS-REGLER"
speedTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
speedTitle.TextSize = 11
speedTitle.Font = Enum.Font.GothamBold
speedTitle.TextXAlignment = Enum.TextXAlignment.Left
speedTitle.Parent = speedPage

local speedDisplay = Instance.new("TextLabel")
speedDisplay.Size = UDim2.new(1, -30, 0, 20)
speedDisplay.Position = UDim2.new(0, 15, 0, 45)
speedDisplay.BackgroundTransparency = 1
speedDisplay.Text = "Aktueller Wert: 100 KM/H"
speedDisplay.TextColor3 = Color3.fromRGB(160, 160, 180)
speedDisplay.TextSize, speedDisplay.Font = 11, Enum.Font.Gotham
speedDisplay.TextXAlignment = Enum.TextXAlignment.Left
speedDisplay.Parent = speedPage

-- Slider
local SliderBg = Instance.new("Frame")
SliderBg.Size = UDim2.new(1, -30, 0, 8)
SliderBg.Position = UDim2.new(0, 15, 0, 85)
SliderBg.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
SliderBg.BorderSizePixel = 0
SliderBg.Parent = speedPage

local SliderBgCorner = Instance.new("UICorner")
SliderBgCorner.CornerRadius = UDim.new(1, 0)
SliderBgCorner.Parent = SliderBg

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(100 / 300, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(220, 220, 235)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBg

local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.CornerRadius = UDim.new(1, 0)
SliderFillCorner.Parent = SliderFill

local draggingSlider = false
local SliderButton = Instance.new("TextButton")
SliderButton.Size = UDim2.new(0, 16, 0, 16)
SliderButton.Position = UDim2.new(1, -8, 0.5, -8)
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderButton.Text = ""
SliderButton.Parent = SliderFill

local SliderBtnCorner = Instance.new("UICorner")
SliderBtnCorner.CornerRadius = UDim.new(1, 0)
SliderBtnCorner.Parent = SliderButton

SliderButton.MouseButton1Down:Connect(function()
    draggingSlider = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation().X
        local absPos = SliderBg.AbsolutePosition.X
        local absSize = SliderBg.AbsoluteSize.X
        local posVal = math.clamp((mousePos - absPos) / absSize, 0, 1)
        
        SliderFill.Size = UDim2.new(posVal, 0, 1, 0)
        speedVal = math.floor(posVal * 300)
        speedDisplay.Text = "Aktueller Wert: " .. speedVal .. " KM/H"
    end
end)

---------------------------------------------------
-- EINSTELLUNGEN TAB (Keybind Umschalter)
---------------------------------------------------
local bindTitle = Instance.new("TextLabel")
bindTitle.Size = UDim2.new(1, -30, 0, 30)
bindTitle.Position = UDim2.new(0, 15, 0, 15)
bindTitle.BackgroundTransparency = 1
bindTitle.Text = "[ ⚙️ ] GUI EIN/AUSBLENDEN TASTE"
bindTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
bindTitle.TextSize = 11
bindTitle.Font = Enum.Font.GothamBold
bindTitle.TextXAlignment = Enum.TextXAlignment.Left
bindTitle.Parent = settingsPage

local currentKey = Enum.KeyCode.LeftControl
local bindBtn = Instance.new("TextButton")
bindBtn.AnchorPoint = Vector2.new(0.5, 0)
bindBtn.Size = UDim2.new(0, 180, 0, 38)
bindBtn.Position = UDim2.new(0.5, 0, 0, 55)
bindBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
bindBtn.Text = "LeftControl"
bindBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
bindBtn.TextSize, bindBtn.Font = 11, Enum.Font.GothamBold
bindBtn.Parent = settingsPage

local bindCorner = Instance.new("UICorner")
bindCorner.CornerRadius = UDim.new(0, 8)
bindCorner.Parent = bindBtn

local bindStroke = Instance.new("UIStroke")
bindStroke.Color = Color3.fromRGB(50, 50, 65)
bindStroke.Thickness = 1
bindStroke.Parent = bindBtn

local bindingKey = false
bindBtn.MouseButton1Click:Connect(function()
    if bindingKey then return end
    bindingKey = true
    bindBtn.Text = "DRÜCKE TASTE..."
    bindBtn.TextColor3 = Color3.fromRGB(220, 180, 60)
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            currentKey = input.KeyCode
            bindBtn.Text = input.KeyCode.Name
            bindBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
            bindingKey = false
            connection:Disconnect()
        end
    end)
end)

UserInputService.InputBegan:Connect(function(input)
    if not bindingKey and input.KeyCode == currentKey then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

---------------------------------------------------
-- HIGH-SPEED MOTOR MOTORISIERUNG (Mit Physik & Schwerkraft-Schutz)
---------------------------------------------------
task.spawn(function()
    RunService.RenderStepped:Connect(function()
        local possibleNames = {
            "Dualtron Togo_OwnedBy_" .. player.Name,
            "kukurins1max_OwnedBy_" .. player.Name,
            "Dualtron Thunder_OwnedBy_" .. player.Name,
            "Dualtron X_OwnedBy_" .. player.Name,
            "Xiaomi M365_OwnedBy_" .. player.Name,
            "Ninebot Max_OwnedBy_" .. player.Name
        }
        
        local targetModel = nil
        for _, name in ipairs(possibleNames) do
            local found = workspace:FindFirstChild(name)
            if found then
                targetModel = found
                break
            end
        end
        
        if targetModel then
            local basePart = targetModel:FindFirstChild("BasePart") or targetModel.PrimaryPart or targetModel:FindFirstChildWhichIsA("BasePart")
            
            if basePart then
                pcall(function()
                    if basePart:GetNetworkOwner() ~= player then
                        basePart:SetNetworkOwner(player)
                    end
                end)
                
                local isConnectedToPlayer = false
                local character = player.Character
                if character then
                    for _, desc in ipairs(character:GetDescendants()) do
                        if desc:IsA("WeldConstraint") or desc:IsA("Weld") or desc:IsA("Motor6D") then
                            if (desc.Part0 and desc.Part0:IsDescendantOf(targetModel)) or (desc.Part1 and desc.Part1:IsDescendantOf(targetModel)) then
                                isConnectedToPlayer = true
                                break
                            end
                        end
                    end
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.SeatPart and humanoid.SeatPart:IsDescendantOf(targetModel) then
                        isConnectedToPlayer = true
                    end
                end
                
                if isConnectedToPlayer then
                    for _, desc in ipairs(targetModel:GetDescendants()) do
                        if desc:IsA("LinearVelocity") then
                            desc.MaxForce = 30000
                            if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then
                                local lookV = basePart.CFrame.LookVector
                                desc.VectorVelocity = Vector3.new(lookV.X * speedVal, desc.VectorVelocity.Y, lookV.Z * speedVal)
                            else
                                desc.VectorVelocity = Vector3.new(0, desc.VectorVelocity.Y, 0)
                            end
                        end
                    end
                end
            end
        end
    end)
end)

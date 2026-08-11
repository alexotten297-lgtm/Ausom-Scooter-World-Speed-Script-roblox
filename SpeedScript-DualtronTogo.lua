local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Altes GUI sauber bereinigen
if CoreGui:FindFirstChild("ScooterControlHub") then
    CoreGui.ScooterControlHub:Destroy()
end

-- Haupt GUI erstellen (Shadow Design Layout)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScooterControlHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame (Shadow Design Look)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 540, 0, 360)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 55)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Topbar (Fensterleiste im Shadow Design)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 16)
TopBarCorner.Parent = TopBar

local TopbarFix = Instance.new("Frame")
TopbarFix.Size = UDim2.new(1, 0, 0, 10)
TopbarFix.Position = UDim2.new(0, 0, 1, -10)
TopbarFix.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
TopbarFix.BorderSizePixel = 0
TopbarFix.Parent = TopBar

-- Windows-Style Drag & Drop Logik
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

-- Titel & Symbol
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "[ ⚡ ] VEHICLE CONTROL SYSTEM"
Title.TextColor3 = Color3.fromRGB(235, 235, 245)
Title.TextSize = 12
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- X-Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -36, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(60, 60, 75)
CloseStroke.Thickness = 1
CloseStroke.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(24, 24, 32)}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Sidebar (Linke Reiter)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- Inhaltsbereich rechts
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -150, 1, -42)
ContentContainer.Position = UDim2.new(0, 150, 0, 42)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Tabs erstellen
local Pages = {}
local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 3
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

-- Sidebar Buttons mit feinem Hover-Effekt
local function createTabButton(text, yPos, tabName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 38)
    btn.Position = UDim2.new(0, 8, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(190, 190, 205)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = Sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(40, 40, 52)
    stroke.Thickness = 1
    stroke.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(28, 28, 38), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 20, 26), TextColor3 = Color3.fromRGB(190, 190, 205)}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
end

createTabButton("   [ 🏠 ] HOME", 15, "Home")
createTabButton("   [ 🚗 ] SPAWN", 60, "Spawn")
createTabButton("   [ ⚡ ] GESCHWINDIGKEIT", 105, "Geschwindigkeit")
createTabButton("   [ ⚙️ ] EINSTELLUNGEN", 150, "Einstellungen")

switchTab("Home")

---------------------------------------------------
-- HOME TAB
---------------------------------------------------
local homeWelcome = Instance.new("TextLabel")
homeWelcome.Size = UDim2.new(1, -30, 0, 40)
homeWelcome.Position = UDim2.new(0, 15, 0, 20)
homeWelcome.BackgroundTransparency = 1
homeWelcome.Text = "Shadow Design Control Center aktiv."
homeWelcome.TextColor3 = Color3.fromRGB(210, 210, 220)
homeWelcome.TextSize, homeWelcome.Font = 12, Enum.Font.GothamBold
homeWelcome.TextXAlignment = Enum.TextXAlignment.Left
homeWelcome.Parent = homePage

---------------------------------------------------
-- SPAWN TAB (Mit allen Modellen & fehlerfreiem Bubble Pop-up)
---------------------------------------------------
local spawnTitle = Instance.new("TextLabel")
spawnTitle.Size = UDim2.new(1, -30, 0, 30)
spawnTitle.Position = UDim2.new(0, 15, 0, 15)
spawnTitle.BackgroundTransparency = 1
spawnTitle.Text = "[ 🚗 ] FAHRZEUG SPAWN LISTE (CLIENT)"
spawnTitle.TextColor3 = Color3.fromRGB(235, 235, 245)
spawnTitle.TextSize = 12
spawnTitle.Font = Enum.Font.GothamBold
spawnTitle.TextXAlignment = Enum.TextXAlignment.Left
spawnTitle.Parent = spawnPage

local function createSpawnButton(text, yPos, remoteArg)
    local spawnBtn = Instance.new("TextButton")
    spawnBtn.AnchorPoint = Vector2.new(0.5, 0)
    spawnBtn.Size = UDim2.new(0, 240, 0, 42)
    spawnBtn.Position = UDim2.new(0.5, 0, 0, yPos)
    spawnBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    spawnBtn.Text = text
    spawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    spawnBtn.TextSize = 11
    spawnBtn.Font = Enum.Font.GothamBold
    spawnBtn.Parent = spawnPage

    local spawnCorner = Instance.new("UICorner")
    spawnCorner.CornerRadius = UDim.new(0, 10)
    spawnCorner.Parent = spawnBtn

    local spawnStroke = Instance.new("UIStroke")
    spawnStroke.Color = Color3.fromRGB(70, 70, 90)
    spawnStroke.Thickness = 1.5
    spawnStroke.Parent = spawnBtn

    -- Stabiler Bubble-Pop-up-Effekt nach oben (zentriert skaliert)
    spawnBtn.MouseEnter:Connect(function()
        TweenService:Create(spawnBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 248, 0, 45)
        }):Play()
    end)
    spawnBtn.MouseLeave:Connect(function()
        TweenService:Create(spawnBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 240, 0, 42)
        }):Play()
    end)

    spawnBtn.MouseButton1Click:Connect(function()
        local eventsFolder = ReplicatedStorage:FindFirstChild("ScooterEvents")
        if eventsFolder then
            for _, remote in ipairs(eventsFolder:GetChildren()) do
                if remote:IsA("RemoteEvent") then
                    pcall(function()
                        remote:FireServer(remoteArg)
                    end)
                end
            end
        end
    end)
end

createSpawnButton("DUALTRON TOGO (client)", 55, "Dualtron Togo")
createSpawnButton("SURON (client)", 105, "kukurins1max")

---------------------------------------------------
-- GESCHWINDIGKEIT TAB (Regler & Tacho)
---------------------------------------------------
local speedVal = 100

local speedTitle = Instance.new("TextLabel")
speedTitle.Size = UDim2.new(1, -30, 0, 30)
speedTitle.Position = UDim2.new(0, 15, 0, 15)
speedTitle.BackgroundTransparency = 1
speedTitle.Text = "[ ⚡ ] GESCHWINDIGKEITS-REGLER"
speedTitle.TextColor3 = Color3.fromRGB(235, 235, 245)
speedTitle.TextSize = 12
speedTitle.Font = Enum.Font.GothamBold
speedTitle.TextXAlignment = Enum.TextXAlignment.Left
speedTitle.Parent = speedPage

local speedDisplay = Instance.new("TextLabel")
speedDisplay.Size = UDim2.new(1, -30, 0, 20)
speedDisplay.Position = UDim2.new(0, 15, 0, 45)
speedDisplay.BackgroundTransparency = 1
speedDisplay.Text = "Aktueller Wert: 100 KM/H"
speedDisplay.TextColor3 = Color3.fromRGB(150, 150, 170)
speedDisplay.TextSize, speedDisplay.Font = 11, Enum.Font.Gotham
speedDisplay.TextXAlignment = Enum.TextXAlignment.Left
speedDisplay.Parent = speedPage

-- Slider Leiste
local SliderBg = Instance.new("Frame")
SliderBg.Size = UDim2.new(1, -30, 0, 10)
SliderBg.Position = UDim2.new(0, 15, 0, 85)
SliderBg.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
SliderBg.BorderSizePixel = 0
SliderBg.Parent = speedPage

local SliderBgCorner = Instance.new("UICorner")
SliderBgCorner.CornerRadius = UDim.new(1, 0)
SliderBgCorner.Parent = SliderBg

local SliderBgStroke = Instance.new("UIStroke")
SliderBgStroke.Color = Color3.fromRGB(55, 55, 70)
SliderBgStroke.Thickness = 1
SliderBgStroke.Parent = SliderBg

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(100 / 300, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(235, 235, 245)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBg

local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.CornerRadius = UDim.new(1, 0)
SliderFillCorner.Parent = SliderFill

local draggingSlider = false
local SliderButton = Instance.new("TextButton")
SliderButton.Size = UDim2.new(0, 18, 0, 18)
SliderButton.Position = UDim2.new(1, -9, 0.5, -9)
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
bindTitle.TextColor3 = Color3.fromRGB(235, 235, 245)
bindTitle.TextSize = 12
bindTitle.Font = Enum.Font.GothamBold
bindTitle.TextXAlignment = Enum.TextXAlignment.Left
bindTitle.Parent = settingsPage

local currentKey = Enum.KeyCode.LeftControl
local bindBtn = Instance.new("TextButton")
bindBtn.AnchorPoint = Vector2.new(0.5, 0)
bindBtn.Size = UDim2.new(0, 190, 0, 40)
bindBtn.Position = UDim2.new(0.5, 0, 0, 55)
bindBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
bindBtn.Text = "LeftControl"
bindBtn.TextColor3 = Color3.fromRGB(235, 235, 245)
bindBtn.TextSize, bindBtn.Font = 11, Enum.Font.GothamBold
bindBtn.Parent = settingsPage

local bindCorner = Instance.new("UICorner")
bindCorner.CornerRadius = UDim.new(0, 10)
bindCorner.Parent = bindBtn

local bindStroke = Instance.new("UIStroke")
bindStroke.Color = Color3.fromRGB(70, 70, 90)
bindStroke.Thickness = 1.5
bindStroke.Parent = bindBtn

bindBtn.MouseEnter:Connect(function()
    TweenService:Create(bindBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(32, 32, 44)}):Play()
end)
bindBtn.MouseLeave:Connect(function()
    TweenService:Create(bindBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(22, 22, 30)}):Play()
end)

local bindingKey = false
bindBtn.MouseButton1Click:Connect(function()
    if bindingKey then return end
    bindingKey = true
    bindBtn.Text = "DRÜCKE EINE TASTE..."
    bindBtn.TextColor3 = Color3.fromRGB(220, 180, 60)
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            currentKey = input.KeyCode
            bindBtn.Text = input.KeyCode.Name
            bindBtn.TextColor3 = Color3.fromRGB(235, 235, 245)
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
-- STABILER HIGH-SPEED MOTOR (Mit Schwerkraft-Schutz für alle Modelle)
---------------------------------------------------
task.spawn(function()
    RunService.RenderStepped:Connect(function()
        local possibleNames = {
            "Dualtron Togo_OwnedBy_" .. player.Name,
            "kukurins1max_OwnedBy_" .. player.Name
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
                
                -- PRÜFUNG: Sitzt oder steht der Spieler auf dem Fahrzeug?
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
                
                -- Turbo greift nur beim Aufsitzen, behält die Y-Schwerkraft exakt bei
                if isConnectedToPlayer then
                    for _, desc in ipairs(targetModel:GetDescendants()) do
                        if desc:IsA("LinearVelocity") then
                            desc.MaxForce = 25000
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

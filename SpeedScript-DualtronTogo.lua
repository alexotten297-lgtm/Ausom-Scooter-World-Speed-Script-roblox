local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Altes GUI sauber bereinigen
if CoreGui:FindFirstChild("DualtronShadowHub") then
    CoreGui.DualtronShadowHub:Destroy()
end

-- Haupt GUI erstellen
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DualtronShadowHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame (Shadow White / Bubble Look)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(50, 50, 65)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Topbar (Fensterleiste im OS-Style)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 16)
TopBarCorner.Parent = TopBar

local TopbarFix = Instance.new("Frame")
TopbarFix.Size = UDim2.new(1, 0, 0, 10)
TopbarFix.Position = UDim2.new(0, 0, 1, -10)
TopbarFix.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
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

-- Titel & Symbol statt Emojis
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "[ ⚡ ] DUALTRON TOGO // SHADOW HUB"
Title.TextColor3 = Color3.fromRGB(240, 240, 245)
Title.TextSize = 12
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Hochwertiger X-Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -36, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(70, 70, 90)
CloseStroke.Thickness = 1
CloseStroke.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(26, 26, 34)}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Sidebar (Linke Reiter)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 145, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 21)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- Inhaltsbereich rechts
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -145, 1, -42)
ContentContainer.Position = UDim2.new(0, 145, 0, 42)
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
local speedPage = createPage("Geschwindigkeit")
local settingsPage = createPage("Einstellungen")

local function switchTab(tabName)
    for name, page in pairs(Pages) do
        page.Visible = (name == tabName)
    end
end

-- Sidebar Buttons mit Bubble & Hover-Effekt (Ohne Emojis)
local function createTabButton(text, yPos, tabName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 38)
    btn.Position = UDim2.new(0, 8, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 29)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 215)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = Sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 45, 60)
    stroke.Thickness = 1
    stroke.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(32, 32, 44), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(22, 22, 29), TextColor3 = Color3.fromRGB(200, 200, 215)}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
end

createTabButton("   HOME", 15, "Home")
createTabButton("   GESCHWINDIGKEIT", 60, "Geschwindigkeit")
createTabButton("   EINSTELLUNGEN", 105, "Einstellungen")

switchTab("Home")

---------------------------------------------------
-- HOME TAB (Spawn Button mit Bubble Pop-up)
---------------------------------------------------
local spawnBtn = Instance.new("TextButton")
spawnBtn.Size = UDim2.new(0, 240, 0, 46)
spawnBtn.Position = UDim2.new(0.5, -120, 0, 50)
spawnBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
spawnBtn.Text = "DUALTRON TOGO SPAWNEN"
spawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnBtn.TextSize = 12
spawnBtn.Font = Enum.Font.GothamBold
spawnBtn.Parent = homePage

local spawnCorner = Instance.new("UICorner")
spawnCorner.CornerRadius = UDim.new(0, 12)
spawnCorner.Parent = spawnBtn

local spawnStroke = Instance.new("UIStroke")
spawnStroke.Color = Color3.fromRGB(80, 80, 105)
spawnStroke.Thickness = 1.5
spawnStroke.Parent = spawnBtn

spawnBtn.MouseEnter:Connect(function()
    TweenService:Create(spawnBtn, TweenInfo.new(0.15), {Size = UDim2.new(0, 246, 0, 49), Position = UDim2.new(0.5, -123, 0, 485)}):Play() -- Pop-up Effekt
end)
spawnBtn.MouseLeave:Connect(function()
    TweenService:Create(spawnBtn, TweenInfo.new(0.15), {Size = UDim2.new(0, 240, 0, 46), Position = UDim2.new(0.5, -120, 0, 50)}):Play()
end)

spawnBtn.MouseButton1Click:Connect(function()
    local eventsFolder = ReplicatedStorage:FindFirstChild("ScooterEvents")
    if eventsFolder then
        for _, remote in ipairs(eventsFolder:GetChildren()) do
            if remote:IsA("RemoteEvent") then
                remote:FireServer("Dualtron Togo")
            end
        end
    end
end)

---------------------------------------------------
-- GESCHWINDIGKEIT TAB (Regler & Tacho-Symbole)
---------------------------------------------------
local speedVal = 350

local speedTitle = Instance.new("TextLabel")
speedTitle.Size = UDim2.new(1, -30, 0, 30)
speedTitle.Position = UDim2.new(0, 15, 0, 15)
speedTitle.BackgroundTransparency = 1
speedTitle.Text = "[ TACHO ] GESCHWINDIGKEITS-REGLER"
speedTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
speedTitle.TextSize = 12
speedTitle.Font = Enum.Font.GothamBold
speedTitle.TextXAlignment = Enum.TextXAlignment.Left
speedTitle.Parent = speedPage

local speedDisplay = Instance.new("TextLabel")
speedDisplay.Size = UDim2.new(1, -30, 0, 20)
speedDisplay.Position = UDim2.new(0, 15, 0, 45)
speedDisplay.BackgroundTransparency = 1
speedDisplay.Text = "Aktueller Wert: 350 KM/H"
speedDisplay.TextColor3 = Color3.fromRGB(150, 150, 170)
speedDisplay.TextSize, speedDisplay.Font = 12, Enum.Font.Gotham
speedDisplay.TextXAlignment = Enum.TextXAlignment.Left
speedDisplay.Parent = speedPage

-- Slider Leiste
local SliderBg = Instance.new("Frame")
SliderBg.Size = UDim2.new(1, -30, 0, 10)
SliderBg.Position = UDim2.new(0, 15, 0, 85)
SliderBg.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
SliderBg.BorderSizePixel = 0
SliderBg.Parent = speedPage

local SliderBgCorner = Instance.new("UICorner")
SliderBgCorner.CornerRadius = UDim.new(1, 0)
SliderBgCorner.Parent = SliderBg

local SliderBgStroke = Instance.new("UIStroke")
SliderBgStroke.Color = Color3.fromRGB(60, 60, 75)
SliderBgStroke.Thickness = 1
SliderBgStroke.Parent = SliderBg

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(350 / 800, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(240, 240, 250)
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
        speedVal = math.floor(posVal * 800)
        speedDisplay.Text = "Aktueller Wert: " .. speedVal .. " KM/H"
    end
end)

---------------------------------------------------
-- EINSTELLUNGEN TAB (T Keybind Umschalter mit Pop-up)
---------------------------------------------------
local bindTitle = Instance.new("TextLabel")
bindTitle.Size = UDim2.new(1, -30, 0, 30)
bindTitle.Position = UDim2.new(0, 15, 0, 15)
bindTitle.BackgroundTransparency = 1
bindTitle.Text = "[ CONFIG ] GUI EIN/AUSBLENDEN TASTE"
bindTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
bindTitle.TextSize = 12
bindTitle.Font = Enum.Font.GothamBold
bindTitle.TextXAlignment = Enum.TextXAlignment.Left
bindTitle.Parent = settingsPage

local currentKey = Enum.KeyCode.LeftControl
local bindBtn = Instance.new("TextButton")
bindBtn.Size = UDim2.new(0, 190, 0, 40)
bindBtn.Position = UDim2.new(0, 15, 0, 50)
bindBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
bindBtn.Text = "LeftControl"
bindBtn.TextColor3 = Color3.fromRGB(240, 240, 250)
bindBtn.TextSize, bindBtn.Font = 12, Enum.Font.GothamBold
bindBtn.Parent = settingsPage

local bindCorner = Instance.new("UICorner")
bindCorner.CornerRadius = UDim.new(0, 10)
bindCorner.Parent = bindBtn

local bindStroke = Instance.new("UIStroke")
bindStroke.Color = Color3.fromRGB(80, 80, 105)
bindStroke.Thickness = 1.5
bindStroke.Parent = bindBtn

bindBtn.MouseEnter:Connect(function()
    TweenService:Create(bindBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 48)}):Play()
end)
bindBtn.MouseLeave:Connect(function()
    TweenService:Create(bindBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(24, 24, 32)}):Play()
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
            bindBtn.TextColor3 = Color3.fromRGB(240, 240, 250)
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
-- FINALER HIGH-SPEED MOTOR (Mit Schwerkraft-Schutz)
---------------------------------------------------
task.spawn(function()
    RunService.RenderStepped:Connect(function(dt)
        local expectedName = "Dualtron Togo_OwnedBy_" .. player.Name
        local targetModel = workspace:FindFirstChild(expectedName)
        
        if targetModel then
            local basePart = targetModel:FindFirstChild("BasePart") or targetModel.PrimaryPart or targetModel:FindFirstChildWhichIsA("BasePart")
            
            if basePart then
                -- Netzwerk-Autorität erzwingen
                pcall(function()
                    if basePart:GetNetworkOwner() ~= player then
                        basePart:SetNetworkOwner(player)
                    end
                end)
                
                -- PRÜFUNG: Sitzt oder steht der Spieler auf dem Roller?
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
                
                -- Der Turbo feuert NUR, wenn der Spieler drauf sitzt
                if isConnectedToPlayer then
                    for _, desc in ipairs(targetModel:GetDescendants()) do
                        if desc:IsA("LinearVelocity") then
                            desc.MaxForce = math.huge
                            local vel = desc.VectorVelocity
                            if vel.Magnitude > 0.1 then
                                desc.VectorVelocity = vel.Unit * speedVal
                            end
                        elseif desc:IsA("VectorForce") then
                            desc.Force = desc.Force * 20
                        end
                    end
                    
                    -- Fester Boden-Grip: Erhält exakt die vertikale Y-Geschwindigkeit (Schwerkraft), kein Aus-der-Map-Fliegen!
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then
                        local currentVel = basePart.AssemblyLinearVelocity
                        local lookV = basePart.CFrame.LookVector
                        basePart.AssemblyLinearVelocity = Vector3.new(lookV.X * speedVal, currentVel.Y, lookV.Z * speedVal)
                    end
                end
            end
        end
    end)
end)

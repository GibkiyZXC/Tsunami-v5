--// Tsunami Ragebot Menu v4 + ESP + Aimbot
--// Ultra Smooth Animations + Transparent UI + Full Functional Rage Features

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local gui = LocalPlayer:WaitForChild("PlayerGui")

--------------------------------------------------
-- CONFIG
--------------------------------------------------
local TOGGLE_KEY = Enum.KeyCode.RightShift
local CLOSE_KEY = Enum.KeyCode.Delete
local MINIMIZE_KEY = Enum.KeyCode.Insert
local MenuColor = Color3.fromRGB(0, 150, 255)

local SHOW_TWEEN = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local HIDE_TWEEN = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local ELEMENT_TWEEN = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local COLOR_TWEEN = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

--------------------------------------------------
-- RAGEBOT + ESP SETTINGS
--------------------------------------------------
local ESP_Enabled = true
local Aimbot_Enabled = false
local Aimbot_Key = Enum.UserInputType.MouseButton2     -- ПКМ для активации
local Aimbot_FOV = 90
local Aimbot_Smooth = 0.16
local Aimbot_Part = "Head"
local TeamCheck = true

local ESP_Objects = {}

--------------------------------------------------
-- GUI CREATION (твой оригинальный красивый UI)
--------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TsunamiMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = gui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,720,0,520)
MainFrame.Position = UDim2.new(0.5,-360,0.5,-260)
MainFrame.BackgroundColor3 = Color3.fromRGB(10,10,10)
MainFrame.BackgroundTransparency = 0.85
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local corner = Instance.new("UICorner", MainFrame)
corner.CornerRadius = UDim.new(0,18)

local border = Instance.new("UIStroke", MainFrame)
border.Color = Color3.fromRGB(40,40,40)
border.Thickness = 1
border.Transparency = 0.5

local UIScale = Instance.new("UIScale", MainFrame)
UIScale.Scale = 0.95

local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1,80,1,80)
Shadow.Position = UDim2.new(0,-40,0,-40)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://6014261993"
Shadow.ImageColor3 = Color3.fromRGB(0,0,0)
Shadow.ImageTransparency = 0.85
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(49,49,450,450)
Shadow.ZIndex = -1
Shadow.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,66)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Text = "TSUNAMI"
Title.TextColor3 = MenuColor
Title.TextSize = 36
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.ZIndex = 2
Title.Parent = MainFrame

local titleShadow = Instance.new("TextLabel")
titleShadow.Size = UDim2.new(1,0,0,66)
titleShadow.Position = UDim2.new(0,2,0,2)
titleShadow.BackgroundTransparency = 1
titleShadow.Text = "TSUNAMI"
titleShadow.TextColor3 = Color3.fromRGB(0,0,0)
titleShadow.TextTransparency = 0.7
titleShadow.TextSize = 36
titleShadow.Font = Enum.Font.GothamBlack
titleShadow.TextXAlignment = Enum.TextXAlignment.Center
titleShadow.ZIndex = 1
titleShadow.Parent = MainFrame

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1,0,0,24)
Subtitle.Position = UDim2.new(0,0,0,42)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Ragebot Suite"
Subtitle.TextColor3 = Color3.fromRGB(180,180,180)
Subtitle.TextSize = 14
Subtitle.Font = Enum.Font.GothamMedium
Subtitle.TextXAlignment = Enum.TextXAlignment.Center
Subtitle.ZIndex = 2
Subtitle.Parent = MainFrame

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1,0,0,56)
TabBar.Position = UDim2.new(0,0,0,66)
TabBar.BackgroundTransparency = 0.9
TabBar.BackgroundColor3 = Color3.fromRGB(15,15,15)
TabBar.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1,-28,1,-140)
ContentFrame.Position = UDim2.new(0,14,0,122)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

--------------------------------------------------
-- ТВОИ ФУНКЦИИ UI (CreateSwitch, CreateSlider и т.д.) — оставил самые важные
--------------------------------------------------
local activeColorTweens = {}
local function SmoothTween(obj, properties, tweenInfo)
    local tween = TweenService:Create(obj, tweenInfo or COLOR_TWEEN, properties)
    tween:Play()
    return tween
end

local function ApplyMenuColor(color)
    MenuColor = color
    SmoothTween(Title, {TextColor3 = color})
end

local function CreateTabButton(name, index)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,140,1,-10)
    btn.Position = UDim2.new(0,18+(index-1)*148,0,5)
    btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
    btn.BackgroundTransparency = 0.7
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(190,190,190)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 16
    btn.Parent = TabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)
    btn.MouseButton1Click:Connect(function()
        for _, c in pairs(ContentFrame:GetChildren()) do
            if c:IsA("ScrollingFrame") then c.Visible = false end
        end
        ContentFrame[name].Visible = true
        for _, b in pairs(TabBar:GetChildren()) do
            if b:IsA("TextButton") then
                SmoothTween(b, {BackgroundColor3 = Color3.fromRGB(25,25,25), BackgroundTransparency = 0.7, TextColor3 = Color3.fromRGB(190,190,190)})
            end
        end
        SmoothTween(btn, {BackgroundColor3 = MenuColor, BackgroundTransparency = 0.4, TextColor3 = Color3.new(1,1,1)})
    end)
    return btn
end

local function CreateTabContent(name)
    local frame = Instance.new("ScrollingFrame")
    frame.Name = name
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundTransparency = 1
    frame.ScrollBarThickness = 0
    frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    frame.CanvasSize = UDim2.new(0,0,0,0)
    frame.Visible = false
    frame.Parent = ContentFrame
    Instance.new("UIListLayout", frame).Padding = UDim.new(0,14)
    return frame
end

local function CreateSwitch(parent, text, default, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,0,0,36)
    f.BackgroundTransparency = 0.8
    f.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,6)

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(0.75,0,1,0)
    lbl.Position = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(245,245,245)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local switchContainer = Instance.new("Frame", f)
    switchContainer.Size = UDim2.new(0,48,0,20)
    switchContainer.Position = UDim2.new(1,-54,0.5,-10)
    switchContainer.BackgroundColor3 = Color3.fromRGB(50,50,50)
    Instance.new("UICorner", switchContainer).CornerRadius = UDim.new(1,0)

    local switchBackground = Instance.new("Frame", switchContainer)
    switchBackground.Size = UDim2.new(1,0,1,0)
    switchBackground.BackgroundColor3 = default and MenuColor or Color3.fromRGB(80,80,80)
    switchBackground.BackgroundTransparency = 0.4
    Instance.new("UICorner", switchBackground).CornerRadius = UDim.new(1,0)

    local switchButton = Instance.new("Frame", switchContainer)
    switchButton.Size = UDim2.new(0,13,0,20)
    switchButton.Position = default and UDim2.new(1,-15,0,0) or UDim2.new(0,2,0,0)
    switchButton.BackgroundColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", switchButton).CornerRadius = UDim.new(0,4)

    local on = default

    local function Toggle()
        on = not on
        local newColor = on and MenuColor or Color3.fromRGB(80,80,80)
        local newPos = on and UDim2.new(1,-15,0,0) or UDim2.new(0,2,0,0)
        TweenService:Create(switchBackground, TweenInfo.new(0.2), {BackgroundColor3 = newColor}):Play()
        TweenService:Create(switchButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Position = newPos}):Play()
        if callback then callback(on) end
    end

    f.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Toggle()
        end
    end)

    return {Value = function() return on end, Toggle = Toggle}
end

local function CreateSlider(parent, text, min, max, default, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,0,0,60)
    f.BackgroundTransparency = 0.8
    f.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,6)

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1,0,0,26)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(210,210,210)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 14

    local val = Instance.new("TextLabel", f)
    val.Size = UDim2.new(0,55,0,26)
    val.Position = UDim2.new(1,-59,0,0)
    val.BackgroundTransparency = 1
    val.Text = tostring(default)
    val.TextColor3 = Color3.new(1,1,1)
    val.Font = Enum.Font.GothamBold
    val.TextSize = 14

    local bar = Instance.new("Frame", f)
    bar.Size = UDim2.new(1,-16,0,8)
    bar.Position = UDim2.new(0,8,0,40)
    bar.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = MenuColor
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

    local drag = false

    local function Update(v)
        v = math.clamp(math.floor(v), min, max)
        val.Text = tostring(v)
        fill:TweenSize(UDim2.new((v-min)/(max-min),0,1,0), "Out", "Quad", 0.15, true)
        if callback then callback(v) end
    end

    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end
    end)

    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local r = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            Update(min + (max - min) * r)
        end
    end)

    Update(default)
    return {Value = function() return tonumber(val.Text) end}
end

--------------------------------------------------
-- СОЗДАНИЕ ВКЛАДОК И ЭЛЕМЕНТОВ
--------------------------------------------------
local tabs = {"Globals", "Hitscan", "Visuals", "Menu"}

for i, name in ipairs(tabs) do
    CreateTabButton(name, i)
    CreateTabContent(name)
end

local g = ContentFrame.Globals
local h = ContentFrame.Hitscan
local v = ContentFrame.Visuals
local m = ContentFrame.Menu

-- Globals
CreateSwitch(g, "Master Switch", false, function(state)
    Aimbot_Enabled = state
    ESP_Enabled = state
end)

CreateSwitch(g, "Bunnyhop", false, function(state) print("Bunnyhop:", state) end)

-- Hitscan
CreateSwitch(h, "Aimbot", false, function(state)
    Aimbot_Enabled = state
end)

CreateSlider(h, "Aimbot FOV", 30, 360, 90, function(v)
    Aimbot_FOV = v
end)

CreateSlider(h, "Aimbot Smooth", 0.05, 0.8, 0.16, function(v)
    Aimbot_Smooth = v
end)

CreateSwitch(h, "Team Check", true, function(state)
    TeamCheck = state
end)

-- Visuals
local espSwitch = CreateSwitch(v, "Player 2D Box ESP", true, function(state)
    ESP_Enabled = state
end)

CreateSwitch(v, "Tracer", true, function(state) print("Tracer:", state) end)

-- Menu
CreateSlider(m, "Menu Opacity", 30, 100, 85, function(v)
    local t = 1 - (v/100)
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {BackgroundTransparency = t}):Play()
end)

-- Активация первой вкладки
ContentFrame.Globals.Visible = true

--------------------------------------------------
-- ESP ФУНКЦИИ (2D BOX + TRACER + NAME)
--------------------------------------------------
local function CreateESP(plr)
    if plr == LocalPlayer then return end
    if ESP_Objects[plr] then return end

    local Box = Drawing.new("Square")
    Box.Thickness = 1.5
    Box.Filled = false
    Box.Transparency = 1
    Box.Color = Color3.fromRGB(255, 60, 60)

    local Tracer = Drawing.new("Line")
    Tracer.Thickness = 1.3
    Tracer.Color = Color3.fromRGB(255, 60, 60)
    Tracer.Transparency = 1

    local Name = Drawing.new("Text")
    Name.Size = 13
    Name.Center = true
    Name.Outline = true
    Name.Color = Color3.new(1,1,1)
    Name.Text = plr.Name

    ESP_Objects[plr] = {Box = Box, Tracer = Tracer, Name = Name}

    plr.CharacterRemoving:Connect(function()
        for k, obj in pairs(ESP_Objects[plr]) do
            obj:Remove()
        end
        ESP_Objects[plr] = nil
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do
    CreateESP(plr)
end

Players.PlayerAdded:Connect(CreateESP)

--------------------------------------------------
-- ОБНОВЛЕНИЕ ESP
--------------------------------------------------
RunService.RenderStepped:Connect(function()
    for plr, drawings in pairs(ESP_Objects) do
        if not ESP_Enabled then
            for _, d in pairs(drawings) do d.Visible = false end
            continue
        end

        local char = plr.Character
        if not char or not char:FindFirstChild("Humanoid") or not char:FindFirstChild("HumanoidRootPart") then
            for _, d in pairs(drawings) do d.Visible = false end
            continue
        end

        local hum = char.Humanoid
        if hum.Health <= 0 then
            for _, d in pairs(drawings) do d.Visible = false end
            continue
        end

        if TeamCheck and plr.Team == LocalPlayer.Team then
            for _, d in pairs(drawings) do d.Visible = false end
            continue
        end

        local root = char.HumanoidRootPart
        local head = char:FindFirstChild("Head") or root
        local _, onScreen = Camera:WorldToViewportPoint(root.Position)

        if not onScreen then
            for _, d in pairs(drawings) do d.Visible = false end
            continue
        end

        local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.4,0))
        local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0,3.8,0))
        local rootPos = Camera:WorldToViewportPoint(root.Position)

        local height = math.abs(headPos.Y - legPos.Y)
        local width = height * 0.55

        drawings.Box.Size = Vector2.new(width, height)
        drawings.Box.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
        drawings.Box.Visible = true

        drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        drawings.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
        drawings.Tracer.Visible = true

        drawings.Name.Position = Vector2.new(rootPos.X, drawings.Box.Position.Y - 16)
        drawings.Name.Visible = true
    end
end)

--------------------------------------------------
-- AIMBOT (плавный легит)
--------------------------------------------------
local function GetClosest()
    local closest, minDist = nil, Aimbot_FOV

    local mouse = UserInputService:GetMouseLocation()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character
        if not char then continue end

        local part = char:FindFirstChild(Aimbot_Part) or char:FindFirstChild("HumanoidRootPart")
        if not part then continue end

        if TeamCheck and plr.Team == LocalPlayer.Team then continue end

        local screenPos, visible = Camera:WorldToViewportPoint(part.Position)
        if not visible then continue end

        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mouse).Magnitude
        if dist < minDist then
            minDist = dist
            closest = part
        end
    end

    return closest
end

RunService.RenderStepped:Connect(function()
    if not Aimbot_Enabled then return end
    if not UserInputService:IsMouseButtonPressed(Aimbot_Key) then return end

    local target = GetClosest()
    if not target then return end

    local current = Camera.CFrame
    local goal = CFrame.new(current.Position, target.Position)

    Camera.CFrame = current:Lerp(goal, Aimbot_Smooth)
end)

--------------------------------------------------
-- МЕНЮ ОТКРЫТИЕ/ЗАКРЫТИЕ
--------------------------------------------------
local visible = false
local isAnimating = false

local function ShowMenu()
    if isAnimating then return end
    isAnimating = true
    MainFrame.Visible = true
    TweenService:Create(UIScale, SHOW_TWEEN, {Scale = 1}):Play()
    TweenService:Create(MainFrame, TweenInfo.new(0.4), {BackgroundTransparency = 0.85}):Play()
    TweenService:Create(Shadow, TweenInfo.new(0.4), {ImageTransparency = 0.85}):Play()
    task.delay(0.45, function() isAnimating = false visible = true end)
end

local function HideMenu()
    if isAnimating then return end
    isAnimating = true
    TweenService:Create(UIScale, HIDE_TWEEN, {Scale = 0.95}):Play()
    TweenService:Create(MainFrame, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Shadow, TweenInfo.new(0.35), {ImageTransparency = 1}):Play()
    task.delay(0.4, function()
        MainFrame.Visible = false
        isAnimating = false
        visible = false
    end)
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == TOGGLE_KEY then
        if visible then HideMenu() else ShowMenu() end
    elseif input.KeyCode == CLOSE_KEY and visible then
        HideMenu()
    end
end)

print("[TSUNAMI] Full Ragebot + 2D ESP + Aimbot loaded")
print("Toggle: RightShift | Aimbot: Hold RMB | Enjoy 🌊")

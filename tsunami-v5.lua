local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

--------------------------------------------------
-- CONFIG
--------------------------------------------------
local TOGGLE_KEY = Enum.KeyCode.RightShift
local CLOSE_KEY = Enum.KeyCode.Delete
local MINIMIZE_KEY = Enum.KeyCode.Insert
local MenuColor = Color3.fromRGB(0, 150, 255)

local SHOW_TWEEN = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
local HIDE_TWEEN = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0)
local ELEMENT_TWEEN = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
local COLOR_TWEEN = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

--------------------------------------------------
-- GUI
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

--------------------------------------------------
-- ТЕНЬ
--------------------------------------------------
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

--------------------------------------------------
-- ЗАГОЛОВОК
--------------------------------------------------
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

local ControlButtons = Instance.new("Frame")
ControlButtons.Size = UDim2.new(0, 80, 0, 30)
ControlButtons.Position = UDim2.new(1, -90, 0, 18)
ControlButtons.BackgroundTransparency = 1
ControlButtons.Parent = Title

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(0, 0, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinimizeButton.BackgroundTransparency = 0.7
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 20
MinimizeButton.Parent = ControlButtons

local MinimizeCorner = Instance.new("UICorner", MinimizeButton)
MinimizeCorner.CornerRadius = UDim.new(0, 8)

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CloseButton.BackgroundTransparency = 0.7
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.Parent = ControlButtons

local CloseCorner = Instance.new("UICorner", CloseButton)
CloseCorner.CornerRadius = UDim.new(0, 8)

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

--------------------------------------------------
-- TAB BAR
--------------------------------------------------
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1,0,0,56)
TabBar.Position = UDim2.new(0,0,0,66)
TabBar.BackgroundTransparency = 0.9
TabBar.BackgroundColor3 = Color3.fromRGB(15,15,15)
TabBar.Parent = MainFrame

local tabBarStroke = Instance.new("UIStroke", TabBar)
tabBarStroke.Color = Color3.fromRGB(40,40,40)
tabBarStroke.Thickness = 1
tabBarStroke.Transparency = 0.7

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1,-28,1,-140)
ContentFrame.Position = UDim2.new(0,14,0,122)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

--------------------------------------------------
-- ВКЛАДКИ
--------------------------------------------------
local tabs = {"Globals", "Hitscan", "Visuals", "Menu"}
local tabButtons = {}
local tabContents = {}

-- Создание вкладок
for i, tabName in ipairs(tabs) do
    -- Кнопка вкладки
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,140,1,-10)
    btn.Position = UDim2.new(0,18+(i-1)*148,0,5)
    btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
    btn.BackgroundTransparency = 0.7
    btn.BorderSizePixel = 0
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(190,190,190)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 16
    btn.Parent = TabBar
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0,12)
    
    -- Контент вкладки
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1,0,1,0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 0
    contentFrame.ScrollBarImageTransparency = 1
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentFrame.CanvasSize = UDim2.new(0,0,0,0)
    contentFrame.Visible = i == 1
    contentFrame.Parent = ContentFrame
    
    local list = Instance.new("UIListLayout", contentFrame)
    list.Padding = UDim.new(0,14)
    
    -- Сохраняем ссылки
    tabButtons[tabName] = btn
    tabContents[tabName] = contentFrame
    
    -- Обработчик клика
    btn.MouseButton1Click:Connect(function()
        for _, content in pairs(tabContents) do
            content.Visible = false
        end
        for _, button in pairs(tabButtons) do
            button.BackgroundColor3 = Color3.fromRGB(25,25,25)
            button.TextColor3 = Color3.fromRGB(190,190,190)
        end
        
        contentFrame.Visible = true
        btn.BackgroundColor3 = MenuColor
        btn.BackgroundTransparency = 0.4
        btn.TextColor3 = Color3.new(1,1,1)
    end)
end

-- Активация первой вкладки
tabButtons.Globals.BackgroundColor3 = MenuColor
tabButtons.Globals.BackgroundTransparency = 0.4
tabButtons.Globals.TextColor3 = Color3.new(1,1,1)

--------------------------------------------------
-- БАЗОВАЯ ФУНКЦИОНАЛЬНОСТЬ
--------------------------------------------------
local visible = false
local isAnimating = false
local minimized = false

-- Показ меню
local function ShowMenu()
    if isAnimating then return end
    isAnimating = true
    
    MainFrame.Visible = true
    local scaleTween = TweenService:Create(UIScale, SHOW_TWEEN, {Scale = 1})
    scaleTween:Play()
    
    scaleTween.Completed:Connect(function()
        isAnimating = false
        visible = true
    end)
end

-- Скрытие меню
local function HideMenu()
    if isAnimating then return end
    isAnimating = true
    
    local scaleTween = TweenService:Create(UIScale, HIDE_TWEEN, {Scale = 0.95})
    scaleTween:Play()
    
    scaleTween.Completed:Connect(function()
        MainFrame.Visible = false
        isAnimating = false
        visible = false
    end)
end

-- Сворачивание/разворачивание
local function ToggleMinimize()
    if isAnimating or not visible then return end
    isAnimating = true
    
    minimized = not minimized
    
    if minimized then
        local sizeTween = TweenService:Create(MainFrame,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0,720,0,100)}
        )
        TabBar.Visible = false
        ContentFrame.Visible = false
        sizeTween:Play()
    else
        local sizeTween = TweenService:Create(MainFrame,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0,720,0,520)}
        )
        sizeTween:Play()
        sizeTween.Completed:Connect(function()
            TabBar.Visible = true
            ContentFrame.Visible = true
            isAnimating = false
        end)
    end
end

-- Обработчики кнопок
MinimizeButton.MouseButton1Click:Connect(ToggleMinimize)
CloseButton.MouseButton1Click:Connect(HideMenu)

-- Обработчики клавиш
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    
    if input.KeyCode == TOGGLE_KEY then
        if visible then 
            HideMenu() 
        else 
            ShowMenu() 
        end
    elseif input.KeyCode == MINIMIZE_KEY and visible then
        ToggleMinimize()
    elseif input.KeyCode == CLOSE_KEY and visible then
        HideMenu()
    end
end)

-- Анимации при наведении
MinimizeButton.MouseEnter:Connect(function()
    TweenService:Create(MinimizeButton, ELEMENT_TWEEN, {
        BackgroundTransparency = 0.5,
        TextColor3 = Color3.new(1,1,1)
    }):Play()
end)

MinimizeButton.MouseLeave:Connect(function()
    TweenService:Create(MinimizeButton, ELEMENT_TWEEN, {
        BackgroundTransparency = 0.7,
        TextColor3 = Color3.fromRGB(200,200,200)
    }):Play()
end)

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, ELEMENT_TWEEN, {
        BackgroundColor3 = Color3.fromRGB(255,50,50),
        BackgroundTransparency = 0.3,
        TextColor3 = Color3.new(1,1,1)
    }):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, ELEMENT_TWEEN, {
        BackgroundColor3 = Color3.fromRGB(40,40,40),
        BackgroundTransparency = 0.7,
        TextColor3 = Color3.fromRGB(200,200,200)
    }):Play()
end)

-- Анимации для кнопок вкладок
for _, btn in pairs(tabButtons) do
    btn.MouseEnter:Connect(function()
        if not tabContents[btn.Text].Visible then
            TweenService:Create(btn, ELEMENT_TWEEN, {
                BackgroundTransparency = 0.6,
                TextColor3 = Color3.fromRGB(220,220,220)
            }):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if not tabContents[btn.Text].Visible then
            TweenService:Create(btn, ELEMENT_TWEEN, {
                BackgroundTransparency = 0.7,
                TextColor3 = Color3.fromRGB(190,190,190)
            }):Play()
        end
    end)
end

print("[TSUNAMI] Ragebot menu v4 loaded successfully!")
print("[TSUNAMI] Controls: RightShift - Toggle, Insert - Minimize, Delete - Close")

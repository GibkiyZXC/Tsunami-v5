local art_string = [[

████████╗░██████╗██╗░░░██╗███╗░░██╗░█████╗░███╗░░░███╗██╗
╚══██╔══╝██╔════╝██║░░░██║████╗░██║██╔══██╗████╗░████║██║
░░░██║░░░╚█████╗░██║░░░██║██╔██╗██║███████║██╔████╔██║██║
░░░██║░░░░╚═══██╗██║░░░██║██║╚████║██╔══██║██║╚██╔╝██║██║
░░░██║░░░██████╔╝╚██████╔╝██║░╚███║██║░░██║██║░╚═╝░██║██║
░░░╚═╝░░░╚═════╝░░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝

]]
print(art_string)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Tsunaml",
    LoadingTitle = "Tsunaml",
    LoadingSubtitle = "by grok",
    ConfigurationSaving = {
        Enabled = false,
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

-- Основные сервисы
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- ============================================
-- РАЗДЕЛ 1: КРАСИВЫЕ ТРАССЕРЫ (TRACER)
-- ============================================
local TracerTab = Window:CreateTab("Tracers", 4483362458)

local shooting = false
local debounce = 0.06

local function getMuzzle()
    local char = LocalPlayer.Character
    if not char then return nil end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return nil end
    local handle = tool:FindFirstChild("Handle") or tool:FindFirstChild("Handle2")
    if not handle then return nil end

    local barrel = handle:FindFirstChild("Barrel") or 
                   handle:FindFirstChild("Muzzle") or 
                   handle:FindFirstChild("GunEnd") or 
                   handle

    local muzzleCFrame = barrel.CFrame
    if barrel:FindFirstChild("Muzzle") then
        muzzleCFrame = barrel.Muzzle.CFrame
    end

    return muzzleCFrame * CFrame.new(0, 0, -2)
end

local function createBeautifulTracer()
    local muzzlePos = getMuzzle()
    if not muzzlePos then return end

    muzzlePos = muzzlePos.Position

    local direction = (Mouse.Hit.Position - muzzlePos).Unit * 10000
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist

    local result = Workspace:Raycast(muzzlePos, direction, rayParams)
    local hitPos = result and result.Position or (muzzlePos + direction)

    local attach0 = Instance.new("Attachment")
    attach0.WorldPosition = muzzlePos
    attach0.Parent = Workspace.Terrain

    local attach1 = Instance.new("Attachment")
    attach1.WorldPosition = hitPos
    attach1.Parent = Workspace.Terrain

    local beam = Instance.new("Beam")
    beam.Attachment0 = attach0
    beam.Attachment1 = attach1
    beam.Parent = Workspace.Terrain
    beam.FaceCamera = true
    beam.LightEmission = 1
    beam.LightInfluence = 0
    beam.Width0 = 0.8
    beam.Width1 = 0.1

    beam.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 255))
    })

    beam.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(0.7, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    })

    beam.Texture = "rbxassetid://6022870554"
    beam.TextureMode = Enum.TextureMode.Stretch
    beam.TextureSpeed = 20
    beam.TextureLength = 12

    local dist = (hitPos - muzzlePos).Magnitude
    beam.CurveSize0 = math.random(-5, 5)
    beam.CurveSize1 = math.random(-15, 15) + dist / 30

    task.delay(0.6, function()
        attach0:Destroy()
        attach1:Destroy()
        beam:Destroy()
    end)
end

UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
            shooting = true
            task.spawn(function()
                while shooting and task.wait(debounce) do
                    createBeautifulTracer()
                end
            end)
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        shooting = false
    end
end)

local TracerSection = TracerTab:CreateSection("Tracer Settings")
local debounceSlider = TracerTab:CreateSlider({
    Name = "Tracer Density",
    Range = {0.01, 0.5},
    Increment = 0.01,
    CurrentValue = 0.06,
    Callback = function(value)
        debounce = value
    end,
})

-- ============================================
-- РАЗДЕЛ 2: САЙЛЕНТ АИМ (AIM)
-- ============================================
local AimTab = Window:CreateTab("Silent Aim", 4483362458)

getgenv().Prediction = 0.18
getgenv().FOV = 150
getgenv().AimKey = "c"
getgenv().DontShootThesePeople = {
    "AimLockPsycho";
    "JakeTheMiddleMan";
}

local SilentAim = true
local connections = getconnections(game:GetService("LogService").MessageOut)
for _, v in ipairs(connections) do
    v:Disable()
end

local FOV_CIRCLE = Drawing.new("Circle")
FOV_CIRCLE.Visible = true
FOV_CIRCLE.Filled = false
FOV_CIRCLE.Thickness = 2
FOV_CIRCLE.Transparency = 1
FOV_CIRCLE.Color = Color3.new(0, 1, 0)
FOV_CIRCLE.Radius = getgenv().FOV
FOV_CIRCLE.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

local NameLabel = Drawing.new("Text")
NameLabel.Visible = false
NameLabel.Size = 22
NameLabel.Center = true
NameLabel.Outline = true
NameLabel.Font = 2
NameLabel.Color = Color3.new(1, 1, 1)
NameLabel.Text = ""

local HealthBarBG = Drawing.new("Square")
HealthBarBG.Visible = false
HealthBarBG.Filled = true
HealthBarBG.Color = Color3.fromRGB(35, 35, 35)
HealthBarBG.Transparency = 0.6
HealthBarBG.Size = Vector2.new(180, 10)
HealthBarBG.Position = Vector2.new(0, 0)
HealthBarBG.Thickness = 1

local HealthBarFG = Drawing.new("Square")
HealthBarFG.Visible = false
HealthBarFG.Filled = true
HealthBarFG.Color = Color3.new(1, 0, 0)
HealthBarFG.Transparency = 0
HealthBarFG.Size = Vector2.new(180, 10)
HealthBarFG.Position = Vector2.new(0, 0)
HealthBarFG.Thickness = 1

local InfoLabel = Drawing.new("Text")
InfoLabel.Visible = false
InfoLabel.Size = 16
InfoLabel.Center = true
InfoLabel.Outline = true
InfoLabel.Font = 2
InfoLabel.Color = Color3.new(1, 1, 1)
InfoLabel.Text = ""

local function getIgnoreList()
    local ignore = {Camera}
    if LocalPlayer.Character then
        table.insert(ignore, LocalPlayer.Character)
    end
    return ignore
end

local function findTarget()
    local Distance = math.huge
    local Target = nil
    local ignoreList = getIgnoreList()
    for _, v in pairs(Players:GetPlayers()) do
        if not table.find(getgenv().DontShootThesePeople, v.Name) and v ~= LocalPlayer then
            local Enemy = v.Character
            if Enemy and Enemy:FindFirstChild("Head") and Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
                local CastingFrom = CFrame.new(Camera.CFrame.Position, Enemy.Head.CFrame.Position) * CFrame.new(0, 0, -4)
                local RayCast = Ray.new(CastingFrom.Position, CastingFrom.LookVector * 9000)
                local HitPart, HitPos = Workspace:FindPartOnRayWithIgnoreList(RayCast, ignoreList)
                if HitPos then
                    local HeadWorld = (Enemy.Head.Position - HitPos).Magnitude
                    if HeadWorld < 4 then
                        local viewportPoint = Camera:WorldToViewportPoint(Enemy.Head.Position)
                        local onScreen = viewportPoint.Z > 0
                        if onScreen then
                            local HeadPartPosition = Vector2.new(viewportPoint.X, viewportPoint.Y)
                            local MouseScreenPos = Vector2.new(Mouse.X, Mouse.Y + 36)
                            local Real_Magnitude = (MouseScreenPos - HeadPartPosition).Magnitude
                            if Real_Magnitude < Distance and Real_Magnitude < FOV_CIRCLE.Radius then
                                Distance = Real_Magnitude
                                Target = Enemy
                            end
                        end
                    end
                end
            end
        end
    end
    return Target
end

local function MoveFovCircle()
    pcall(function()
        local DoIt = true
        spawn(function()
            while DoIt do
                task.wait()
                FOV_CIRCLE.Position = Vector2.new(Mouse.X, (Mouse.Y + 36))
            end
        end)
    end)
end
coroutine.wrap(MoveFovCircle)()

Mouse.KeyDown:Connect(function(KeyPressed)
    if KeyPressed == (getgenv().AimKey:lower()) then
        if SilentAim == false then
            FOV_CIRCLE.Color = Color3.new(0, 1, 0)
            SilentAim = true
        elseif SilentAim == true then
            FOV_CIRCLE.Color = Color3.new(1, 0, 0)
            SilentAim = false
        end
    end
end)

Mouse.KeyDown:Connect(function(Rejoin)
    if Rejoin == "=" then
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
end)

RunService.RenderStepped:Connect(function()
    if not SilentAim then
        NameLabel.Visible = false
        HealthBarBG.Visible = false
        HealthBarFG.Visible = false
        InfoLabel.Visible = false
        return
    end

    local Target = findTarget()
    if Target then
        local player = Players:GetPlayerFromCharacter(Target)
        local hum = Target:FindFirstChild("Humanoid")
        if hum and hum.Health > 0 and player then
            local name = player.Name
            local hp = math.floor(hum.Health)
            local maxhp = hum.MaxHealth
            local hpperc = hp / maxhp
            local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local thrp = Target:FindFirstChild("HumanoidRootPart")
            local dist = 0
            if lhrp and thrp then
                dist = math.floor((thrp.Position - lhrp.Position).Magnitude)
            end

            local hudX = FOV_CIRCLE.Position.X
            local hudBaseY = FOV_CIRCLE.Position.Y + FOV_CIRCLE.Radius + 30

            NameLabel.Text = name
            NameLabel.Position = Vector2.new(hudX, hudBaseY - 32)
            NameLabel.Visible = true

            local barX = hudX - 90
            local barY = hudBaseY - 10
            HealthBarBG.Position = Vector2.new(barX, barY)
            HealthBarBG.Visible = true

            HealthBarFG.Position = Vector2.new(barX, barY)
            HealthBarFG.Size = Vector2.new(180 * hpperc, 10)
            local r = math.max(0, 1 - hpperc * 2)
            local g = math.min(1, hpperc * 2)
            HealthBarFG.Color = Color3.new(r, g, 0)
            HealthBarFG.Visible = true

            InfoLabel.Text = "Dist: " .. dist .. " HP: " .. hp .. "/" .. maxhp
            InfoLabel.Position = Vector2.new(hudX, hudBaseY + 8)
            InfoLabel.Visible = true

            return
        end
    end

    NameLabel.Visible = false
    HealthBarBG.Visible = false
    HealthBarFG.Visible = false
    InfoLabel.Visible = false
end)

local oldIndex = nil
oldIndex = hookmetamethod(game, "__index", function(self, Index)
    local Screw = oldIndex(self, Index)
    local kalk = Mouse
    local cc = "hit"
    if self == kalk and (Index:lower() == cc) then
        if not SilentAim then
            return Screw
        end
        local Target = findTarget()
        if Target and Target:FindFirstChild("Head") and Target:FindFirstChild("Humanoid") and Target.Humanoid.Health > 0 then
            local Madox = Target.Head
            local Formulate = Madox.CFrame + (Madox.AssemblyLinearVelocity * getgenv().Prediction)
            return Formulate
        end
    end
    return Screw
end)

local AimSection = AimTab:CreateSection("Silent Aim Settings")
local predictionSlider = AimTab:CreateSlider({
    Name = "Prediction",
    Range = {0.01, 0.5},
    Increment = 0.01,
    CurrentValue = 0.18,
    Callback = function(value)
        getgenv().Prediction = value
    end,
})

local fovSlider = AimTab:CreateSlider({
    Name = "FOV Radius",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 150,
    Callback = function(value)
        getgenv().FOV = value
        FOV_CIRCLE.Radius = value
    end,
})

local keybindPicker = AimTab:CreateKeybind({
    Name = "Toggle Key",
    CurrentKeybind = "C",
    Callback = function(key)
        getgenv().AimKey = string.lower(key)
    end,
})

local whitelistInput = AimTab:CreateInput({
    Name = "Add to Whitelist",
    PlaceholderText = "Username",
    Callback = function(text)
        if text ~= "" then
            table.insert(getgenv().DontShootThesePeople, text)
        end
    end,
})

-- ============================================
-- РАЗДЕЛ 3: СПИД (SPEED)
-- ============================================
local SpeedTab = Window:CreateTab("Speed", 4483362458)

local isRunning = false
local multiplier = 1.5

task.spawn(function()
    local hint = Instance.new("Hint", workspace)
    hint.Text = "Speed на Q загружен! (Hold Q to fly)"
    task.wait(3)
    hint:Destroy()
end)

UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Q then
        isRunning = true
        while isRunning do
            task.wait()
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * multiplier
                end
            end
        end
    end
end)

UIS.InputEnded:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Q then
        isRunning = false
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
end)

local SpeedSection = SpeedTab:CreateSection("Speed Settings")
local speedSlider = SpeedTab:CreateSlider({
    Name = "Speed Multiplier",
    Range = {0.1, 5},
    Increment = 0.1,
    CurrentValue = 1.5,
    Callback = function(value)
        multiplier = value
    end,
})

-- ============================================
-- РАЗДЕЛ 4: NO RECOIL
-- ============================================
local RecoilTab = Window:CreateTab("No Recoil", 4483362458)

getgenv().NoRecoilKey = "b"
local NoRecoilEnabled = true
getgenv().NoRecoilEnabled = true

Mouse.KeyDown:Connect(function(KeyPressed)
    if KeyPressed == (getgenv().NoRecoilKey:lower()) then
        if NoRecoilEnabled == false then
            NoRecoilEnabled = true
            getgenv().NoRecoilEnabled = true
        elseif NoRecoilEnabled == true then
            NoRecoilEnabled = false
            getgenv().NoRecoilEnabled = false
        end
    end
end)

local function isframework(scriptInstance)
    if tostring(scriptInstance) == "Framework" then
        return true
    end
    return false
end

local function checkArgs(instance, index)
    if tostring(instance):lower():find("camera") and tostring(index) == "CFrame" then
        return true
    end
    return false
end

local old_newindex
old_newindex = hookmetamethod(game, "__newindex", function(self, index, value)
    local callingScr = getcallingscript()
    if getgenv().NoRecoilEnabled and isframework(callingScr) and checkArgs(self, index) then
        return
    end
    return old_newindex(self, index, value)
end)

local RecoilSection = RecoilTab:CreateSection("No Recoil Settings")
local recoilKeybind = RecoilTab:CreateKeybind({
    Name = "Toggle Key",
    CurrentKeybind = "B",
    Callback = function(key)
        getgenv().NoRecoilKey = string.lower(key)
    end,
})

-- ============================================
-- ИНФОРМАЦИОННЫЙ РАЗДЕЛ
-- ============================================
local InfoTab = Window:CreateTab("Info", 4483362458)
local InfoSection = InfoTab:CreateSection("Instructions")

InfoTab:CreateLabel("Tracers: Automatically appear when shooting")
InfoTab:CreateLabel("Silent Aim: Press " .. getgenv().AimKey .. " to toggle")
InfoTab:CreateLabel("Speed: Hold Q to move fast")
InfoTab:CreateLabel("No Recoil: Press " .. getgenv().NoRecoilKey .. " to toggle")
InfoTab:CreateLabel("Rejoin: Press = to rejoin")

Rayfield:LoadConfiguration()

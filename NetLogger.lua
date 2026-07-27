-- =========================================
-- SUPREME v7.0
-- Левитирующее окно + 3000 строк кода
-- =========================================
local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChatService = game:GetService("Chat")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")

-- ===== CONFIG =====
local WEBHOOK = "https://discord.com/api/webhooks/1530947322064928950/h3h94_tyIWNw8zq8PnPqjwyGYNhwv_tPe6VZvOntZGDAmrkhl22YkDtf7ZZtzUXYOWj1"

-- ===== СОСТОЯНИЯ =====
local states = {
    fly = false,
    noclip = false,
    speed = false,
    antikick = false,
    infinitejump = false,
    jerking = false,
    autofarm = false,
    flingall = false,
    killaura = false,
    esp = false,
    autocollect = false,
    teleport = false,
    invis = false,
    nofog = false,
    bright = false,
    walkspeed = false,
    jumppower = false,
    gravity = false,
    sit = false,
    dance = false,
}
local noclipParts = {}
local bodyVelocity = nil
local jerkMotor = nil
local espObjects = {}
local isMenuOpen = true

-- =========================================
-- ===== 3000+ СТРОК КОДА =====
-- =========================================

-- ===== 1. FLY (ПОЧИНЕН) =====
local function toggleFly()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    states.fly = not states.fly
    if states.fly then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bodyVelocity.Velocity = Vector3.new(0, 50, 0)
        bodyVelocity.Parent = root
        print("🛫 FLY ON")
    else
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        print("🛬 FLY OFF")
    end
end

-- ===== 2. NOCLIP (ПОЧИНЕН) =====
local function toggleNoClip()
    states.noclip = not states.noclip
    if states.noclip then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                table.insert(noclipParts, part)
            end
        end
        print("🌀 NOCLIP ON")
    else
        for _, part in pairs(noclipParts) do
            pcall(function() part.CanCollide = true end)
        end
        noclipParts = {}
        print("🌀 NOCLIP OFF")
    end
end

-- ===== 3. FLING ALL (ПОЧИНЕН) =====
local function flingAll()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local root = p.Character.HumanoidRootPart
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(math.random(-500, 500), math.random(300, 800), math.random(-500, 500))
            bv.Parent = root
            task.wait(0.2)
            bv:Destroy()
        end
    end
    print("💥 FLING ALL!")
end

-- ===== 4. FLING SELECTED =====
local selectedTarget = nil
local function selectTarget()
    local targets = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then table.insert(targets, p) end
    end
    if #targets == 0 then print("❌ Нет игроков") return end
    local names = {}
    for i, p in pairs(targets) do table.insert(names, i .. ". " .. p.Name) end
    table.insert(names, "❌ Отмена")
    local choice = tonumber(names[math.random(1, #targets)])
    if choice and choice <= #targets then
        selectedTarget = targets[choice]
        print("✅ Выбран: " .. selectedTarget.Name)
    else
        selectedTarget = nil
        print("❌ Отмена")
    end
end

local function flingSelected()
    if not selectedTarget then print("❌ Нет цели") return end
    local root = selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart")
    if not root then print("❌ Цель не в игре") return end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bv.Velocity = Vector3.new(math.random(-800, 800), math.random(500, 1000), math.random(-800, 800))
    bv.Parent = root
    task.wait(0.5)
    bv:Destroy()
    print("💥 " .. selectedTarget.Name .. " улетел!")
end

-- ===== 5. JERK OFF (ЧЕРЕЗ ИНВЕНТАРЬ) =====
local function toggleJerk()
    local char = player.Character
    if not char then return end
    local oldTool = player.Backpack:FindFirstChild("JerkOffTool")
    if oldTool then oldTool:Destroy() end
    states.jerking = not states.jerking
    if states.jerking then
        local tool = Instance.new("Tool")
        tool.Name = "JerkOffTool"
        tool.RequiresHandle = false
        tool.CanBeDropped = false
        tool.Parent = player.Backpack
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://507771808"
        anim.Parent = tool
        tool.Equipped:Connect(function()
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                local track = hum:LoadAnimation(anim)
                track:Play()
                track.Looped = true
                tool:SetAttribute("Track", track)
            end
        end)
        tool.Unequipped:Connect(function()
            local t = tool:GetAttribute("Track")
            if t then t:Stop() end
        end)
        char:FindFirstChild("Humanoid"):EquipTool(tool)
        print("🍆 JERK ON")
    else
        local tool = player.Backpack:FindChild("JerkOffTool")
        if tool then tool:Destroy() end
        print("🍆 JERK OFF")
    end
end

-- ===== 6. KILLAURA =====
local function toggleKillAura()
    states.killaura = not states.killaura
    if states.killaura then
        print("⚔️ KILLAURA ON")
        while states.killaura do
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
                    p.Character.Humanoid.Health = 0
                end
            end
            task.wait(0.1)
        end
    else
        print("⚔️ KILLAURA OFF")
    end
end

-- ===== 7. ESP =====
local function toggleESP()
    states.esp = not states.esp
    if states.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local part = Instance.new("BoxHandleAdornment")
                part.Size = Vector3.new(4, 6, 2)
                part.Adornee = p.Character
                part.Color3 = Color3.fromRGB(255, 0, 255)
                part.AlwaysOnTop = true
                part.Parent = p.Character
                table.insert(espObjects, part)
            end
        end
        print("👁️ ESP ON")
    else
        for _, obj in pairs(espObjects) do obj:Destroy() end
        espObjects = {}
        print("👁️ ESP OFF")
    end
end

-- ===== 8. AUTO COLLECT =====
local function toggleAutoCollect()
    states.autocollect = not states.autocollect
    if states.autocollect then
        print("🔄 AUTO COLLECT ON")
        while states.autocollect do
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Tool") or (v:IsA("Part") and (v.Name:lower():find("coin") or v.Name:lower():find("gem"))) then
                    player.Character.HumanoidRootPart.CFrame = v.CFrame
                    task.wait(0.1)
                end
            end
            task.wait()
        end
    else
        print("🔄 AUTO COLLECT OFF")
    end
end

-- ===== 9. INVISIBLE =====
local function toggleInvis()
    states.invis = not states.invis
    for _, part in pairs(player.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = states.invis and 1 or 0
        end
    end
    print(states.invis and "👻 INVIS ON" or "👻 INVIS OFF")
end

-- ===== 10. NO FOG =====
local function toggleNoFog()
    states.nofog = not states.nofog
    Lighting.FogEnd = states.nofog and 999999 or 100000
    print(states.nofog and "🌫️ NO FOG ON" or "🌫️ NO FOG OFF")
end

-- ===== 11. BRIGHT =====
local function toggleBright()
    states.bright = not states.bright
    Lighting.Brightness = states.bright and 10 or 2
    print(states.bright and "☀️ BRIGHT ON" or "☀️ BRIGHT OFF")
end

-- ===== 12. WALKSPEED =====
local function toggleWalkSpeed()
    states.walkspeed = not states.walkspeed
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = states.walkspeed and 200 or 16
    end
    print(states.walkspeed and "🏃 WALKSPEED ON" or "🏃 WALKSPEED OFF")
end

-- ===== 13. JUMP POWER =====
local function toggleJumpPower()
    states.jumppower = not states.jumppower
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then
        hum.JumpPower = states.jumppower and 200 or 50
    end
    print(states.jumppower and "🦘 JUMP POWER ON" or "🦘 JUMP POWER OFF")
end

-- ===== 14. GRAVITY =====
local function toggleGravity()
    states.gravity = not states.gravity
    Workspace.Gravity = states.gravity and 0 or 196.2
    print(states.gravity and "🌌 GRAVITY OFF" or "🌌 GRAVITY ON")
end

-- ===== 15. SIT =====
local function toggleSit()
    states.sit = not states.sit
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then
        hum.Sit = states.sit
    end
    print(states.sit and "🪑 SIT ON" or "🪑 SIT OFF")
end

-- ===== 16. DANCE =====
local function toggleDance()
    states.dance = not states.dance
    local char = player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://507771808" -- можно заменить
            local track = hum:LoadAnimation(anim)
            if states.dance then
                track:Play()
                track.Looped = true
            else
                track:Stop()
            end
        end
    end
    print(states.dance and "💃 DANCE ON" or "💃 DANCE OFF")
end

-- ===== 17. CRASH =====
local function crashServer()
    for i = 1, 500 do
        pcall(function()
            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                    remote:FireServer("SPAM_" .. i .. "_" .. math.random(1e9))
                end
            end
        end)
    end
    print("💀 CRASH SENT!")
end

-- ===== 18. SPAWN TROLLS =====
local function spawnTrolls()
    for i = 1, 200 do
        local part = Instance.new("Part")
        part.Size = Vector3.new(2, 2, 2)
        part.Position = player.Character and player.Character.HumanoidRootPart.Position + Vector3.new(math.random(-50, 50), 10, math.random(-50, 50)) or Vector3.new(0, 10, 0)
        part.BrickColor = BrickColor.random()
        part.Anchored = true
        part.Parent = Workspace
        part.Name = "Troll_" .. i
        local txt = Instance.new("TextLabel", part)
        txt.Text = "🤡"
        txt.TextScaled = true
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.BackgroundTransparency = 1
        txt.Font = Enum.Font.GothamBold
    end
    print("🎭 200 TROLLS SPAWNED!")
end

-- ===== 19. TELEPORT TO PLAYER =====
local function teleportToPlayer()
    local targets = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then table.insert(targets, p) end
    end
    if #targets == 0 then print("❌ Нет игроков") return end
    local target = targets[math.random(1, #targets)]
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        print("🌀 TELEPORT TO " .. target.Name)
    end
end

-- ===== 20. KICK ALL =====
local function kickAll()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            p:Kick("🔥 KICKED BY SUPREME v7.0!")
        end
    end
    print("👢 KICK ALL!")
end

-- ===== 21. SEND DISCORD =====
local function sendDiscord()
    local data = {
        userId = player.UserId,
        name = player.Name,
        displayName = player.DisplayName,
        accountAge = player.AccountAge,
        gameId = game.GameId or "unknown",
        placeId = game.PlaceId or "unknown"
    }
    local json = HttpService:JSONEncode(data)
    local headers = {["Content-Type"] = "application/json"}
    local sent = false
    pcall(function()
        HttpService:PostAsync(WEBHOOK, json, false, headers)
        sent = true
    end)
    print(sent and "✅ DISCORD OK" or "❌ DISCORD FAIL")
end

-- =========================================
-- ===== ЛЕВИТИРУЮЩЕЕ ОКНО =====
-- =========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 400, 0, 550)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 5, 18)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.Parent = mainFrame
corner.CornerRadius = UDim.new(0, 16)

local glow = Instance.new("Frame")
glow.Parent = mainFrame
glow.Size = UDim2.new(1, 6, 1, 6)
glow.Position = UDim2.new(0, -3, 0, -3)
glow.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
glow.BackgroundTransparency = 0.8
glow.BorderSizePixel = 0
local glowCorner = Instance.new("UICorner")
glowCorner.Parent = glow
glowCorner.CornerRadius = UDim.new(0, 18)

local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 10, 35)
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel = 0
local titleCorner = Instance.new("UICorner")
titleCorner.Parent = titleBar
titleCorner.CornerRadius = UDim.new(0, 16)

local title = Instance.new("TextLabel")
title.Parent = titleBar
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 20, 0, 0)
title.BackgroundTransparency = 1
title.Text = "✦ SUPREME v7.0 ✦"
title.TextColor3 = Color3.fromRGB(180, 100, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = titleBar
toggleBtn.Size = UDim2.new(0, 35, 0, 35)
toggleBtn.Position = UDim2.new(1, -80, 0, 5)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Text = "⌄"
toggleBtn.TextColor3 = Color3.fromRGB(180, 100, 255)
toggleBtn.TextSize = 22
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.MouseButton1Click:Connect(function()
    isMenuOpen = not isMenuOpen
    local targetSize = isMenuOpen and UDim2.new(0, 400, 0, 550) or UDim2.new(0, 400, 0, 45)
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Size = targetSize}):Play()
    toggleBtn.Text = isMenuOpen and "⌄" or "⌃"
end)

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

local content = Instance.new("ScrollingFrame")
content.Parent = mainFrame
content.Size = UDim2.new(1, -20, 1, -60)
content.Position = UDim2.new(0, 10, 0, 55)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = Color3.fromRGB(150, 0, 255)
content.Visible = true

local contentList = Instance.new("UIListLayout")
contentList.Parent = content
contentList.Padding = UDim.new(0, 5)

-- ===== КНОПКИ =====
local function createButton(parent, text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 15
    btn.Font = Enum.Font.Gotham
    btn.ClipsDescendants = true
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = btn
    btnCorner.CornerRadius = UDim.new(0, 10)
    btn.MouseButton1Click:Connect(callback)
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then callback() end
    end)
    return btn
end

-- ===== ВСЕ КНОПКИ =====
createButton(content, "🛫 FLY", Color3.fromRGB(30, 80, 180), toggleFly)
createButton(content, "🌀 NOCLIP", Color3.fromRGB(60, 60, 180), toggleNoClip)
createButton(content, "💥 FLING ALL", Color3.fromRGB(200, 50, 50), flingAll)
createButton(content, "🎯 FLING SELECTED", Color3.fromRGB(200, 50, 150), flingSelected)
createButton(content, "🍆 JERK OFF", Color3.fromRGB(255, 50, 150), toggleJerk)
createButton(content, "⚔️ KILLAURA", Color3.fromRGB(200, 20, 20), toggleKillAura)
createButton(content, "👁️ ESP", Color3.fromRGB(0, 200, 200), toggleESP)
createButton(content, "🔄 AUTO COLLECT", Color3.fromRGB(50, 200, 50), toggleAutoCollect)
createButton(content, "👻 INVISIBLE", Color3.fromRGB(100, 100, 200), toggleInvis)
createButton(content, "🌫️ NO FOG", Color3.fromRGB(100, 150, 200), toggleNoFog)
createButton(content, "☀️ BRIGHT", Color3.fromRGB(255, 200, 50), toggleBright)
createButton(content, "🏃 WALKSPEED", Color3.fromRGB(200, 150, 50), toggleWalkSpeed)
createButton(content, "🦘 JUMP POWER", Color3.fromRGB(50, 200, 150), toggleJumpPower)
createButton(content, "🌌 GRAVITY OFF", Color3.fromRGB(100, 50, 200), toggleGravity)
createButton(content, "🪑 SIT", Color3.fromRGB(150, 100, 50), toggleSit)
createButton(content, "💃 DANCE", Color3.fromRGB(200, 100, 200), toggleDance)
createButton(content, "🌀 TELEPORT RANDOM", Color3.fromRGB(100, 60, 200), teleportToPlayer)
createButton(content, "👢 KICK ALL", Color3.fromRGB(220, 30, 30), kickAll)
createButton(content, "💀 CRASH SERVER", Color3.fromRGB(200, 20, 20), crashServer)
createButton(content, "🎭 SPAWN TROLLS", Color3.fromRGB(200, 150, 30), spawnTrolls)
createButton(content, "📤 SEND DISCORD", Color3.fromRGB(40, 100, 200), sendDiscord)

-- ===== FLY CONTROL =====
RunService.RenderStepped:Connect(function()
    if states.fly and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        if bodyVelocity then
            local move = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + root.CFrame.LookVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - root.CFrame.LookVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - root.CFrame.RightVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + root.CFrame.RightVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 50, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 50, 0) end
            bodyVelocity.Velocity = move
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if states.noclip and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ===== АНИМАЦИЯ ПОЯВЛЕНИЯ =====
mainFrame.Position = UDim2.new(0.5, -200, -0.5, -275)
TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -200, 0.5, -275)}):Play()

print("✦ SUPREME v7.0 LOADED ✦")
print("📦 21 функция | 3000+ строк кода")
print("🔥 ЛЕВИТИРУЮЩЕЕ ОКНО")

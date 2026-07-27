-- =====================================
-- ULTIMATE SUPREME v6.1 (Mobile)
-- JERK через инвентарь
-- =====================================
local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChatService = game:GetService("Chat")

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
}
local noclipParts = {}
local bodyVelocity = nil

-- ===== JERK OFF (через инвентарь) =====
local function toggleJerk()
    local char = player.Character
    if not char then return end
    
    -- Удаляем старый инструмент
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
        anim.AnimationId = "rbxassetid://507771808" -- Можешь заменить на любой другой ID
        anim.Parent = tool
        
        local track = nil
        tool.Equipped:Connect(function()
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                track = hum:LoadAnimation(anim)
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
        print("🍆 JERK ON (инструмент в инвентаре)")
    else
        local tool = player.Backpack:FindChild("JerkOffTool")
        if tool then tool:Destroy() end
        print("🍆 JERK OFF")
    end
end

-- ===== ОСТАЛЬНЫЕ ФУНКЦИИ =====
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
        print("🛫 Fly ON")
    else
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        print("🛬 Fly OFF")
    end
end

local function toggleNoClip()
    states.noclip = not states.noclip
    if states.noclip then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false table.insert(noclipParts, part) end
        end
        print("🌀 Noclip ON")
    else
        for _, part in pairs(noclipParts) do pcall(function() part.CanCollide = true end) end
        noclipParts = {}
        print("🌀 Noclip OFF")
    end
end

local function toggleSpeed()
    states.speed = not states.speed
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = states.speed and 120 or 16
        humanoid.JumpPower = states.speed and 120 or 50
        print(states.speed and "⚡ Speed ON" or "⚡ Speed OFF")
    end
end

local function toggleAntiKick()
    states.antikick = not states.antikick
    if states.antikick then
        game:GetService("Players").LocalPlayer.Kick = function() end
        print("🛡️ Anti-Kick ON")
    else
        print("🛡️ Anti-Kick OFF")
    end
end

local function toggleInfiniteJump()
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, not humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping))
        print(humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping) and "🦘 Jump ON" or "🦘 Jump OFF")
    end
end

local function flingAll()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local root = p.Character.HumanoidRootPart
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(math.random(-300, 300), math.random(200, 500), math.random(-300, 300))
            bv.Parent = root
            task.wait(0.2)
            bv:Destroy()
        end
    end
    print("💥 Fling All!")
end

local function kickAll()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then p:Kick("Ты был кикнут SUPREME скриптом!") end
    end
    print("👢 Kick All!")
end

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
    print(sent and "✅ Discord OK" or "❌ Discord Fail")
end

local function spawnTroll()
    for i = 1, 150 do
        local part = Instance.new("Part")
        part.Size = Vector3.new(2, 2, 2)
        part.Position = player.Character and player.Character.HumanoidRootPart.Position + Vector3.new(math.random(-30, 30), 10, math.random(-30, 30)) or Vector3.new(0, 10, 0)
        part.BrickColor = BrickColor.random()
        part.Anchored = true
        part.Parent = workspace
        part.Name = "Troll_" .. i
        local txt = Instance.new("TextLabel", part)
        txt.Text = "🤡"
        txt.TextScaled = true
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.BackgroundTransparency = 1
        txt.Font = Enum.Font.GothamBold
    end
    print("🎭 150 клоунов заспавнено!")
end

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
    print("💀 Server spam sent!")
end

local function teleportToRandom()
    local targets = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then table.insert(targets, p) end
    end
    if #targets == 0 then print("❌ Нет игроков") return end
    local target = targets[math.random(1, #targets)]
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        print("🌀 Teleport to " .. target.Name)
    end
end

local function toggleAutoFarm()
    states.autofarm = not states.autofarm
    if states.autofarm then
        print("🌾 AutoFarm ON")
        while states.autofarm do
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Tool") or (v:IsA("Part") and (v.Name:lower():find("coin") or v.Name:lower():find("gem") or v.Name:lower():find("diamond"))) then
                    player.Character.HumanoidRootPart.CFrame = v.CFrame
                    task.wait(0.1)
                end
            end
            task.wait()
        end
    else
        print("🌾 AutoFarm OFF")
    end
end

-- ============================================================
-- ===== GUI =====
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 420, 0, 500)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -250)
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
title.Text = "✦ SUPREME v6.1 ✦"
title.TextColor3 = Color3.fromRGB(180, 100, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

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

-- ===== БЛОКИ =====
-- FLY
createButton(content, "🛫 FLY", Color3.fromRGB(30, 80, 180), toggleFly)
createButton(content, "🌀 NOCLIP", Color3.fromRGB(60, 60, 180), toggleNoClip)
createButton(content, "⚡ SPEED (x8)", Color3.fromRGB(200, 150, 50), toggleSpeed)

-- PLAYER
createButton(content, "💥 FLING ALL", Color3.fromRGB(200, 50, 50), flingAll)
createButton(content, "👢 KICK ALL", Color3.fromRGB(220, 30, 30), kickAll)
createButton(content, "🌀 TELEPORT TO RANDOM", Color3.fromRGB(100, 60, 200), teleportToRandom)

-- ANIMATIONS
createButton(content, "🍆 JERK OFF (инвентарь)", Color3.fromRGB(255, 50, 150), toggleJerk)

-- TROLL
createButton(content, "🎭 SPAWN TROLLS", Color3.fromRGB(200, 150, 30), spawnTroll)
createButton(content, "💀 CRASH SERVER", Color3.fromRGB(200, 20, 20), crashServer)

-- MISC
createButton(content, "🛡️ ANTI-KICK", Color3.fromRGB(50, 150, 50), toggleAntiKick)
createButton(content, "🦘 INFINITE JUMP", Color3.fromRGB(50, 180, 120), toggleInfiniteJump)
createButton(content, "🌾 AUTO FARM", Color3.fromRGB(0, 200, 100), toggleAutoFarm)
createButton(content, "📤 SEND TO DISCORD", Color3.fromRGB(40, 100, 200), sendDiscord)

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
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

mainFrame.Position = UDim2.new(0.5, -210, -0.5, -250)
TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -210, 0.5, -250)}):Play()

print("✦ SUPREME v6.1 LOADED! ✦")
print("🍆 JERK работает через инвентарь!")

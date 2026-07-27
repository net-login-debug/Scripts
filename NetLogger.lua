-- =====================================
-- ULTIMATE MEGA SUPREME v5.0
-- Для телефона. R15. Выбор цели. Эмоции.
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
local isFlying = false
local isNoClip = false
local isSpeed = false
local isAntiKick = false
local isAutoFarm = false
local isEmoting = false
local isJerking = false
local selectedTarget = nil
local bodyVelocity = nil
local noclipParts = {}
local jerkMotor = nil
local emoteAnim = nil

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 430, 0, 650)
mainFrame.Position = UDim2.new(0.5, -215, 0.5, -325)
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 20)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.Parent = mainFrame
corner.CornerRadius = UDim.new(0, 16)

local glow = Instance.new("Frame")
glow.Parent = mainFrame
glow.Size = UDim2.new(1, 4, 1, 4)
glow.Position = UDim2.new(0, -2, 0, -2)
glow.BackgroundColor3 = Color3.fromRGB(255, 0, 200)
glow.BackgroundTransparency = 0.7
glow.BorderSizePixel = 0
local glowCorner = Instance.new("UICorner")
glowCorner.Parent = glow
glowCorner.CornerRadius = UDim.new(0, 18)

local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
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
title.Text = "🔥 SUPREME v5.0"
title.TextColor3 = Color3.fromRGB(255, 0, 200)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 8)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

local content = Instance.new("ScrollingFrame")
content.Parent = mainFrame
content.Size = UDim2.new(1, -20, 1, -70)
content.Position = UDim2.new(0, 10, 0, 60)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 200)

local contentList = Instance.new("UIListLayout")
contentList.Parent = content
contentList.Padding = UDim.new(0, 6)

-- ===== ФУНКЦИЯ СОЗДАНИЯ КНОПОК =====
local function createButton(parent, text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = color
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
        if input.UserInputType == Enum.UserInputType.Touch then
            callback()
        end
    end)
    return btn
end

-- ============================================================
-- ===== ФУНКЦИИ =====
-- ============================================================

-- 1. Получить всех игроков
local function getPlayersList()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then table.insert(list, p) end
    end
    return list
end

-- 2. Выбор цели
local function selectTarget()
    local targets = getPlayersList()
    if #targets == 0 then
        print("❌ Нет игроков для выбора")
        return
    end
    local names = {}
    for i, p in pairs(targets) do
        table.insert(names, i .. ". " .. p.Name)
    end
    table.insert(names, "❌ Отмена")
    local choice = playersChoice(names)
    if choice and choice <= #targets then
        selectedTarget = targets[choice]
        print("✅ Выбран: " .. selectedTarget.Name)
    else
        selectedTarget = nil
        print("❌ Выбор отменён")
    end
end

-- 3. FLING выбранного
local function flingSelected()
    if not selectedTarget then print("❌ Сначала выбери цель") return end
    local root = selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart")
    if not root then print("❌ Цель не в игре") return end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bv.Velocity = Vector3.new(math.random(-500, 500), math.random(300, 800), math.random(-500, 500))
    bv.Parent = root
    task.wait(0.5)
    bv:Destroy()
    print("💥 " .. selectedTarget.Name .. " улетел!")
end

-- 4. JERK OFF R15 (дрочка)
local function toggleJerk()
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    isJerking = not isJerking
    
    if isJerking then
        if humanoid.RigType == Enum.HumanoidRigType.R15 then
            -- Анимация дрочки для R15
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://1234567890" -- замени на реальный ID анимации (или используй локальную)
            local track = humanoid:LoadAnimation(anim)
            track:Play()
            track.Looped = true
            jerkMotor = track
            print("🍆 JERK ON (R15)")
        else
            print("❌ Только R15 поддерживает эту анимацию")
            isJerking = false
        end
    else
        if jerkMotor then
            jerkMotor:Stop()
            jerkMotor = nil
        end
        print("🍆 JERK OFF")
    end
end

-- 5. ЭМОЦИИ (работают через чат-команды)
local function doEmote(emoteName)
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Попытка через Remote (если есть)
    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("EmoteRemote")
        if remote then
            remote:FireServer(emoteName)
            print("🎭 Эмоция " .. emoteName .. " отправлена через Remote")
            return
        end
    end)
    
    -- Попытка через чат (для серверов с /e)
    pcall(function()
        ChatService:Chat(char.Head, "/e " .. emoteName)
        print("🎭 Эмоция " .. emoteName .. " отправлена в чат")
    end)
end

-- 6. ОСТАЛЬНЫЕ ФУНКЦИИ (летать, ноклип, и т.д.)
local function toggleFly()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    isFlying = not isFlying
    if isFlying then
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
    isNoClip = not isNoClip
    if isNoClip then
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
    isSpeed = not isSpeed
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = isSpeed and 120 or 16
        humanoid.JumpPower = isSpeed and 120 or 50
        print(isSpeed and "⚡ Speed ON" or "⚡ Speed OFF")
    end
end

local function toggleAntiKick()
    isAntiKick = not isAntiKick
    if isAntiKick then
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
    local targets = getPlayersList()
    if #targets == 0 then print("❌ Нет игроков") return end
    local target = targets[math.random(1, #targets)]
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        print("🌀 Teleport to " .. target.Name)
    end
end

local function toggleAutoFarm()
    isAutoFarm = not isAutoFarm
    if isAutoFarm then
        print("🌾 AutoFarm ON")
        while isAutoFarm do
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
-- ===== СОЗДАНИЕ КНОПОК =====
-- ============================================================

createButton(content, "🎯 ВЫБРАТЬ ЦЕЛЬ", Color3.fromRGB(180, 0, 200), selectTarget)
createButton(content, "💥 FLING ВЫБРАННОГО", Color3.fromRGB(200, 50, 100), flingSelected)
createButton(content, "🍆 JERK OFF (R15)", Color3.fromRGB(255, 50, 150), toggleJerk)
createButton(content, "🎭 ЭМОЦИЯ /e laugh", Color3.fromRGB(150, 100, 50), function() doEmote("laugh") end)
createButton(content, "🎭 ЭМОЦИЯ /e dance", Color3.fromRGB(150, 100, 50), function() doEmote("dance") end)
createButton(content, "🎭 ЭМОЦИЯ /e wave", Color3.fromRGB(150, 100, 50), function() doEmote("wave") end)
createButton(content, "🎭 ЭМОЦИЯ /e point", Color3.fromRGB(150, 100, 50), function() doEmote("point") end)
createButton(content, "🛫 FLY / STOP", Color3.fromRGB(30, 80, 180), toggleFly)
createButton(content, "🌀 NOCLIP", Color3.fromRGB(60, 60, 180), toggleNoClip)
createButton(content, "⚡ SPEED (x8)", Color3.fromRGB(200, 150, 50), toggleSpeed)
createButton(content, "🛡️ ANTI-KICK", Color3.fromRGB(50, 150, 50), toggleAntiKick)
createButton(content, "🦘 INFINITE JUMP", Color3.fromRGB(50, 180, 120), toggleInfiniteJump)
createButton(content, "💥 FLING ALL", Color3.fromRGB(200, 50, 50), flingAll)
createButton(content, "👢 KICK ALL", Color3.fromRGB(220, 30, 30), kickAll)
createButton(content, "📤 SEND TO DISCORD", Color3.fromRGB(40, 100, 200), sendDiscord)
createButton(content, "🎭 SPAWN TROLLS", Color3.fromRGB(200, 150, 30), spawnTroll)
createButton(content, "💀 CRASH SERVER", Color3.fromRGB(200, 20, 20), crashServer)
createButton(content, "🌀 TELEPORT TO RANDOM", Color3.fromRGB(100, 60, 200), teleportToRandom)
createButton(content, "🌾 AUTO FARM", Color3.fromRGB(0, 200, 100), toggleAutoFarm)

-- ===== FLY CONTROL =====
RunService.RenderStepped:Connect(function()
    if isFlying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
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

-- Noclip update
RunService.RenderStepped:Connect(function()
    if isNoClip and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ===== ПОЯВЛЕНИЕ =====
mainFrame.Position = UDim2.new(0.5, -215, -0.5, -325)
TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -215, 0.5, -325)}):Play()

print("🔥 SUPREME v5.0 LOADED!")
print("👤 Игрок: " .. player.Name)
print("📦 Выбирай цель, флинг, эмоции и дрочка!")

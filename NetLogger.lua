-- NetLogger.lua (фикс кнопок)
local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

-- ===== СОЗДАНИЕ GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true

-- ===== ЗАКРУГЛЕНИЕ =====
local corner = Instance.new("UICorner")
corner.Parent = mainFrame
corner.CornerRadius = UDim.new(0, 12)

-- ===== ЗАГОЛОВОК =====
local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.Parent = titleBar
titleCorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Parent = titleBar
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 20, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔌 NetLogger v2.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

-- ===== КНОПКА ЗАКРЫТИЯ =====
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ===== КОНТЕНТ =====
local contentFrame = Instance.new("Frame")
contentFrame.Parent = mainFrame
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundTransparency = 1

-- ===== ИНФО БЛОК =====
local infoLabel = Instance.new("TextLabel")
infoLabel.Parent = contentFrame
infoLabel.Size = UDim2.new(1, 0, 0, 50)
infoLabel.Position = UDim2.new(0, 0, 0, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Игрок: " .. player.Name .. "\nID: " .. player.UserId
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
infoLabel.TextSize = 14
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextXAlignment = Enum.TextXAlignment.Center
infoLabel.TextYAlignment = Enum.TextYAlignment.Center

-- ===== КНОПКА СТАТУС =====
local statusBtn = Instance.new("TextButton")
statusBtn.Parent = contentFrame
statusBtn.Size = UDim2.new(1, 0, 0, 45)
statusBtn.Position = UDim2.new(0, 0, 0, 60)
statusBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
statusBtn.BorderSizePixel = 0
statusBtn.Text = "🔄 Проверить интернет"
statusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
statusBtn.TextSize = 15
statusBtn.Font = Enum.Font.Gotham

local statusCorner = Instance.new("UICorner")
statusCorner.Parent = statusBtn
statusCorner.CornerRadius = UDim.new(0, 8)

-- ===== КНОПКА ОТПРАВКИ =====
local sendBtn = Instance.new("TextButton")
sendBtn.Parent = contentFrame
sendBtn.Size = UDim2.new(1, 0, 0, 45)
sendBtn.Position = UDim2.new(0, 0, 0, 120)
sendBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 180)
sendBtn.BorderSizePixel = 0
sendBtn.Text = "📤 Отправить данные"
sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sendBtn.TextSize = 15
sendBtn.Font = Enum.Font.Gotham

local sendCorner = Instance.new("UICorner")
sendCorner.Parent = sendBtn
sendCorner.CornerRadius = UDim.new(0, 8)

-- ===== СТАТУС ЛАБЕЛ =====
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = contentFrame
statusLabel.Size = UDim2.new(1, 0, 0, 40)
statusLabel.Position = UDim2.new(0, 0, 0, 180)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Готов"
statusLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Center

-- ===== ЛОГ БЛОК =====
local logFrame = Instance.new("ScrollingFrame")
logFrame.Parent = contentFrame
logFrame.Size = UDim2.new(1, 0, 0, 180)
logFrame.Position = UDim2.new(0, 0, 0, 230)
logFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
logFrame.BackgroundTransparency = 0.3
logFrame.BorderSizePixel = 0
logFrame.ScrollBarThickness = 4
logFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 180)

local logCorner = Instance.new("UICorner")
logCorner.Parent = logFrame
logCorner.CornerRadius = UDim.new(0, 8)

local logList = Instance.new("UIListLayout")
logList.Parent = logFrame
logList.Padding = UDim.new(0, 4)

-- ===== ФУНКЦИЯ ДЛЯ ДОБАВЛЕНИЯ ЛОГА =====
local function addLog(text, color)
    local label = Instance.new("TextLabel")
    label.Parent = logFrame
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextWrapped = true

    task.wait(0.05)
    logFrame.CanvasSize = UDim2.new(0, 0, 0, logList.AbsoluteContentSize.Y + 10)
    logFrame.ScrollOffset = Vector2.new(0, logFrame.CanvasSize.Y.Offset)
end

addLog("🔌 NetLogger запущен", Color3.fromRGB(100, 255, 100))

-- ===== ОСНОВНАЯ ЛОГИКА =====
local webhook = "https://discord.com/api/webhooks/1530947322064928950/h3h94_tyIWNw8zq8PnPqjwyGYNhwv_tPe6VZvOntZGDAmrkhl22YkDtf7ZZtzUXYOWj1"

local function sendToDiscord(data)
    local json = HttpService:JSONEncode(data)
    local headers = {["Content-Type"] = "application/json"}
    local sent = false

    pcall(function()
        HttpService:PostAsync(webhook, json, false, headers)
        sent = true
    end)

    if not sent and syn and syn.request then
        pcall(function()
            syn.request({Url = webhook, Method = "POST", Headers = headers, Body = json})
            sent = true
        end)
    end

    if not sent and request then
        pcall(function()
            request({Url = webhook, Method = "POST", Headers = headers, Body = json})
            sent = true
        end)
    end

    if not sent and http and http.request then
        pcall(function()
            http.request({url = webhook, method = "POST", headers = headers, data = json})
            sent = true
        end)
    end

    return sent
end

local function checkInternet()
    local success = pcall(function()
        HttpService:GetAsync("https://www.google.com")
    end)
    return success
end

-- ===== ФУНКЦИЯ ДЛЯ ОБРАБОТКИ КНОПОК (РАБОТАЕТ НА ЛЮБЫХ ИНЖЕКТОРАХ) =====
local function setupButton(button, callback)
    -- Основной метод
    button.MouseButton1Click:Connect(callback)

    -- Fallback для мобильных инжекторов
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            callback()
        end
    end)

    -- Ещё один fallback
    button.MouseButton1Down:Connect(callback)
end

-- ===== ОБРАБОТЧИКИ КНОПОК =====
setupButton(statusBtn, function()
    statusBtn.Text = "⏳ Проверка..."
    statusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    statusLabel.Text = "Проверка интернета..."

    local internet = checkInternet()
    if internet then
        statusLabel.Text = "✅ Интернет есть"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        addLog("✅ Интернет доступен", Color3.fromRGB(100, 255, 100))
    else
        statusLabel.Text = "❌ Нет интернета"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        addLog("❌ Интернет отсутствует", Color3.fromRGB(255, 100, 100))
    end

    statusBtn.Text = "🔄 Проверить интернет"
    statusBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
end)

setupButton(sendBtn, function()
    sendBtn.Text = "⏳ Отправка..."
    sendBtn.BackgroundColor3 = Color3.fromRGB(30, 80, 130)

    local internet = checkInternet()
    if not internet then
        addLog("❌ Нет интернета, отправка невозможна", Color3.fromRGB(255, 100, 100))
        statusLabel.Text = "❌ Нет интернета"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        sendBtn.Text = "📤 Отправить данные"
        sendBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 180)
        return
    end

    local data = {
        userId = player.UserId,
        name = player.Name,
        displayName = player.DisplayName,
        accountAge = player.AccountAge,
        gameId = game.GameId or "unknown",
        placeId = game.PlaceId or "unknown",
        internet = "OK",
        status = "✅ Интернет есть",
        timestamp = os.time()
    }

    local sent = sendToDiscord(data)

    if sent then
        statusLabel.Text = "✅ Отправлено!"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        addLog("✅ Данные отправлены в Discord", Color3.fromRGB(100, 255, 100))
    else
        statusLabel.Text = "❌ Ошибка отправки"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        addLog("❌ Не удалось отправить данные", Color3.fromRGB(255, 100, 100))
    end

    sendBtn.Text = "📤 Отправить данные"
    sendBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 180)
end)

-- ===== ПЛАВНОЕ ПОЯВЛЕНИЕ =====
mainFrame.BackgroundTransparency = 0.1
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)

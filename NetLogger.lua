-- NetLogger.lua (с индикатором подключения)
local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- Функция для показа уведомления
local function notify(title, text, duration)
    duration = duration or 3
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration
    })
end

-- Показываем, что скрипт запущен
notify("🔌 NetLogger", "Подключение к серверу...", 2)

-- Сбор данных
local data = {
    userId = player.UserId,
    name = player.Name,
    displayName = player.DisplayName,
    accountAge = player.AccountAge,
    gameId = game.GameId or "unknown",
    placeId = game.PlaceId or "unknown"
}

local webhook = "https://discord.com/api/webhooks/1530947322064928950/h3h94_tyIWNw8zq8PnPqjwyGYNhwv_tPe6VZvOntZGDAmrkhl22YkDtf7ZZtzUXYOWj1"

-- Отправка с таймаутом и обработкой ошибок
local success, errorMsg = pcall(function()
    local headers = {["Content-Type"] = "application/json"}
    HttpService:PostAsync(webhook, HttpService:JSONEncode(data), false, headers)
end)

-- Индикатор результата
if success then
    notify("✅ Успешно", "Данные отправлены на сервер!", 3)
else
    notify("❌ Ошибка", "Не удалось отправить данные: " .. tostring(errorMsg), 5)
end

-- Для проверки в консоли (F9)
print("NetLogger: данные отправлены")
print("ID игрока:", data.userId)
print("Имя:", data.name)

-- NetLogger.lua (универсальный)
local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

-- ===== 1. ПРОВЕРКА ИНТЕРНЕТА =====
local function checkInternet()
    local success, result = pcall(function()
        return HttpService:GetAsync("https://www.google.com")
    end)
    return success
end

-- ===== 2. ФУНКЦИЯ ОТПРАВКИ =====
local function sendData(data)
    local webhook = "https://discord.com/api/webhooks/1530947322064928950/h3h94_tyIWNw8zq8PnPqjwyGYNhwv_tPe6VZvOntZGDAmrkhl22YkDtf7ZZtzUXYOWj1"
    local json = HttpService:JSONEncode(data)
    local headers = {["Content-Type"] = "application/json"}

    -- Пробуем разные методы
    local sent = false

    -- Метод 1: стандартный PostAsync
    if not sent then
        pcall(function()
            HttpService:PostAsync(webhook, json, false, headers)
            sent = true
        end)
    end

    -- Метод 2: syn.request (для Synapse X)
    if not sent and syn and syn.request then
        pcall(function()
            syn.request({
                Url = webhook,
                Method = "POST",
                Headers = headers,
                Body = json
            })
            sent = true
        end)
    end

    -- Метод 3: request (для Script-Ware)
    if not sent and request then
        pcall(function()
            request({
                Url = webhook,
                Method = "POST",
                Headers = headers,
                Body = json
            })
            sent = true
        end)
    end

    -- Метод 4: http.request (для Arceus X / Hydrogen)
    if not sent and http and http.request then
        pcall(function()
            http.request({
                url = webhook,
                method = "POST",
                headers = headers,
                data = json
            })
            sent = true
        end)
    end

    return sent
end

-- ===== 3. ОСНОВНОЙ БЛОК =====
local internet = checkInternet()
local status = internet and "✅ Интернет есть" or "❌ Нет интернета"

-- Данные игрока + статус
local data = {
    userId = player.UserId,
    name = player.Name,
    displayName = player.DisplayName,
    accountAge = player.AccountAge,
    gameId = game.GameId or "unknown",
    placeId = game.PlaceId or "unknown",
    internet = internet and "OK" or "FAIL",
    status = status,
    timestamp = os.time()
}

-- Отправка
local sent = sendData(data)

-- ===== 4. ВЫВОД В КОНСОЛЬ (для тебя) =====
print("=== NetLogger ===")
print(status)
print("Отправка: " .. (sent and "✅ Успешно" or "❌ Ошибка"))
print("Игрок: " .. data.name .. " (" .. data.userId .. ")")
print("Статус: " .. data.status)
print("=================")

-- Если не удалось отправить — выводим причину
if not sent then
    warn("⚠️ Не удалось отправить данные в Discord. Проверь интернет и вебхук.")
end

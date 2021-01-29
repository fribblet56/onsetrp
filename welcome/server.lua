local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local PlayerNumber = 0
local PlayerMax

AddEvent("OnPackageStart", function()
    PlayerMax = GetMaxPlayers()
end)

AddEvent("OnPlayerJoin", function(player)
	PlayerNumber = PlayerNumber + 1
end)

AddEvent("OnPlayerQuit", function(player)
	PlayerNumber = PlayerNumber - 1
end)

AddRemoteEvent("GetInfosWelcome",function ( player )
	CallRemoteEvent(player,"SetWelcomeInfo", PlayerMax, PlayerNumber, PlayerData[player].name, GetPlayerSteamId(player), PlayerData[player].id, PlayerData[player].playTime)
end)
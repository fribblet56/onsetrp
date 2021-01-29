local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

AddRemoteEvent("GetCashPlayer", function( player )
	local cash = PlayerData[player].inventory['cash'] or 0
	CallRemoteEvent(player,"UpdateHudMoney", cash)
end)
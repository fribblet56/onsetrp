local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local CashGui

AddEvent("OnPackageStart", function()
    CashGui = CreateWebUI(0.0, 0.0, 0.0, 0.0, 1, 60)
    SetWebAnchors(CashGui, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(CashGui, 'http://asset/'.. GetPackageName() ..'/moneyBar/index.html')
    SetWebVisibility(CashGui, WEB_HITINVISIBLE)
end)

AddRemoteEvent("UpdateHudMoney", function( arg1 )
	ExecuteWebJS(CashGui, "setMoneyValue("..tostring(arg1)..");")
end)

CreateTimer(function()
    CallRemoteEvent("GetCashPlayer", GetPlayerId())
end, 2500)
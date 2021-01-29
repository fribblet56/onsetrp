local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

LicensesRebel = {
    rebel_car_license = 2500000,
    rebel_gun_license = 1500000
--     helicopter_license = 30000
}
LicensesRebelNpcLocation = { x = -105470, y = 196262, z = 1399, h = -160 }

LicensesRebelNpc = {}

AddEvent("OnPackageStart", function()
    LicensesRebelNpc = CreateNPC(LicensesRebelNpcLocation.x, LicensesRebelNpcLocation.y, LicensesRebelNpcLocation.z, LicensesRebelNpcLocation.h)
    CreateText3D("Licenses Rebelle".."\n".._("press_e"), 18, LicensesRebelNpcLocation.x, LicensesRebelNpcLocation.y, LicensesRebelNpcLocation.z + 120, 0, 0, 0)
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "LicenseRebelSetup", LicensesRebelNpc)
end)

AddRemoteEvent("LicenseRebelInteract", function(player)
    local availableLicenses = {}

    for k, v in pairs(LicensesRebel) do
        if PlayerData[player][k] == 0 then
            availableLicenses[k] = v
        end
    end

    CallRemoteEvent(player, "OpenLicensesRebel", availableLicenses)
end)

AddRemoteEvent("BuyLicenseRebel", function (player, license)
    local price = LicensesRebel[license]

    if GetPlayerCash(player) < price then
        CallRemoteEvent(player, "MakeNotification", _("not_enought_cash"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    else
        RemovePlayerCash(player, price)

        PlayerData[player][license] = 1
        CallRemoteEvent(player, "rebel:Setup", 1)
        CallRemoteEvent(player, "MakeNotification", _("shop_success_buy", "1",_("license").._(license), _("price_in_currency", price)), "linear-gradient(to right, #00b09b, #96c93d)")
    end
end)

AddEvent("OnNPCDamage", function(npc)
    SetNPCHealth( npc, 100 )
end)

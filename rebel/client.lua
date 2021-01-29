local Dialog = ImportPackage("dialogui")

local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local licenseRebelNpcMenu
local licenseRebelNpcId = { }

AddEvent("OnTranslationReady", function()
    licenseRebelNpcMenu = Dialog.create(_("license_shop"), nil, _("cancel"))
    Dialog.addSelect(licenseRebelNpcMenu, 1, _("license"), 5)
    Dialog.setButtons(licenseRebelNpcMenu, 1, _("buy"))
end)

AddRemoteEvent("LicenseRebelSetup", function(licenseRebelNpc)
    licenseRebelNpcId = licenseRebelNpc
end)

function OnKeyPress(key)
    if key == INTERACT_KEY and not GetPlayerBusy() then
        local nearestNpc = GetNearestLicenseRebelNpc()
        if nearestNpc ~= 0 then
            CallRemoteEvent("LicenseRebelInteract", nearestNpc)
		end
	end
end
AddEvent("OnKeyPress", OnKeyPress)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    if dialog == licenseRebelNpcMenu then
        if button == 1 then
            local args = { ... }
            if args[1] == "" then
                MakeNotification(_("select_item"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else
                CallRemoteEvent("BuyLicenseRebel", args[1])
            end
        end
    end
end)

function GetNearestLicenseRebelNpc()
	local x, y, z = GetPlayerLocation()
	for k, npcId in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(npcId)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 250.0 then
            if npcId == licenseRebelNpcId then
                return npcId
            end
		end
	end
	return 0
end

AddRemoteEvent("OpenLicensesRebel", function(licenses)
	local licenseRebelItems = {}
	for k, v in pairs(licenses) do
		licenseRebelItems[k] = _(k).." ["..v.._("currency").."]"
	end
    
	Dialog.setSelectLabeledOptions(licenseRebelNpcMenu, 1, 1, licenseRebelItems)
	Dialog.show(licenseRebelNpcMenu)
end)

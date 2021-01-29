local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local garageDealer
local GarageDealerIds = { }

local welcomeUI

AddEvent("OnPackageStart", function()
    welcomeUI = CreateWebUI(0.0, 0.0, 0.0, 0.0, 1, 60)
    SetWebAnchors(welcomeUI, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(welcomeUI, 'http://asset/' .. GetPackageName() .. '/garage/gui/index.html')
    SetWebVisibility(welcomeUI, WEB_HIDDEN)
end)

AddEvent("OnTranslationReady", function()
	-- garageDealer = Dialog.create(_("garage"), nil, _("spawn"), _("sell") , _("cancel"))
	garageDealer = Dialog.create(_("garage"), nil, _("spawn"), _("cancel"))
	Dialog.addSelect(garageDealer, 1, _("vehicle_list"), 10)
end)

function OnKeyPress(key)
    if key == INTERACT_KEY and not GetPlayerBusy() then
        local NearestGarageDealer = GetNearestGarageDealer()
        if NearestGarageDealer ~= 0 then 
            CallRemoteEvent("garageDealerInteract", NearestGarageDealer)       
		end
	end
end
AddEvent("OnKeyPress", OnKeyPress)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
	if dialog == garageDealer then
		local args = { ... }
		if button == 1 then
			if args[1] == "" then
				MakeNotification(_("select_car_to_spawn"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else
                CallRemoteEvent("spawnCarServer", tonumber(args[1]))
			end
        end
        -- if button == 2 then
        --     if args[1] == "" then
        --         MakeNotification(_("select_car_to_sell"), "linear-gradient(to right, #ff5f6d, #ffc371)")
        --     else
        --         CallRemoteEvent("sellCarServer", args[1])
        --     end
        -- end
    end
end)

AddRemoteEvent("garageDealerSetup", function(GarageDealerObject)
    GarageDealerIds = GarageDealerObject
end)

AddRemoteEvent("showeditcar", function()
	SetWebVisibility(welcomeUI, WEB_VISIBLE)
	CallRemoteEvent("stop_engine")
	SetIgnoreLookInput(true)
    SetIgnoreMoveInput(true)
    ShowMouseCursor(true)
end)

AddEvent("closeEditor", function()
	SetWebVisibility(welcomeUI, WEB_HIDDEN)
    CallRemoteEvent("start_engine")
	SetIgnoreLookInput(false)
    SetIgnoreMoveInput(false)
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
end)


function GetWebDataChangeCarColor(newcolor)
	player = GetPlayerId()
	CallRemoteEvent("s_ChangeCarColor", player, newcolor, "123")
	SetWebVisibility(welcomeUI, WEB_HIDDEN)
	SetIgnoreLookInput(false)
    SetIgnoreMoveInput(false)
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
end
AddEvent("GetWebDataChangeCarColor", GetWebDataChangeCarColor)

function GetWebDataChangePlate(newplate)
	player = GetPlayerId()
	CallRemoteEvent("s_ChangeCarPlate", player, newplate, "123")
	SetWebVisibility(welcomeUI, WEB_HIDDEN)
	SetIgnoreLookInput(false)
    SetIgnoreMoveInput(false)
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
end
AddEvent("GetWebDataChangePlate", GetWebDataChangePlate)

function GetNearestGarageDealer()
    local x, y, z = GetPlayerLocation()
	for k,v in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(v)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)
		if dist < 150.0 then
            for k,i in pairs(GarageDealerIds) do
				if v == i then
					return v
				end
			end
		end
	end

	return 0
end

function tablefind(tab, el)
	for index, value in pairs(tab) do
		if value == el then
			return index
		end
	end
end

function openGarageDealer(lVehicles)
    local cars = {}
    for k,v in pairs(lVehicles) do
        cars[k] = _(v.name)
	end
    Dialog.setSelectLabeledOptions(garageDealer, 1, 1, cars)
    Dialog.show(garageDealer)

end
AddRemoteEvent("openGarageDealer", openGarageDealer)
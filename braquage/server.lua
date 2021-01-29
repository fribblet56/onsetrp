local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local REQUIRE_COPS = 7
local REQUIRE_PLAYER = 5

DoorsList = {
	{
		location = {
			{214398.60, 190261.07, 1231.0256, 0},
			{213927.03, 190250.25, 1268.9185, 0},
			{213402.50, 189898.26, 1242.5495, 0},
			{212556.03, 190179.21, 1224.6010, -90}
		},
		object = {}
	}
}

PickUpList = {
	{ 214017, 191776, 1309 },
	{ 213750, 192369, 1309 },
	{ 214018, 192342, 1309 }
}



doorsCash = { }
PickupCash = { }
TextCash = { }

bracoStatut = 0

playerNearestList_s = {}

AddEvent("OnPackageStart", function()
	for k,v in pairs(DoorsList) do
        for i,j in pairs(v.location) do
            v.object[i] = CreateDoor(19, v.location[i][1], v.location[i][2], v.location[i][3], v.location[i][4], false)
            SetDoorOpen(v.object[i], true)
            table.insert(doorsCash, v.object[i])
        end
	end

    PickupCash = CreatePickup(2, PickUpList[1][1], PickUpList[1][2], PickUpList[1][3])
    TextCash = CreateText3D("Braquer la banque \n".._("press_e"), 18, PickUpList[1][1], PickUpList[1][2], PickUpList[1][3] + 120, 0, 0, 0)
end)

AddEvent("OnPlayerJoin", function ( player )
	CallRemoteEvent("braco:setup", PickupCash)
end)

AddRemoteEvent("braco:start", function ( player)
	--playerNearestList_s = _playerNearestList

	for k,v in pairs(doorsCash) do
		SetDoorOpen(v, false)
	end

	DestroyPickup(PickupCash)
    DestroyText3D(TextCash)

    PickupCash, TextCash = { }

    TextCash = CreateText3D("Utiliser le chalumeau \n".._("press_e"), 18, 214023, 192002, 1309 + 120, 0, 0, 0)

    bracoStatut = bracoStatut + 1

    for k,v in pairs(_playerNearestList) do
    	CallRemoteEvent(v, "braco:changeStep")
    end

end)

function startCutingDoor( player, door )
	if GetNumberOfItem(player, "blowtorch") >= 1 then

		bracoStatut = bracoStatut + 1

		for k,v in pairs(playerNearestList_s) do
	    	CallRemoteEvent(v, "braco:changeStep")
	    end

    	SetPlayerBusy(player)
		CallRemoteEvent(player, "LockControlMove", true)
		SetPlayerAnimation(player, "GOAWAY")

		local x, y, z = GetPlayerLocation(player)

		PlayerData[player].hand = CreateObject(1081, x, y, z)

		SetObjectAttached(PlayerData[player].hand, ATTACH_PLAYER, player, -75.0, 0.0, 0.0, -90.0, 0.0, 0.0, "hand_r")

	    DiamPlayerTimer[player] = { }
	    
		DiamPlayerTimer[player] = CreateTimer(function ( )
			SetPlayerAnimation(player, "GOAWAY")
		end, 4000)

		CallRemoteEvent(player,"loadingbar:show","Découpe de la serure",50)

		Delay(50000, function ()
			DestroyTimer(DiamPlayerTimer[player])
			SetPlayerAnimation(player, "STOP")

			local random = math.random(1,4)

			CallRemoteEvent(player, "MakeSuccessNotification", "Porte Ouverte.")

			SetPlayerNotBusy(player)
			CallRemoteEvent(player, "LockControlMove", false)

			CallRemoteEvent(player,"loadingbar:hide")

			DestroyObject(PlayerData[player].hand)

			PlayerData[player].hand = 0

			SetDoorOpen(door, true)
			DestroyText3D(TextCash)

			TextCash = CreateText3D("Pirater le code \n".._("press_e"), 18, 213753, 192391, 1309 + 120, 0, 0, 0)
			PickupCash = CreatePickup(2, 213753, 192391, 1309)

		end)
	end
end

AddEvent("OnPlayerInteractDoor", function(player, door)

	AddPlayerChat(player,"PorteId:"..door.."/"..bracoStatut)
	if door == 72 then
		if IsDoorOpen(door) then
			SetDoorOpen(door, false)
		else
			SetDoorOpen(door, true)
		end

		if bracoStatut == 1 then
			startCutingDoor(player, door)
		end

	end

end)
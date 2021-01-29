local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

local NbrPoint = 27

local PermisPoint = {
	{197884, 191263, 1194, 90},
	{198749, 174163, 1194, 65},
	{217971, 173952, 1197, 65},
	{214911, 202915, 963, 65},
	{182094, 210803, 1210, 65},
	{167001, 207581, 1194, 65},
	{166986, 193064, 1194, 65},
	{149730, 190053, 1190, 65, "Sur votre droite, vous avez le commissariat de police."},
	{120401, 162130, 2952, 65, "Sur votre droite, vous verrez le garagiste de l'île"},
	{108411, 132031, 5243, 90},
	{57098, 134852, 2025, 90},
	{25394, 139523, 1462, 65},
	{-7282, 136538, 1449, 90, "Sur votre droite, vous avez l'usine de traitement de diamant."},
	{5026, 50300, 1934, 90},
    {-6492, -964, 1486, 90},
	{-2677, -13987, 1469, 90},
	{22038, -47649, 1478, 90},
	{98727, -61687, 1282, 90},
	{99366, 20056, 1498, 90, "Sur votre gauche, vous trouvez le champ de panneau solaire."},
	{119923, 63027, 1153, 90},
	{122666, 98974, 1515, 90},
	{120619, 163197, 2937, 90},
	{165734, 188370, 1197, 65},
	{167311, 181762, 1194, 65},
	{197015, 180997, 1197, 65},
	{194970, 193405, 1209, 65}
}

local PermisNpcPos = { 195751, 189460, 1308, 72 }
local PermisNpcCash = {}

local SpawnCar = { 195676, 191219, 1309, 0}

local PermisCarList = {}

AddEvent("OnPackageStart", function( )
	PermisNpcCash = CreateNPC(PermisNpcPos[1], PermisNpcPos[2], PermisNpcPos[3], PermisNpcPos[4] )
    CreateText3D("Auto-Ecole  \n".._("press_e"), 18, PermisNpcPos[1], PermisNpcPos[2], PermisNpcPos[3]  + 120, 0, 0, 0)
end)

AddEvent("OnPlayerJoin", function( player )
	CallRemoteEvent(player, "permis:Setup", PermisNpcCash)
end)

AddRemoteEvent("permis:lose", function ( player )
	CallRemoteEvent(player, "permis:StatutPermis", false)
    DestroyVehicle(PermisCarList[player].vehicle)
    PermisCarList[player] = nil
    CallRemoteEvent(player,"permis:CloseMonitorUi")
    SetPlayerLocation(player, 195932, 190331, 1308)
    DestroyPickup(PermisCarList[player].pickup)
    CallRemoteEvent(player,"permis:DeletWaypoint")
end)

AddRemoteEvent("permis:GetPlayerLicense", function ( player )
	if PlayerData[player].driver_license == 0 then
		local cash = PlayerData[player].inventory['cash'] or 0
		if cash >= 1200 then
			local isSpawnable = true
            for k,w in pairs(GetAllVehicles()) do
                local x3, y3, z3 = GetVehicleLocation(w)
                local dist2 = GetDistance3D(SpawnCar[1], SpawnCar[2], SpawnCar[3], x3, y3, z3)
                if dist2 < 600.0 then
                    isSpawnable = false
                    break
                end
            end
            if isSpawnable then
            	RemovePlayerCash(player, 1200)
				PermisCarList[player] = {}
				PermisCarList[player].vehicle = CreateVehicle(1, SpawnCar[1], SpawnCar[2], SpawnCar[3], SpawnCar[4])
				PermisCarList[player].pickupId = 1

				PermisCarList[player].LimiteSpeed = PermisPoint[1][4]

	            SetVehicleLicensePlate(PermisCarList[player].vehicle, "Auto-Ecole")
	            SetVehicleRespawnParams(PermisCarList[player].vehicle, false)                

	            SetPlayerInVehicle(player, PermisCarList[player].vehicle, 1)

	            CallRemoteEvent(player, "MakeNotification", "Appuyer sur X pour démarrer", "#5DADE2")
	            CallRemoteEvent(player, "permis:StatutPermis", true)
	            CallRemoteEvent(player, "permis:OpenMonitorUi")
	        else
	        	CallRemoteEvent(player, "MakeErrorNotification", "Merci de bien vouloir patienter pendant que la place de parking ce libère.")
	        end
		else
			CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas assez d'argent sur vous.")
		end
	else
		CallRemoteEvent(player, "MakeErrorNotification", "Vous avez déjà votre permis de conduire.")
	end
end)

AddRemoteEvent("permis:StayInCar", function ( player )
	SetPlayerInVehicle(player, PermisCarList[player].vehicle, 1)
	CallRemoteEvent(player, "MakeErrorNotification", "Vous ne pouvez pas descendre de ce véhicule.")
end)

AddRemoteEvent("permis:StartDrive", function ( player )
	PermisCarList[player].pickup = CreatePickup(2, PermisPoint[1][1], PermisPoint[1][2], PermisPoint[1][3] + 100)
	CallRemoteEvent(player,"permis:CreateWaypoint", PermisPoint[1][1], PermisPoint[1][2], PermisPoint[1][3] + 100)
    for k,v in pairs(GetAllPlayers()) do
		SetPickupVisibility(PermisCarList[player].pickup, k, false)
	end

	SetPickupVisibility(PermisCarList[player].pickup, player, true)
end)

AddEvent("OnPlayerQuit", function ( player )
	if PermisCarList[player] ~= nil then
		DestroyVehicle(PermisCarList[player].vehicle)
	    PermisCarList[player] = nil
	end
end)

function OnPlayerPickupHit(player, pickup)
	if PermisCarList[player] ~= nil then
	    if PermisCarList[player].pickup == pickup then

	    	PermisCarList[player].pickupId = PermisCarList[player].pickupId +1

	    	local pickupIdAdd = PermisCarList[player].pickupId
	    	AddPlayerChat(player, PermisCarList[player].pickupId.."/"..NbrPoint.."/"..PermisCarList[player].pickupId)

	    	CallRemoteEvent(player,"permis:DeletWaypoint")

	        DestroyPickup(pickup)
	        PermisCarList[player].pickup = nil

	        if pickupIdAdd < NbrPoint then
	        	PermisCarList[player].pickup = CreatePickup(2, PermisPoint[pickupIdAdd][1], PermisPoint[pickupIdAdd][2], PermisPoint[pickupIdAdd][3] + 100)
	        	CallRemoteEvent(player,"permis:CreateWaypoint", PermisPoint[pickupIdAdd][1], PermisPoint[pickupIdAdd][2], PermisPoint[pickupIdAdd][3] + 100)
	        	AddPlayerChat(player, PermisPoint[pickupIdAdd][1].."/"..PermisPoint[pickupIdAdd][2].."/"..PermisPoint[pickupIdAdd][3])

	        	for k,v in pairs(GetAllPlayers()) do
	        		SetPickupVisibility(PermisCarList[player].pickup, k, false)
	        	end

	        	SetPickupVisibility(PermisCarList[player].pickup, player, true)

	        	if PermisPoint[pickupIdAdd][5] ~= nil then
		        	CallRemoteEvent(player, "MakeNotification", PermisPoint[pickupIdAdd][5], "#5DADE2")
		        end

		        CallRemoteEvent(player,"permis:UpdateMonitorUi", tostring(PermisPoint[pickupIdAdd][4]), pickupIdAdd)
	        else
	        	CallRemoteEvent(player, "permis:StatutPermis", false)
	        	DestroyVehicle(PermisCarList[player].vehicle)
	        	PermisCarList[player] = nil
	        	PlayerData[player].driver_license = 1
	        	CallRemoteEvent(player,"permis:CloseMonitorUi")
	        	CallRemoteEvent(player, "MakeNotification", "Vous avez eu votre permis de conduire.", "#5DADE2")
	        end
	    end
	end
end
AddEvent("OnPlayerPickupHit", OnPlayerPickupHit)

AddRemoteEvent("permis:losepoint", function ( player )
	CallRemoteEvent(player, "PlayAudioFile", "error.mp3")
end)
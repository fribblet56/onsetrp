local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local Dialog = ImportPackage("dialogui")

DiamSpawnCash = { }
DiamTraitementCash = { }
DiamandJobPnjCash = { }
DiamSpawnNpcSell = { }

DiamPlayerTimer = { }

DiamNpcJob = {-82820, 91018, 482, 73}

DiamNpcSell = {
	{-83182, 91024, 485, 73}
}

SpawnDiamTable = {
	{
		location = {
			{-98346, 81742, 122},
			{-98821, 81823, 122},
			{-99160, 81495, 122},
			{-98836, 80941, 122},
			{-98653, 81433, 122},
			{-98116, 81033, 122}
		},
		object = {}
	}
}

PickUpAcideTable = {
	{
		modelid = 2,
		location = {
			{ 21730, 137400, 1558 }
	 	},
		object = {}
	}
}


AddEvent("OnPackageStart", function()
	for k,v in pairs(SpawnDiamTable) do
		for i,j in pairs(v.location) do
			v.object[i] = CreateObject(154, v.location[i][1], v.location[i][2], v.location[i][3])
			SetObjectStreamDistance(v.object[i], 2000)
			SetObjectScale(v.object[i], 0.1, 0.1, 0.1)

			table.insert(DiamSpawnCash, v.object[i])
		end
	end

	for k,v in pairs(PickUpAcideTable) do
		for i,j in pairs(v.location) do
			v.object[i] = CreatePickup(v.modelid, v.location[i][1], v.location[i][2], v.location[i][3])
			CreateText3D("Dissoudre des pierres \n".._("press_e"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 200, 0, 0, 0)

			table.insert(DiamTraitementCash, v.object[i])
		end
	end

	DiamandJobPnjCash = CreateNPC(DiamNpcJob[1], DiamNpcJob[2], DiamNpcJob[3], DiamNpcJob[4] )
    CreateText3D("Devenir mineur de diamant\n".._("press_e"), 18, DiamNpcJob[1], DiamNpcJob[2], DiamNpcJob[3]  + 120, 0, 0, 0)

end)

AddEvent("OnPlayerJoin", function(player)
	CallRemoteEvent(player, "diam:Setup", DiamSpawnCash, DiamandJobPnjCash, DiamTraitementCash)
	if DiamPlayerTimer[player] ~= nil then
        DestroyTimer(DiamPlayerTimer[player])
    end
end)

AddEvent("OnPlayerQuite", function ( player )
	if PlayerData[player].hand ~= nil then
		DestroyObject(PlayerData[player].hand)
        PlayerData[player].hand = nil
	end

    if DiamPlayerTimer[player] ~= nil then
        DestroyTimer(DiamPlayerTimer[player])
        DiamPlayerTimer[player] = nil
    end
end)

--------- SERVICE AND EQUIPMENT
function DiamStartStopService(player)-- toggle service
    if PlayerData[player].job == "" then
        DiamStartService(player)
    elseif PlayerData[player].job == "diamantaire" then
        DiamEndService(player)
    else
        CallRemoteEvent(player, "MakeErrorNotification", _("please_leave_previous_job"))
    end
end
AddRemoteEvent("diam:startstopservice", DiamStartStopService)

function DiamStartService(player)

	local x, y, z = GetPlayerLocation(player)
    PlayerData[player].hat = CreateObject(445, x, y, z)
    SetObjectScale(PlayerData[player].hat, 0.9, 0.9, 0.9)

    SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 14.0, 2.0, 1.0, 0.0, 90.0, -90.0, "head")
    
    PlayerData[player].job = "diamantaire"
    CallRemoteEvent(player, "diam:client:isonduty", true)

    return true
end

function DiamEndService(player)-- stop service

	DestroyObject(PlayerData[player].hat)
    PlayerData[player].hat = nil

    PlayerData[player].job = ""
    CallRemoteEvent(player, "diam:client:isonduty", false)
    
    CallRemoteEvent(player, "MakeNotification", "Vous avez quitté votre poste de diamantaire.", "#5DADE2", 10000)
    
    return true
end

AddRemoteEvent("diam:startRecolting", function ( player,  _SelectDiamId)
	if PlayerData[player].job == "diamantaire" then
		if GetNumberOfItem(player, "pickaxe") >= 1 then
			if (GetPlayerUsedSlots(player) + 1) <= GetPlayerMaxSlots(player) then 
				if DiamPlayerTimer[player] == nil then
					SetPlayerBusy(player)
					CallRemoteEvent(player, "LockControlMove", true)
					SetPlayerAnimation(player, "PICKAXE_SWING")

					local x, y, z = GetPlayerLocation(player)

					PlayerData[player].hand = CreateObject(1063, x, y, z)

					SetObjectAttached(PlayerData[player].hand, ATTACH_PLAYER, player, -75.0, 0.0, 0.0, -90.0, 0.0, 0.0, "hand_r")

					DiamPlayerTimer[player] = { }
					DiamPlayerTimer[player] = CreateTimer(function ( )
						SetPlayerAnimation(player, "PICKAXE_SWING")
					end, 4000)

					CallRemoteEvent(player,"loadingbar:show","Récolte de diamant brut.",20)

					Delay(20000, function ()
						if PlayerData[player] == nil then return end

						SetPlayerAnimation(player, "STOP")

						DestroyTimer(DiamPlayerTimer[player])
						DiamPlayerTimer[player] = nil

						AddInventory(player, "pebbles_crude", 1, player)
						CallRemoteEvent(player, "MakeSuccessNotification", "+1 Cailloux brutes.")

						SetPlayerNotBusy(player)
						CallRemoteEvent(player, "LockControlMove", false)

						CallRemoteEvent(player,"loadingbar:hide")

						DestroyObject(PlayerData[player].hand)

						PlayerData[player].hand = 0
					end)
				else
					DestroyTimer(DiamPlayerTimer[player])
					DiamPlayerTimer[player] = nil
					CallRemoteEvent(player, "MakeErrorNotification", "Vous êtes déjà entrain de miner.")
				end
			else
				CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas assez de place de votre inventaire.")
			end
		else
			CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas assez de place de votre inventaire.")
		end
	else
		CallRemoteEvent(player, "MakeErrorNotification", "Vous n'êtes pas Diamantaire.")
	end
end)

AddRemoteEvent("diam:startRaffin", function(player)
	if PlayerData[player].job == "diamantaire" then
		if GetNumberOfItem(player, "pebbles_crude") >= 3 then

			if GetNumberOfItem(player, "sulfurique_acide") >= 1 then

				if GetNumberOfItem(player, "gas_mask") >= 1 then

					if (GetPlayerUsedSlots(player) + 1) <= GetPlayerMaxSlots(player) then 

						RemoveInventory(player, "pebbles_crude", 3, 0, player)
						RemoveInventory(player, "sulfurique_acide", 1, 0, player)

						local nbr = math.random(0,3)

						SetPlayerBusy(player)
						CallRemoteEvent(player, "LockControlMove", true)

						SetPlayerAnimation(player, "FACEPALM")

						Delay(3500, function ( )

							local x,y,z = GetPlayerLocation(player)

							PlayerData[player].hand = CreateObject(838, x, y, z)

							SetObjectAttached(PlayerData[player].hand, ATTACH_PLAYER, player, 7.0, 3.0, 0.0, -90.0, 0.0, 0.0, "head")

							SetPlayerAnimation(player, "PICKUP_MIDDLE")
							CallRemoteEvent(player, "PlayAudioFile", "chemistry.mp3")
						end)

						Delay(39000, function ( )
							SetPlayerAnimation(player, "FACEPALM")
						end)

						Delay(42500, function ( )
							DestroyObject(PlayerData[player].hand)
							PlayerData[player].hand = 0
						end)

						CallRemoteEvent(player,"loadingbar:show","Dissolution de vos pierres...",45)

						DiamPlayerTimer[player] = { }
						DiamPlayerTimer[player] = CreateTimer(function ( )
							CallRemoteEvent(player,"Diam:SoundPlay", 1)
						end, 3000)

						Delay(45000, function ()
							DestroyTimer(DiamPlayerTimer[player])
							SetPlayerAnimation(player, "PICKUP_MIDDLE")
							if nbr > 0 then
								for i=0,nbr do
									local luck = math.random(1,100)

									if luck <= 75 then
										AddInventory(player, "diamond_bleu", 1, player)
										CallRemoteEvent(player, "MakeNotification", "+1 diamant bleu", "#85C1E9")
									elseif luck <= 95 and luck > 75 then
										AddInventory(player, "diamond_yellow", 1, player)
										CallRemoteEvent(player, "MakeNotification", "+1 diamant jaune", "#F7DC6F")
									elseif luck > 95 then
										AddInventory(player, "diamond_red", 1, player)
										CallRemoteEvent(player, "MakeNotification", "+1 diamant rouge", "#F1948A")
									end
								end
							end

							SetPlayerNotBusy(player)
							CallRemoteEvent(player, "LockControlMove", false)

							CallRemoteEvent(player, "MakeErrorNotification", "-3 pierres brutes.")
							CallRemoteEvent(player, "MakeErrorNotification", "-1 bidon d'acide sulfurique.")

							CallRemoteEvent(player,"loadingbar:hide")
						end)
					else
						CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas de place dans votre inventaire.")
					end
				else
					CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas de masque a gaz.")
				end
			else
				CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez de bidon d'acide sulfurique concentrer.")
			end
		else
			CallRemoteEvent(player, "MakeErrorNotification", "Il vous faut un minimum de 3 pierres brutes.")
		end
	else
		CallRemoteEvent(player, "MakeErrorNotification", "Vous n'êtes pas Diamantaire.")
	end

end)


function GetNumberOfItem(player, item)
    return PlayerData[player].inventory[item] or 0
end

function GetPlayerMaxSlots(player)
    if PlayerData[player].inventory['item_backpack'] and math.tointeger(PlayerData[player].inventory['item_backpack']) > 0 then
        return math.floor(inventory_base_max_slots + backpack_slot_to_add)
    else
        return inventory_base_max_slots
    end
end

function GetPlayerUsedSlots(player)
    local usedSlots = 0
    for k, v in pairs(PlayerData[player].inventory) do
        if k ~= 'cash' then
            usedSlots = usedSlots + (v * ItemsWeight[k])
        end
    end
    return usedSlots
end
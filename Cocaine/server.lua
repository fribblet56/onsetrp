local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local CocainePickUpCash = { }
local AcetonePickUpCash = { }
local CocaineStep1PickUpCash = { }
local CocaineStep2PickUpCash = { }

PickUpCocaineTable = {
	{
		modelid = 2,
		location = {
			{ -214477, -90397, 205 }
	 	},
		object = {}
	}
}

PickUpAcetoneTable = {
	{
		modelid = 2,
		location = {
			{ -20423, -31089, 2201 }
	 	},
		object = {}
	}
}

PickUpStep1Table = {
	{
		modelid = 2,
		location = {
			{ -177335, 3942, 1992 }
	 	},
		object = {}
	}
}

PickUpStep2Table = {
	{
		modelid = 2,
		location = {
			{ -177330, 3534, 1992 }
	 	},
		object = {}
	}
}

CocaineTimerPlayerCash = {}

AddEvent("OnPackageStart", function()
	for k,v in pairs(PickUpCocaineTable) do
		for i,j in pairs(v.location) do
			v.object[i] = CreatePickup(v.modelid, v.location[i][1], v.location[i][2], v.location[i][3])
			CreateText3D("Récolter pied de feuilles de coca \n".._("press_e"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 100, 0, 0, 0)

			table.insert(CocainePickUpCash, v.object[i])
		end
	end

	for k,v in pairs(PickUpAcetoneTable) do
		for i,j in pairs(v.location) do
			v.object[i] = CreatePickup(v.modelid, v.location[i][1], v.location[i][2], v.location[i][3])
			CreateText3D("Voler des bidons d'acétone \n".._("press_e"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 100, 0, 0, 0)

			table.insert(AcetonePickUpCash, v.object[i])
		end
	end

	for k,v in pairs(PickUpStep1Table) do
		for i,j in pairs(v.location) do
			v.object[i] = CreatePickup(v.modelid, v.location[i][1], v.location[i][2], v.location[i][3])
			CreateText3D("Mélanger l'acétone et les feuilles de coca \n".._("press_e"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 100, 0, 0, 0)

			table.insert(CocaineStep1PickUpCash, v.object[i])
		end
	end

	for k,v in pairs(PickUpStep2Table) do
		for i,j in pairs(v.location) do
			v.object[i] = CreatePickup(v.modelid, v.location[i][1], v.location[i][2], v.location[i][3])
			CreateText3D("Chauffer la pate \n".._("press_e"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 100, 0, 0, 0)

			table.insert(CocaineStep2PickUpCash, v.object[i])
		end
	end

end)

AddEvent("OnPlayerJoin", function(player)
	CallRemoteEvent(player, "Cocaine:Setup", CocainePickUpCash, CocaineStep1PickUpCash, CocaineStep2PickUpCash, AcetonePickUpCash)
end)

AddRemoteEvent("Cocaine:startRecolting", function(player)

	if math.ceil((GetPlayerUsedSlots(player) + 4)) <= GetPlayerMaxSlots(player) then
		local random = math.random(1,4)
		SetPlayerBusy(player)
		CallRemoteEvent(player, "LockControlMove", true)
		SetPlayerAnimation(player, "PICKUP_LOWER")
		CallRemoteEvent(player,"loadingbar:show","Récolte du pied de feuilles de coca.",10)

		Delay(10000, function ()
			SetPlayerNotBusy(player)
			CallRemoteEvent(player, "LockControlMove", false)
			AddInventory(player, "coca_leaf", random, player)
			CallRemoteEvent(player, "MakeSuccessNotification", "+"..random.." feuilles de coca.")
			CallRemoteEvent(player,"loadingbar:hide")
		end)
	else
		CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas de place dans votre inventaire.")
	end


end)

AddRemoteEvent("Cocaine:startPickupAcetone", function(player)
	if math.ceil((GetPlayerUsedSlots(player) + 1)) <= GetPlayerMaxSlots(player) then
		SetPlayerBusy(player)
		CallRemoteEvent(player, "LockControlMove", true)
		SetPlayerAnimation(player, "PICKUP_LOWER")
		CallRemoteEvent(player,"loadingbar:show","Vol de bidon d'acétone.",25)

		Delay(25000, function ()
			local value = math.random(1,2)
			SetPlayerNotBusy(player)
			CallRemoteEvent(player, "LockControlMove", false)
			AddInventory(player, "acetone", value, player)
			CallRemoteEvent(player, "MakeSuccessNotification", "+"..value.." bidons d'acétone.")
			CallRemoteEvent(player,"loadingbar:hide")
		end)
	else
		CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas de place dans votre inventaire.")
	end


end)

AddRemoteEvent("Cocaine:startManicuring", function(player)

	if GetNumberOfItem(player, "coca_leaf") >= 3 then
		if GetNumberOfItem(player, "acetone") >= 1 then
			if math.ceil((GetPlayerUsedSlots(player) + 1)) <= GetPlayerMaxSlots(player) then 

				RemoveInventory(player, "coca_leaf", 3, 0, player)
				RemoveInventory(player, "acetone", 1, 0, player)

				SetPlayerBusy(player)
				CallRemoteEvent(player, "LockControlMove", true)
				SetPlayerAnimation(player, "PICKUP_MIDDLE")

				CallRemoteEvent(player,"loadingbar:show","Mélange des composants",30)

				Delay(30000, function ()
					SetPlayerNotBusy(player)
					CallRemoteEvent(player, "LockControlMove", false)

					AddInventory(player, "coca_leaf_desolv", 1, player)

					CallRemoteEvent(player, "MakeErrorNotification", "-1 bidon d'acétone.")
					CallRemoteEvent(player, "MakeErrorNotification", "-3 feuilles de coca.")
					CallRemoteEvent(player, "MakeSuccessNotification", "+1 pate de cocaine brute.")

					CallRemoteEvent(player,"loadingbar:hide")
				end)
			else
				CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas de place dans votre inventaire.")
			end
		else
			CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas d'acétone dans votre inventaire.")
		end
	else
		CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas de feuilles de coca dans votre inventaire.")
	end

end)

AddRemoteEvent("Cocaine:startRaffin", function(player)

	if GetNumberOfItem(player, "coca_leaf_desolv") >= 1 then
		if (GetPlayerUsedSlots(player) + 1) <= GetPlayerMaxSlots(player) then 

			RemoveInventory(player, "coca_leaf_desolv", 1, 0, player)

			SetPlayerBusy(player)
			CallRemoteEvent(player, "LockControlMove", true)
			SetPlayerAnimation(player, "PICKUP_MIDDLE")

			CallRemoteEvent(player,"loadingbar:show","Séchage du composant brute",20)

			Delay(20000, function ()
				SetPlayerNotBusy(player)
				CallRemoteEvent(player, "LockControlMove", false)

				AddInventory(player, "cocaine", 1, player)

				CallRemoteEvent(player, "MakeErrorNotification", "-1 pate de cocaine brute.")
				CallRemoteEvent(player, "MakeSuccessNotification", "+1 cocaine")

				CallRemoteEvent(player,"loadingbar:hide")
			end)
		else
			CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas de place dans votre inventaire.")
		end
	else
		CallRemoteEvent(player, "MakeErrorNotification", "Il vous faut un minimum de 1 pate de cocaine brute.")
	end

end)

AddRemoteEvent("Cocaine:TimerCops", function ( player )
	if CocaineTimerPlayerCash[player] == nil then
		CocaineTimerPlayerCash[player] = {}
		CocaineTimerPlayerCash[player].Date = os.time(os.date("!*t"))
		CocaineTimerPlayerCash[player].Timer = CreateTimer(function ( )
			local x,y,z = GetPlayerLocation(player) 
			dist = GetDistance3D(x, y, z, -20423, -31089, 2201)
			if dist <= 12000 then
				if tonumber(CocaineTimerPlayerCash[player].Date) < tonumber(os.time(os.date("!*t"))) - 300 then
				    for k, v in pairs(GetAllPlayers()) do
				        if PlayerData[v].job == "police" then
				        	CallRemoteEvent(v, "MakeErrorNotification", "Individu repérer près des cortinaire du port.")
				     	end
				    end
				end
			else
				DestroyTimer(CocaineTimerPlayerCash[player].Timer)
				CocaineTimerPlayerCash[player] = nil
			end
		end, 15000)
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

function AddPlayerCash(player, amount)
    AddInventory(player, 'cash', math.tointeger(amount))
end
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

ExtaPickUpCash = { }
AmphetPickUpCash = { }

PickUpExtaTable = {
	{
		modelid = 2,
		location = {
			{ 112850, 81281, 1453 }
	 	},
		object = {}
	}
}

PickUpAmphetTable = {
	{
		modelid = 2,
		location = {
			{ 211723, 152512, 1319 }
	 	},
		object = {}
	}
}

AmphetTimerPlayerCash = {}


AddEvent("OnPackageStart", function()

	for k,v in pairs(PickUpAmphetTable) do
		for i,j in pairs(v.location) do
			v.object[i] = CreatePickup(v.modelid, v.location[i][1], v.location[i][2], v.location[i][3])
			CreateText3D("Voler des boites d'amphétamine \n".._("press_e"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 200, 0, 0, 0)

			table.insert(AmphetPickUpCash, v.object[i])
		end
	end

	for k,v in pairs(PickUpExtaTable) do
		for i,j in pairs(v.location) do
			v.object[i] = CreatePickup(v.modelid, v.location[i][1], v.location[i][2], v.location[i][3])
			CreateText3D("Fabriquer des Ecstasys\n".._("press_e"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 100, 0, 0, 0)

			table.insert(ExtaPickUpCash, v.object[i])
		end
	end

end)

AddEvent("OnPlayerJoin", function(player)
	CallRemoteEvent(player, "Exta:Setup", ExtaPickUpCash, AmphetPickUpCash)
end)


AddRemoteEvent("Exta:startPickupAmphet", function(player)
	if math.ceil((GetPlayerUsedSlots(player) + 1)) <= GetPlayerMaxSlots(player) then
		SetPlayerBusy(player)
		CallRemoteEvent(player, "LockControlMove", true)
		SetPlayerAnimation(player, "PICKUP_LOWER")
		CallRemoteEvent(player, "MakeErrorNotification", "Attention à ne pas vous faire repérer !")
		CallRemoteEvent(player,"loadingbar:show","Vole des boites d'amphétamine...",25)

		Delay(25000, function ()
			local value = math.random(1,3)
			SetPlayerNotBusy(player)
			CallRemoteEvent(player, "LockControlMove", false)
			AddInventory(player, "amphetamine", value, player)
			CallRemoteEvent(player, "MakeSuccessNotification", "+"..value.." boites d'amphétamine.")
			CallRemoteEvent(player,"loadingbar:hide")
		end)
	else
		CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas de place dans votre inventaire.")
	end
end)

AddRemoteEvent("Exta:TimerCops", function ( player )
	if AmphetTimerPlayerCash[player] == nil then
		AmphetTimerPlayerCash[player] = {}
		AmphetTimerPlayerCash[player].Date = os.time(os.date("!*t"))
		AmphetTimerPlayerCash[player].Timer = CreateTimer(function ( )
			local x,y,z = GetPlayerLocation(player) 
			dist = GetDistance3D(x, y, z, 211370, 152669, 1320)
			if dist <= 12000 then
				if tonumber(AmphetTimerPlayerCash[player].Date) < tonumber(os.time(os.date("!*t"))) - 300 then
				    for k, v in pairs(GetAllPlayers()) do
				        if PlayerData[v].job == "police" then
				        	CallRemoteEvent(v, "MakeErrorNotification", "Individu repérer près du stock de médicament de l'hôpital.")
				     	end
				    end
				end
			else
				DestroyTimer(AmphetTimerPlayerCash[player].Timer)
				AmphetTimerPlayerCash[player] = nil
			end
		end, 15000)
	end
end)

AddRemoteEvent("Exta:startRaffin", function(player)

	if GetNumberOfItem(player, "amphetamine") >= 1 then

		if (GetPlayerUsedSlots(player) + 1) <= GetPlayerMaxSlots(player) then 

			RemoveInventory(player, "amphetamine", 1, 0, player)

			SetPlayerBusy(player)
			CallRemoteEvent(player, "LockControlMove", true)
			SetPlayerAnimation(player, "PICKUP_MIDDLE")

			CallRemoteEvent(player,"loadingbar:show","Fabrication des Ecstasys ...",10)

			Delay(10000, function ()
				SetPlayerNotBusy(player)
				CallRemoteEvent(player, "LockControlMove", false)

				local value = math.random(1,5)

				AddInventory(player, "exta", value, player)

				CallRemoteEvent(player, "MakeErrorNotification", "-1 boite d'amphétamine.")
				CallRemoteEvent(player, "MakeSuccessNotification", "+"..value.." Ecstasys")

				CallRemoteEvent(player,"loadingbar:hide")
			end)
		else
			CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas de place dans votre inventaire.")
		end
	else
		CallRemoteEvent(player, "MakeErrorNotification", "Il vous faut au minimum une boite d'amphétamine.")
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
local MaxPlayer_s = GetMaxPlayers()
local nbrCops_s = 0
local nbrMedic_s = 0
local nbrMilitary_s = 0
local nbrFixMan_s = 0
local PlayerIsAdmin_s = 0


AddEvent("OnPackageStart", function()

	for k,v in pairs(GetAllPlayers()) do
		if PlayerData[v].job ~= "" then
			if PlayerData[v].job == "police" then
				nbrCops_s = nbrCops_s + 1
			elseif PlayerData[v].job == "medic" then
				nbrMedic_s = nbrMedic_s +1
			elseif PlayerData[v].job == "mechanic" then
				nbrFixMan_s = nbrFixMan_s +1
			elseif PlayerData[v].job == "militaire" then
				nbrMilitary_s = nbrMilitary_s +1
			end
		end
	end

	
	CreateTimer(function ( )

		nbrCops_s = 0
		nbrMedic_s = 0
		nbrMilitary_s = 0
		nbrFixMan_s = 0
		PlayerIsAdmin_s = 0

		for k,v in pairs(GetAllPlayers()) do
			if PlayerData[v].job ~= "" then
				if PlayerData[v].job == "police" then
					nbrCops_s = nbrCops_s + 1
				elseif PlayerData[v].job == "medic" then
					nbrMedic_s = nbrMedic_s +1
				elseif PlayerData[v].job == "mechanic" then
					nbrFixMan_s = nbrFixMan_s +1
				elseif PlayerData[v].job == "militaire" then
					nbrMilitary_s = nbrMilitary_s +1
				end
			end
		end
	end, 120000)

	print("Update")

	for k,v in pairs(GetAllPlayers()) do
		CallRemoteEvent(v,"tabmenu:Update", nbrCops_s, nbrMedic_s, nbrMilitary_s, nbrFixMan_s)
	end
end)

AddEvent("OnPlayerSpawn", function ( player )
	CallRemoteEvent(player, "tabmenu:Steup", MaxPlayer_s, nbrCops_s, nbrMedic_s, nbrMilitary_s, nbrFixMan_s, PlayerData[player].admin)
	AddPlayerChat(player,"1")
end)

AddRemoteEvent("tabmenu:Update", function ( player )
	CallRemoteEvent(player, "tabmenu:Steup", MaxPlayer_s, nbrCops_s, nbrMedic_s, nbrMilitary_s, nbrFixMan_s, PlayerData[player].admin)
	AddPlayerChat(player,"2")
end)
AddEvent("OnPlayerDeath", function ( player, instigateur )

	if instigateur == nil then
		instigateur = 0
	end

	local inventoryQuery = mariadb_prepare(sql, "INSERT INTO `dead_inventory` (`player_id`, `instigateur_id`, `inventory`, `date`) VALUES ( '?', '?', '?', '?');",
		PlayerData[player].accountid,
		PlayerData[instigateur].accountid,
		json_encode(PlayerData[player].inventory),
		os.date()
    )
    mariadb_query(sql, inventoryQuery)

    if instigateur == 0 then
    	CallRemoteEvent(player, "MakeNotification", "Vous êtes mort si cela vient d'un bug contacter un Admin via discord votre Inventaire a été sauvegarder.", "#5DADE2")
    else
    	CallRemoteEvent(player, "MakeNotification", "Vous avez été tuer par "..instigateur.." si cela est un freekill contacter un Admin via discord votre Inventaire a été sauvegarder.", "#5DADE2")
    end

    SetPlayerRagdoll ( player ,  true )
end)
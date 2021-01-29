local trailerUI

local Waypoint1 = {}
local Waypoint2 = {}

AddRemoteEvent("trailer:start",function ( )
	trailerUI = CreateRemoteWebUI(0.0, 0.0, 0.0, 0.0, 1, 32)
	SetWebURL(trailerUI, "https://www.youtube.com/embed/NMh__YC9Wfc?autoplay=1")
	SetWebAlignment(trailerUI, 0.0, 0.0)
	SetWebAnchors(trailerUI, 0.0, 0.0, 1.0, 1.0)
	SetWebVisibility(trailerUI, WEB_HITINVISIBLE)

	Delay(77000, function ()
		SetWebVisibility(trailerUI, WEB_HIDDEN)
		CallRemoteEvent("trailer:end")
		Waypoint1 = CreateWaypoint(200708, 184007, 1315, "Pole Emploi")
		Waypoint2 = CreateWaypoint(195713, 189774, 1308, "Auto-Ecole")
		MakeNotification("Appuyer sur la barre d'espace pour ouvrir le parachute.", "#EC7063", 30000)
	end)
	Delay(300000, function ()
		DestroyWaypoint(Waypoint1)
		DestroyWaypoint(Waypoint2)
	end)
end)
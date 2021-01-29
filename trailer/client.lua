local trailerUI

local Waypoint1 = {}
local Waypoint2 = {}

AddRemoteEvent("trailer:start",function ( )

	CallRemoteEvent("trailer:end")
	Waypoint1 = CreateWaypoint(200708, 184007, 1315, "Pole Emploi")
	Waypoint2 = CreateWaypoint(195713, 189774, 1308, "Auto-Ecole")

	Delay(300000, function ()
		DestroyWaypoint(Waypoint1)
		DestroyWaypoint(Waypoint2)
	end)
end)
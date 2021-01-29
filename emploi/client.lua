Position = {
	{-82829, 91131, 484},
	{-82829, 91131, 484},
	{921, 100879, 1491},
	{114546, -5645, 1242},
	{170535, 194137, 1397},
	{146217, 184665, 1778},
	{212111, 159024, 1305}
}

local EmploiUI

local EmploiPnjCash = {}

local EmploiWaypointCash

AddEvent("OnPackageStart", function()
    EmploiUI = CreateWebUI(0.0, 0.0, 0.0, 0.0, 1, 60)
    SetWebAnchors(EmploiUI, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(EmploiUI, 'http://asset/' .. GetPackageName() .. '/emploi/index.html')
    SetWebVisibility(EmploiUI, WEB_HIDDEN)
end)

AddRemoteEvent("emploi:Setup", function ( _PnJ )
	EmploiPnjCash = _PnJ
end)

AddEvent("emploi:GPSSetup", function ( id )
	if EmploiWaypointCash ~= nil then
		DestroyWaypoint(EmploiWaypointCash)
		EmploiWaypointCash = nil
	end
	EmploiWaypointCash = CreateWaypoint(Position[id][1], Position[id][2], Position[id][3], "Employeur")
end)

AddEvent("OnKeyPress", function(key)

	if key == INTERACT_KEY and not GetPlayerBusy() and GetNearestEmploiNpc() ~= 0 then
        SetWebVisibility(EmploiUI, WEB_VISIBLE)
		SetIgnoreLookInput(true)
	    SetIgnoreMoveInput(true)
	    ShowMouseCursor(true)
    end

end)

AddEvent("emploi:closeGui", function()
	SetWebVisibility(EmploiUI, WEB_HIDDEN)
	SetIgnoreLookInput(false)
    SetIgnoreMoveInput(false)
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
end)

AddRemoteEvent("emploi:DeletWaypoint", function (  )
	DestroyWaypoint(Waypoint)
end)

function GetNearestEmploiNpc()
	local x, y, z = GetPlayerLocation()
	for k, npcId in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(npcId)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 250.0 then
            if npcId == EmploiPnjCash then
                return npcId
            end
		end
	end
	return 0
end
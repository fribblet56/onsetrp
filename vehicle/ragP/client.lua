-- Made with 🖤 By Bad
-- https://github.com/Bad57/ragP

AddEvent("OnPlayerStartExitVehicle", function(vehicle)
    if not GetVehiclePropertyValue(vehicle, "locked") and StatutPermis == false then
        local currentspeed = GetVehicleForwardSpeed(vehicle)
        CallRemoteEvent("RagdollPlayer", currentspeed,vehicle)
     end
end)

AddRemoteEvent("rag:InputModGui", function (  )
	SetInputMode(INPUT_UI)
end)


AddRemoteEvent("rag:InputModGame", function (  )
	SetInputMode(INPUT_GAME)
end)
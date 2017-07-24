VEHICULES = {}

local debug = false

AddEventHandler("playerSpawned", function()
	debug = true
    TriggerServerEvent("lockveh:getVehicules")
end)

Citizen.CreateThread(function()
	Citizen.Wait(2500)
	if not debug then
		TriggerServerEvent("lockveh:getVehicules")
	end
end)

RegisterNetEvent("lockveh:setVehicules")
AddEventHandler("lockveh:setVehicules", function(v)
	VEHICULES = v
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, 246) then
			local veh = getVehiculeNear()
			if veh ~= nil then
				local plate = GetVehicleNumberPlateText(veh)
				local hasOwned = false
				for _,v in ipairs(VEHICULES) do
					if v.plate == plate then
						if v.opened then
							SetVehicleDoorsLocked(veh, true)
							drawNotification("Véhicule ~r~fermé")
							v.opened = false
						else
							SetVehicleDoorsLocked(veh, false)
							drawNotification("Véhicule ~g~ouvert")
							v.opened = true
						end
						hasOwned = true
					end
				end
				if not hasOwned then drawNotification("Ce vehicule ~r~ne vous appartient pas") end
			else
				drawNotification('~r~Aucun véhicule~s~ aux alentours')
			end
		end
	end
end)

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function getVehiculeNear()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
	local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
	if(DoesEntityExist(vehicleHandle)) then
		return vehicleHandle
	else
		return nil
	end
end
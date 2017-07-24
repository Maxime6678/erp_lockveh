require "resources/mysql-async/lib/MySQL"

RegisterServerEvent('lockveh:getVehicules')
AddEventHandler('lockveh:getVehicules', function()
	local user_id = getPlayerID(source)
	MySQL.Async.fetchAll("SELECT * FROM user_vehicle WHERE identifier = @user_id", {['@user_id'] = user_id}, function(result)
		VEHICLES = {}
		for _,v in ipairs(result) do
			t = {model = v.vehicle_model, plate = v.vehicle_plate, opened = true}
			table.insert(VEHICLES, tonumber(v.ID), t)
		end
		TriggerClientEvent('lockveh:setVehicules', source, VEHICLES)
	end)
end)

function getPlayerID(source)
  return getIdentifiant(GetPlayerIdentifiers(source))
end

function getIdentifiant(id)
  for _, v in ipairs(id) do
    return v
  end
end
local active = {}
getActive = function() return active end
exports('active', getActive)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer, isNew)
	CheckTable(xPlayer)
end)

AddEventHandler('onResourceStart', function(resourceName)
	local xPlayer
	if (GetCurrentResourceName() == resourceName) then
		if ESX == nil then return end
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			CheckTable(xPlayer)
		end
	end
end)

CheckTable = function(xPlayer)
	if type(xPlayer) ~= 'table' then xPlayer = ESX.GetPlayerFromId(xPlayer) end
	if active[xPlayer.source] then active[xPlayer.source] = nil	end
end

AddEventHandler('esx:playerDropped', function(playerId, reason)
	if active[source] then
		active[source] = nil
	end
end)

-- Mission Events
ESX.RegisterServerCallback('siir_pedMissions:getPackage', function(source, cb, item, count, meta)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.canCarryItem(item, count) then
		xPlayer.addInventoryItem(item, count, { type =  meta })
		cb(true)
	else
		cb(false)
	end
end)

RegisterNetEvent('siir_pedMissions:validatePackage')
AddEventHandler('siir_pedMissions:validatePackage', function(item, count, meta, distance, time)
	local xPlayer = ESX.GetPlayerFromId(source)
	local metaData = { type = meta }
	local itemCount = xPlayer.getInventoryItem(item, metaData)
	local payout = math.floor(GeneratePayout(distance, time))

	if itemCount.count < count then
		TriggerClientEvent('ms-notify:sendAlert', xPlayer.source, { type = 'error', text = _U('no_item'), icon = 'fas fa-ban', soundFile = 'tone5' })
	else
		xPlayer.removeInventoryItem(item, itemCount.count, metaData)
		xPlayer.addInventoryItem(Config.Payment.item, payout)
		if time > 0 then
			TriggerClientEvent('ms-notify:sendAlert', xPlayer.source, { type = 'success', text = _U('delivered'), icon = 'fas fa-check', soundFile = 'tone2' })
			if Config.RestartOnDelivery then
				TriggerClientEvent('siir_pedMissions:startStory', xPlayer.source, true)
			else
				TriggerClientEvent('siir_pedMissions:endMission', xPlayer.source)
			end
		else
			TriggerClientEvent('ms-notify:sendAlert', xPlayer.source, { type = 'error', text = _U('too_slow'), icon = 'fas fa-ban', soundFile = 'tone5' })
			TriggerClientEvent('siir_pedMissions:endMission', xPlayer.source)
		end
	end
end)

-- Mission Functions
GeneratePayout = function(distance, time)
	local payout = distance * Config.Payment.modifier
	local policeCount = 0
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			policeCount = policeCount + 1
		end
	end

	if time > 40.0 then
		payout = payout * 1.8
	elseif time < 40.0 and time > 30.0 then
		payout = payout * 1.4
	elseif time < 30.0 and time > 20.0 then
		payout = payout * 1.3
	elseif time < 20.0 and time > 10.0 then
		payout = payout * 1.2
	elseif time < 10.0 and time > 5.0 then
		payout = payout
	else
		payout = payout * 0.5
	end

	return payout + (Config.Payment.policeCountModifier * policeCount)
end
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	Citizen.Wait(500)
	StartResource()
end)

RegisterNetEvent('esx:onPlayerLogout')	-- Trigger this event when a player logs out to character selection
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)

Citizen.CreateThread(function()	-- If the resource is started while the player is active, force it to load
	Citizen.Wait(500)
	if ESX.IsPlayerLoaded() then StartResource() end
end)
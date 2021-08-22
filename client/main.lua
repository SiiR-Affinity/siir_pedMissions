-- local missionSelect = 0
local pickupSelect, package = nil, nil
local deliveryDistance, pickupDistance, deliveryStage, initCoords = 0, 0, 0, 0
local startTime = 0
local timeAllowed = 0

StartResource = function()
	playerPed = PlayerPedId()
	ESX.PlayerLoaded = true
end

StartLoop = function()
	Citizen.CreateThread(function()
		while ESX.PlayerLoaded and deliveryStage == 1 do
			Citizen.Wait(1000)
			ActiveCheck()
		end
	end)
end

-- Remove when done
-- RegisterCommand('start', function()
-- 	TriggerEvent('siir_pedMissions:startStory', false)
-- end)

-- Temp fix to end mission if player walks away with UI open
ActiveCheck = function()
	local playerCoords = GetEntityCoords(playerPed)

	if #(initCoords - playerCoords) > 3.0 then
		TriggerEvent('siir_pedMissions:endMission')
	end
end

exports.qtarget:AddTargetModel({'prop_news_disp_02a'}, {
	options = {
		{
			icon = "fas fa-info-circle",
			label = _U('take_note'),
			canInteract = function()
				if deliveryStage == 0 and not IsPedInAnyVehicle(playerPed, true) then return true end
			end,
			action = function()
				TriggerEvent('siir_pedMissions:startStory', false)
			end
		}
	},
	distance = 1
})

RemoveText = function()
    SetNuiFocus(false, false)

    SendNUIMessage({message = "closeui",})
	SetNuiFocusKeepInput(false)
end

ConfirmMission = function()
	deliveryStage = 2
	math.randomseed(GetGameTimer())
	pickupSelect = GenerateCoords('pickup')
	exports['ms-notify']:SendAlert({ id = 'pickup', type = 'normal', text = _U('head_to_pickup'), soundFile = 'tone2', time = -1})

	if Config.NotifyPolice then
		math.randomseed(GetGameTimer())
		if (math.random(1, 100)) <= Config.NotifyChance then
			local data = {displayCode = '420', description = Config.PackageSpawnPoliceMessage, recipientList = {'police'}, length = '7000'}
			local dispatchData = {dispatchData = data, caller = 'Local', coords = pickupSelect.coords}
			TriggerServerEvent('wf-alerts:svNotify', dispatchData)
		end
	end

	blip = AddBlipForCoord(pickupSelect.coords)
	SetBlipSprite(blip, 57)
	SetBlipColour(blip, 5)
	SetBlipScale(blip, 0.30)
	SetBlipRoute(blip,  true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Package Collection')
	EndTextCommandSetBlipName(blip)

	Citizen.CreateThread(function()
		local wait = 500
		while pickupSelect do
			Citizen.Wait(wait)
			if pickupSelect ~= nil then
				local playerCoords = GetEntityCoords(playerPed)
				local distance = #(playerCoords - pickupSelect.coords)
				if distance <= 50.0 then
					RequestModel(pickupSelect.prop)
					while not HasModelLoaded(pickupSelect.prop) do
						Citizen.Wait(0)
					end
					package = CreateObject(pickupSelect.prop, pickupSelect.coords.x, pickupSelect.coords.y, pickupSelect.coords.z, true, false, true)
					SetEntityAsMissionEntity(package, true, true)
					PlaceObjectOnGroundProperly(package)
					PickupExport(package)
					break
				end
			end
		end
	end)

	Citizen.CreateThread(function()
		local wait = 1
		while deliveryStage == 2 do
			Citizen.Wait(wait)
			if IsControlJustReleased(0, 83) then
				TriggerEvent('siir_pedMissions:endMission')
			end
		end
	end)
end

GenerateCoords = function(string)
	local playerCoords = GetEntityCoords(playerPed)
	math.randomseed(GetGameTimer())
	local selected = nil

	if string == 'pickup' then
		selected = Config.Pickup[math.random(0, #Config.Pickup)]
		pickupDistance = #(playerCoords - selected.coords)
		return selected
	elseif string == 'delivery' then
		repeat
			selected = Config.DropoffLocations[math.random(0, #Config.DropoffLocations)]
			deliveryDistance = #(playerCoords - selected.coords)
		until deliveryDistance >= Config.MinDeliveryDistance
		return selected
	end

end

PickupExport = function(package)
	exports.qtarget:AddTargetEntity(package, {
		options = {
			{
				icon = "fas fa-check",
				label = _U('pickup_mission_object'),
				canInteract = function()
					if deliveryStage == 2 and not IsPedInAnyVehicle(playerPed, true) then return true end
				end,
				action = function()
					TakePackage(pickupSelect)
				end
			},
		},
		distance = 1.5
	})
end

TakePackage = function(pickupSelect)
	deliveryStage = nil
	RequestAnimDict('random@domestic')
	while not HasAnimDictLoaded('random@domestic') do
		Wait(1)
	end
	
	TaskPlayAnim(playerPed, 'random@domestic', 'pickup_low', 8.0, 8.0, 1100, 01, 0, false, false, false)
	Wait(1000)
	ClearPedTasksImmediately(playerPed)
	RemoveAnimDict('random@domestic')
	ESX.TriggerServerCallback('siir_pedMissions:getPackage', function(cb)
		if cb then
			StartDelivery(pickupSelect.itemName, pickupSelect.itemAmount, pickupSelect.itemMeta)
		else
			deliveryStage = 2
			exports['ms-notify']:SendAlert({ type = 'error', text = _U('cant_carry'), icon = 'fas fa-ban', soundFile = 'tone5' })
		end
	end, pickupSelect.itemName, pickupSelect.itemAmount, pickupSelect.itemMeta)
end

StartDelivery = function(item, count, meta)
	deliveryStage = 3
	RemoveBlip(blip)

	local delivery = GenerateCoords('delivery')

	exports['ms-notify']:RemoveAlert('pickup')
	SetObjectAsNoLongerNeeded(package)
	ESX.Game.DeleteObject(package)

	local totalDistance = deliveryDistance + pickupDistance
	startTime = GetGameTimer()
	timeAllowed = deliveryDistance / Config.MPS

	exports['ms-notify']:SendAlert({ id = 'deliver', type = 'normal', text = _U('head_to_delivery'), soundFile = 'tone2', time = -1 })

	blip = AddBlipForCoord(delivery.coords)
	SetBlipSprite(blip, 57)
	SetBlipColour(blip, 5)
	SetBlipScale(blip, 0.30)
	SetBlipRoute(blip,  true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Package Drop-Off')
	EndTextCommandSetBlipName(blip)

	exports.qtarget:AddBoxZone("DeliveryDropOff", delivery.coords, delivery.dropLength, delivery.dropWidth, {
		name="DeliveryDropOff",
		heading=delivery.dropHeading,
		debugPoly=false,
		minZ=delivery.dropMinZ,
		maxZ=delivery.dropMaxZ,
		}, {
			options = {
				{
					icon = "fas fa-check",
					label = _U('deliver_package'),
					canInteract = function()
						if deliveryStage == 3 and not IsPedInAnyVehicle(playerPed, true) then return true end
					end,
					action = function()
						DeliverPackage(item, count, meta, totalDistance)
					end
				}
			},
		distance = 1.5
	})

	Citizen.CreateThread(function()
		local wait = 1
		while deliveryStage == 3 do
			Citizen.Wait(wait)
			if IsControlJustReleased(0, 83) then
				TriggerEvent('siir_pedMissions:endMission')
			end
		end
	end)
end

DeliverPackage = function(item, count, meta, totalDistance)
	local endTime = timeAllowed - (GetGameTimer() - startTime) / 1000
	exports['ms-notify']:RemoveAlert('deliver')
	RemoveBlip(blip)
	TriggerServerEvent('siir_pedMissions:validatePackage', item, count, meta, totalDistance, endTime)
end

-- Events
RegisterNetEvent('siir_pedMissions:endMission')
AddEventHandler('siir_pedMissions:endMission', function()

	SetNuiFocus(false, false)

    SendNUIMessage({message = "closeui",})
	SetNuiFocusKeepInput(false)

	RemoveBlip(blip)
	ESX.Game.DeleteObject(package)

	if deliveryStage == 2 then
		exports['ms-notify']:RemoveAlert('pickup')
	elseif deliveryStage == 3 then
		exports['ms-notify']:RemoveAlert('deliver')
	end
		
	deliveryStage = 0
	deliveryDistance = 0
end)

RegisterNetEvent('siir_pedMissions:startStory')
AddEventHandler('siir_pedMissions:startStory', function(successful)
	StartLoop()
	local missionSelect
	deliveryStage = 1
	initCoords = GetEntityCoords(playerPed)
	math.randomseed(GetGameTimer())
	if successful then
		missionSelect = Config.RestartText[math.random(0, #Config.RestartText)]
	else
		missionSelect = Config.MissionText[math.random(0, #Config.MissionText)]
	end

	SetNuiFocus(true, false)
	SetNuiFocusKeepInput(true)

	SendNUIMessage({
        message = "introText",
		mission = missionSelect
    })
end)

-- NUI
RegisterNUICallback('close', function()
    SetNuiFocus(false, false)

    SendNUIMessage({message = "closeui",})
	SetNuiFocusKeepInput(false)
end)

RegisterNUICallback('confirm', function()
    SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)
	RemoveText()
    ConfirmMission()
end)
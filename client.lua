local NDCore = exports['nd-core']:GetCoreObject()

--PED SPAWNER
local peds = {}
CreateThread(function()
	while true do
		Wait(500)
		for k = 1, #Config.PedList, 1 do
			v = Config.PedList[k]
			local playerCoords = GetEntityCoords(PlayerPedId())
			local dist = #(playerCoords - v.coords)
			if dist < 40.0 and not peds[k] then
				local ped = nearPed(v.model, v.coords, v.heading, v.gender, v.scenario)
				peds[k] = {ped = ped}
			end
			if dist >= 40.0 and peds[k] then
				for i = 255, 0, -51 do
					Wait(50)
					SetEntityAlpha(peds[k].ped, i, false)
				end
				DeletePed(peds[k].ped)
				peds[k] = nil
			end
		end
	end
end)
function nearPed(model, coords, heading, gender, scenario)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
		Wait(1)
	end
		genderNum = 4
		ped = CreatePed(genderNum, GetHashKey(v.model), coords, heading, false, true)
		SetEntityAlpha(ped, 0, false)
		FreezeEntityPosition(ped, true) --Don't let the ped move.
		SetEntityInvincible(ped, true) --Don't let the ped die.
		SetBlockingOfNonTemporaryEvents(ped, true) --Don't let the ped react to his surroundings.
		TaskStartScenarioInPlace(ped, scenario, 0, true) -- begins peds animation
		for i = 0, 255, 51 do
			Wait(50)
			SetEntityAlpha(ped, i, false)
		end
	return ped
end

-- BLIP MAKER
CreateThread(function()
	for k, v in pairs(Config.Locations) do
		local blip = AddBlipForCoord(v.location)
		SetBlipAsShortRange(blip, true)
		SetBlipSprite(blip, 478)
		SetBlipColour(blip, 81)
		SetBlipScale(blip, 0.5)
		SetBlipDisplay(blip, 6)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString("Столове")
		EndTextCommandSetBlipName(blip)
		
		--Add nd-target Locations if enabled in config
		if Config.Target then
			exports['nd-target']:AddCircleZone("ChairStore"..k, v.location, 2.0,
		   { name="ChairStore"..k, debugPoly=false, useZ=true, }, 
			{ options = {
			 { event = "nd-chairs:openShop",
			  icon = "fas fa-chair",
			   label = "Купи",
			    store = v.store }, },
				distance = 2.0
			})
		end	
	end
end)

--Chair Store Opening
RegisterNetEvent('nd-chairs:openShop')
AddEventHandler('nd-chairs:openShop', function(data)
	if data.store == "Store1" then
		TriggerServerEvent("inventory:server:OpenInventory", "shop", "Chairs", Config.Store1)
	end
end)

--CHAIR CONTROLLER
attachedProp = 0
function attachAChair(chairModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeattachedChair()
	chairModel = GetHashKey(chairModelSent)
	--loadModel(chairModelSent)
	boneNumber = boneNumberSent 
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	RequestModel(chairModel)
	while not HasModelLoaded(chairModel) do
		Wait(100)
	end
	attachedChair = CreateObject(chairModel, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedChair, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
	SetModelAsNoLongerNeeded(chairModel)
end
function removeattachedChair()
	DeleteEntity(attachedChair)
	attachedChair = 0
end
function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end


RegisterNetEvent("nd-chairs:Use")
AddEventHandler("nd-chairs:Use", function(item)
	if not haschairalready then
		haschairalready = true
	local coords = GetEntityCoords(PlayerPedId())
	local animDict = "timetable@ron@ig_3_couch"
	local animation = "base"
	FreezeEntityPosition(PlayerPedId(),true)
	if item == "chair1" then attachAChair("prop_skid_chair_01", 0, 0, -0.05, -0.18, 8.4, 0.4, 185.0)
	elseif item == "chair2" then attachAChair("prop_skid_chair_02", 0, 0, -0.05, -0.18, 8.4, 0.4, 185.0)
	elseif item == "chair3" then attachAChair("prop_skid_chair_03", 0, 0, -0.05, -0.18, 8.4, 0.4, 185.0) end
	loadAnimDict(animDict)
	local animLength = GetAnimDuration(animDict, animation)
	TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0, animLength, 1, 0, 0, 0, 0)
	else
		haschairalready = false
		FreezeEntityPosition(PlayerPedId(),false)
		removeattachedChair()
		StopEntityAnim(PlayerPedId(), "base", "timetable@ron@ig_3_couch", 3)
	end
end)

CreateThread(function()
	while true do
		if haschairalready and not IsEntityPlayingAnim(PlayerPedId(), "timetable@ron@ig_3_couch", "base", 3) then
			FreezeEntityPosition(PlayerPedId(),false)
			removeattachedChair()
			--ClearPedTasks(PlayerPedId())
			haschairalready = false
		end
		Wait(500)
	end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
		FreezeEntityPosition(PlayerPedId(),false)
		removeattachedChair()
		ClearPedTasks(PlayerPedId())
		haschairalready = false
    end
end)

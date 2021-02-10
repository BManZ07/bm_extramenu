ESX = nil
local menuOpen = false
local PlayerData = {}
local isNear = false
local isInMarker = false


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function IsJobTrue()
    if PlayerData ~= nil then
        local IsJobTrue = false
        if PlayerData.job ~= nil and PlayerData.job.name == Config.RequiredJob then
            IsJobTrue = true
        end
        return IsJobTrue
    end
end

function canTint()
    if PlayerData ~= nil then
        local canTint = false
        if PlayerData.job ~= nil and PlayerData.job.grade >= Config.WindowTintRank then
            canTint = true
        end
        return canTint
    end
end

local onMarker = nil
local nearMarker = nil
Citizen.CreateThread(function()
	while true do
		local timer = nil
		local playerPed = PlayerPedId()
		local veh = GetVehiclePedIsIn(playerPed, false) 
		local isInCar = IsPedInVehicle(playerPed, veh, false)

		local coords = GetEntityCoords(playerPed)
		if IsJobTrue() and isInCar then
			timer = 0
			if isNear == true  then
				if GetVehicleClass( veh ) == 18 or IsPedInAnyPoliceVehicle(playerPed) then
					timer = 0
					for i=1, #Config.MarkerCoords, 1 do
						if i == nearMarker then
							DrawMarker(44, Config.MarkerCoords[nearMarker].x, Config.MarkerCoords[nearMarker].y, Config.MarkerCoords[nearMarker].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.75, 0.75, 0.75, 0, 0, 255, 100, false, true, 2, true, nil, nil, false)
							if isInMarker and i == onMarker then
								local size = 0.4
								local font = 0
								local coords = vector3(Config.MarkerCoords[onMarker].x, Config.MarkerCoords[onMarker].y, Config.MarkerCoords[onMarker].z)

								local camCoords = GetGameplayCamCoords()
								local distance = #(coords - camCoords)

								local scale = (size / distance) * 2
								local fov = (1 / GetGameplayCamFov()) * 100
								scale = scale * fov

								SetTextScale(0.0 * scale, 0.95 * scale)
								SetTextFont(font)
								SetTextColour(255, 255, 255, 255)
								SetTextDropshadow(0, 0, 0, 0, 255)
								SetTextDropShadow()
								SetTextOutline()
								SetTextCentre(true)

								SetDrawOrigin(coords, 0)
								Citizen.InvokeNative(0x25FBB336DF1804CB, 'STRING')
								Citizen.InvokeNative(0x6C188BE134E074AA, 'Press [~g~E~w~] to modify your vehicle')
								Citizen.InvokeNative(0xCD015E5BB0D96A57, 0.0, 0.0)
								ClearDrawOrigin()
								
								if IsControlJustReleased(0, 38) then
									OpenExtrasMenu()
								end
							end
						end
					end
				end
			else
				timer = 1000
			end
		else
			timer = 1000
		end
		Citizen.Wait(timer)		
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local playerPed = PlayerPedId()
		local veh = GetVehiclePedIsIn(playerPed, false) 
		local isInCar = IsPedInVehicle(playerPed, veh, false)
		local coords = GetEntityCoords(playerPed)
		isNear = false
		isInMarker = false
		for i=1, #Config.MarkerCoords, 1 do
			if GetDistanceBetweenCoords(coords, Config.MarkerCoords[i].x, Config.MarkerCoords[i].y, Config.MarkerCoords[i].z, false) < 15.0 then
				isNear = true
				nearMarker = i
				if GetDistanceBetweenCoords(coords, Config.MarkerCoords[i].x, Config.MarkerCoords[i].y, Config.MarkerCoords[i].z, false) < 2.0 then
					isInMarker = true
					onMarker = i
				end
				break
			end
		end
	end
end)





function OpenExtrasMenu(station)
    local elements = {}
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

	table.insert(elements, {label = "Vehicle Colours",     value = 'veh_colour'})
	table.insert(elements, {label = "Window Tint",     value = 'tint'})

	for i=1, 12, 1 do
		if DoesExtraExist(veh, i) then
			table.insert(elements, {label = "Extra "..i,     value = 'extra', extraNum = i})
		end
	end
	
	if GetVehicleLiveryCount(veh) >= 2 then
		table.insert(elements, {label = "Vehicle Livery",     value = 'livery'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extras', {
		title    = "Vehicle Modification",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'veh_colour' then
			Veh_Colour()
		elseif data.current.value == 'tint' then
			if canTint() then
				Veh_Tint()
			else
				exports['mythic_notify']:DoHudText('error', "You cannot access tint!")
			end
		elseif data.current.value == 'extra' then
			Extras_Menu(data.current.extraNum)
		elseif data.current.value == 'livery' then
			OpenLiveryMenu()
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenLiveryMenu(station)
	local elements = {}
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

	for i = 1, GetVehicleLiveryCount(veh), 1 do
		table.insert(elements, {label = 'Livery ' .. tostring(i),     value = i})
	end


	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'liverys', {
		title    = "Vehicle Modification",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value then
			SetVehicleLivery(veh, data.current.value)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function Veh_Colour(station)
    local elements = {}
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

	table.insert(elements, {label = "Black",     value = 'col_black'})
	table.insert(elements, {label = "White",     value = 'col_white'})
	table.insert(elements, {label = "Blue",     value = 'col_blue'})
	table.insert(elements, {label = "Green",     value = 'col_green'})
	table.insert(elements, {label = "Orange",     value = 'col_orange'})
	table.insert(elements, {label = "Red",     value = 'col_red'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extras', {
		title    = "Colour Selection",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'col_black' then
			SetVehicleColours(veh, 0, 0)
		elseif data.current.value == 'col_white' then
			SetVehicleColours(veh, 111, 111)
		elseif data.current.value == 'col_blue' then
			SetVehicleColours(veh, 73, 73)
		elseif data.current.value == 'col_green' then
			SetVehicleColours(veh, 50, 50)
		elseif data.current.value == 'col_orange' then
			SetVehicleColours(veh, 38, 36)
		elseif data.current.value == 'col_red' then
			SetVehicleColours(veh, 27, 35)
		end
		
		Veh_Colour()

	end, function(data, menu)
		OpenExtrasMenu()
	end)
end

function Veh_Tint(station)
    local elements = {}
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

	table.insert(elements, {label = "None",     value = 'none'})
	table.insert(elements, {label = "Light Smoke",     value = 'light_smoke'})
	table.insert(elements, {label = "Dark Smoke",     value = 'dark_smoke'})
	table.insert(elements, {label = "Pure Black",     value = 'pure_black'})
	table.insert(elements, {label = "Limo",     value = 'limo'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extras', {
		title    = "Colour Selection",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'none' then
			ESX.Game.SetVehicleProperties(veh, {
				windowTint = 0
			})
		elseif data.current.value == 'light_smoke' then
			ESX.Game.SetVehicleProperties(veh, {
				windowTint = 3
			})
		elseif data.current.value == 'dark_smoke' then
			ESX.Game.SetVehicleProperties(veh, {
				windowTint = 2
			})
		elseif data.current.value == 'pure_black' then
			ESX.Game.SetVehicleProperties(veh, {
				windowTint = 1
			})
		elseif data.current.value == 'limo' then
			ESX.Game.SetVehicleProperties(veh, {
				windowTint = 5
			})
		end
		
		Veh_Tint()

	end, function(data, menu)
		OpenExtrasMenu()
	end)
end

function Extras_Menu(extraNum)
    local elements = {}
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

	table.insert(elements, {label = "Add",     value = 'add'})
    table.insert(elements, {label = "Remove",     value = 'remove'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extras', {
		title    = "Vehicle Modification",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'add' then
			SetVehicleExtra(veh, extraNum, 0)
		elseif data.current.value == 'remove' then
			SetVehicleExtra(veh, extraNum, 1)
		end
		
		Extras_Menu(extraNum)

	end, function(data, menu)
		OpenExtrasMenu()
	end)
end


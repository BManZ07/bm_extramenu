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

	while ESX.GetPlayerData() == nil do
		Citizen.Wait(10)
	end
	
    ESX.PlayerData = ESX.GetPlayerData()
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
        if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
            IsJobTrue = true
        end
        return IsJobTrue
    end
end

function canTint()
    if PlayerData ~= nil then
        local canTint = false
        if PlayerData.job ~= nil and PlayerData.job.grade == 5 or PlayerData.job.grade == 6 or PlayerData.job.grade == 7 or PlayerData.job.grade == 8 or PlayerData.job.grade == 9 or PlayerData.job.grade == 10 or PlayerData.job.grade == 11 or PlayerData.job.grade == 12 or PlayerData.job.grade == 13 or PlayerData.job.grade == 14 then
            canTint = true
        end
        return canTint
    end
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local veh = GetVehiclePedIsIn(playerPed, false) 
		local isInCar = IsPedInVehicle(playerPed, veh, false)

		local coords = GetEntityCoords(playerPed)
		if IsJobTrue() and isInCar then
			if isNear == true then
				DrawMarker(27, 453.98696899414, -1024.7647705078, 27.530788421631, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 0, 0, 255, 100, false, true, 2, false, nil, nil, false)
				if isInMarker == true then
					if not menuOpen then
						ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to modify your car")

						if IsControlJustReleased(0, 38) then
							menuOpen = true
							OpenExtrasMenu()
						end
					end
				else
					if menuOpen then
						menuOpen = false
						ESX.UI.Menu.CloseAll()
					end
				end
			end
		end			
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local playerPed = PlayerPedId()
		local veh = GetVehiclePedIsIn(playerPed, false) 
		local isInCar = IsPedInVehicle(playerPed, veh, false)
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, 453.98696899414, -1024.7647705078, 28.030788421631, true) < 15.0 then
			isNear = true
		else
			isNear = false
		end

		if GetDistanceBetweenCoords(coords, 453.98696899414, -1024.7647705078, 28.030788421631, true) < 2.0 then
			isInMarker = true
		else
			isInMarker = false
		end

	end
end)




function OpenExtrasMenu(station)
    local elements = {}
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

	table.insert(elements, {label = "Vehicle Colours",     value = 'veh_colour'})
	table.insert(elements, {label = "Window Tint",     value = 'tint'})
	table.insert(elements, {label = "Extra 1",     value = 'extra_1'})
    table.insert(elements, {label = "Extra 2",     value = 'extra_2'})
    table.insert(elements, {label = "Extra 3",     value = 'extra_3'})
    table.insert(elements, {label = "Extra 4",     value = 'extra_4'})
    table.insert(elements, {label = "Extra 5",     value = 'extra_5'})
    table.insert(elements, {label = "Extra 6",     value = 'extra_6'})
    table.insert(elements, {label = "Extra 7",     value = 'extra_7'})
    table.insert(elements, {label = "Extra 8",     value = 'extra_8'})
    table.insert(elements, {label = "Extra 9",     value = 'extra_9'})
    table.insert(elements, {label = "Extra 10",     value = 'extra_10'})
    table.insert(elements, {label = "Extra 11",     value = 'extra_11'})
    table.insert(elements, {label = "Extra 12",     value = 'extra_12'})

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
		elseif data.current.value == 'extra_1' then
			Extras_1_Menu()
		elseif data.current.value == 'extra_2' then
			Extras_2_Menu()
		elseif data.current.value == 'extra_3' then
			Extras_3_Menu()
		elseif data.current.value == 'extra_4' then
			Extras_4_Menu()
		elseif data.current.value == 'extra_5' then
			Extras_5_Menu()
		elseif data.current.value == 'extra_6' then
			Extras_6_Menu()
		elseif data.current.value == 'extra_7' then
			Extras_7_Menu()
		elseif data.current.value == 'extra_8' then
			Extras_8_Menu()
		elseif data.current.value == 'extra_9' then
			Extras_9_Menu()
		elseif data.current.value == 'extra_10' then
			Extras_10_Menu()
		elseif data.current.value == 'extra_11' then
			Extras_11_Menu()
		elseif data.current.value == 'extra_12' then
			Extras_12_Menu()
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

	end, function(data, menu)
		OpenExtrasMenu()
	end)
end

function Extras_1_Menu(station)
    local elements = {}
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

	table.insert(elements, {label = "Add",     value = 'extra_1_add'})
    table.insert(elements, {label = "Remove",     value = 'extra_1_rem'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extras', {
		title    = "Vehicle Modification",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'extra_1_add' then
			SetVehicleExtra(veh, 1, 0)
		elseif data.current.value == 'extra_1_rem' then
			SetVehicleExtra(veh, 1, 1)
		end

	end, function(data, menu)
		OpenExtrasMenu()
	end)
end

function Extras_2_Menu(station)
    local elements = {}
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

	table.insert(elements, {label = "Add",     value = 'extra_2_add'})
    table.insert(elements, {label = "Remove",     value = 'extra_2_rem'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extras', {
		title    = "Vehicle Modification",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'extra_2_add' then
			SetVehicleExtra(veh, 2, 0)
		elseif data.current.value == 'extra_2_rem' then
			SetVehicleExtra(veh, 2, 1)
		end

	end, function(data, menu)
		OpenExtrasMenu()
	end)
end

function Extras_3_Menu(station)
    local elements = {}
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

	table.insert(elements, {label = "Add",     value = 'extra_3_add'})
    table.insert(elements, {label = "Remove",     value = 'extra_3_rem'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extras', {
		title    = "Vehicle Modification",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'extra_3_add' then
			SetVehicleExtra(veh, 3, 0)
		elseif data.current.value == 'extra_3_rem' then
			SetVehicleExtra(veh, 3, 1)
		end

	end, function(data, menu)
		OpenExtrasMenu()
	end)
end

function Extras_4_Menu(station)
    local elements = {}
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

	table.insert(elements, {label = "Add",     value = 'extra_4_add'})
    table.insert(elements, {label = "Remove",     value = 'extra_4_rem'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extras', {
		title    = "Vehicle Modification",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'extra_4_add' then
			SetVehicleExtra(veh, 4, 0)
		elseif data.current.value == 'extra_4_rem' then
			SetVehicleExtra(veh, 4, 1)
		end

	end, function(data, menu)
		OpenExtrasMenu()
	end)
end

function Extras_5_Menu(station)
    local elements = {}
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

	table.insert(elements, {label = "Add",     value = 'extra_5_add'})
    table.insert(elements, {label = "Remove",     value = 'extra_5_rem'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extras', {
		title    = "Vehicle Modification",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'extra_5_add' then
			SetVehicleExtra(veh, 5, 0)
		elseif data.current.value == 'extra_5_rem' then
			SetVehicleExtra(veh, 5, 1)
		end

	end, function(data, menu)
		OpenExtrasMenu()
	end)
end

function Extras_6_Menu(station)
    local elements = {}
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

	table.insert(elements, {label = "Add",     value = 'extra_6_add'})
    table.insert(elements, {label = "Remove",     value = 'extra_6_rem'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extras', {
		title    = "Vehicle Modification",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'extra_6_add' then
			SetVehicleExtra(veh, 6, 0)
		elseif data.current.value == 'extra_6_rem' then
			SetVehicleExtra(veh, 6, 1)
		end

	end, function(data, menu)
		OpenExtrasMenu()
	end)
end

function Extras_7_Menu(station)
    local elements = {}
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

	table.insert(elements, {label = "Add",     value = 'extra_7_add'})
    table.insert(elements, {label = "Remove",     value = 'extra_7_rem'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extras', {
		title    = "Vehicle Modification",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'extra_7_add' then
			SetVehicleExtra(veh, 7, 0)
		elseif data.current.value == 'extra_7_rem' then
			SetVehicleExtra(veh, 7, 1)
		end

	end, function(data, menu)
		OpenExtrasMenu()
	end)
end

function Extras_8_Menu(station)
    local elements = {}
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

	table.insert(elements, {label = "Add",     value = 'extra_8_add'})
    table.insert(elements, {label = "Remove",     value = 'extra_8_rem'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extras', {
		title    = "Vehicle Modification",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'extra_8_add' then
			SetVehicleExtra(veh, 8, 0)
		elseif data.current.value == 'extra_8_rem' then
			SetVehicleExtra(veh, 8, 1)
		end

	end, function(data, menu)
		OpenExtrasMenu()
	end)
end

function Extras_9_Menu(station)
    local elements = {}
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

	table.insert(elements, {label = "Add",     value = 'extra_9_add'})
    table.insert(elements, {label = "Remove",     value = 'extra_9_rem'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extras', {
		title    = "Vehicle Modification",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'extra_9_add' then
			SetVehicleExtra(veh, 9, 0)
		elseif data.current.value == 'extra_9_rem' then
			SetVehicleExtra(veh, 9, 1)
		end

	end, function(data, menu)
		OpenExtrasMenu()
	end)
end

function Extras_10_Menu(station)
    local elements = {}
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

	table.insert(elements, {label = "Add",     value = 'extra_10_add'})
    table.insert(elements, {label = "Remove",     value = 'extra_10_rem'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extras', {
		title    = "Vehicle Modification",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'extra_10_add' then
			SetVehicleExtra(veh, 10, 0)
		elseif data.current.value == 'extra_10_rem' then
			SetVehicleExtra(veh, 10, 1)
		end

	end, function(data, menu)
		OpenExtrasMenu()
	end)
end

function Extras_11_Menu(station)
    local elements = {}
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

	table.insert(elements, {label = "Add",     value = 'extra_11_add'})
    table.insert(elements, {label = "Remove",     value = 'extra_11_rem'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extras', {
		title    = "Vehicle Modification",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'extra_11_add' then
			SetVehicleExtra(veh, 11, 0)
		elseif data.current.value == 'extra_11_rem' then
			SetVehicleExtra(veh, 11, 1)
		end

	end, function(data, menu)
		OpenExtrasMenu()
	end)
end

function Extras_12_Menu(station)
    local elements = {}
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

	table.insert(elements, {label = "Add",     value = 'extra_12_add'})
    table.insert(elements, {label = "Remove",     value = 'extra_12_rem'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extras', {
		title    = "Vehicle Modification",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'extra_12_add' then
			SetVehicleExtra(veh, 12, 0)
		elseif data.current.value == 'extra_12_rem' then
			SetVehicleExtra(veh, 12, 1)
		end

	end, function(data, menu)
		OpenExtrasMenu()
	end)
end

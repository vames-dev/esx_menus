local ESX = exports["es_extended"]:getSharedObject()
local Keys = {
	["BACKSPACE"] = 177, 
	["ENTER"] = 191, 
	["LEFTSHIFT"] = 21, 
	["LEFT"] = 174, 
	["RIGHT"] = 175, 
	["TOP"] = 27, 
	["DOWN"] = 173
}


local GUI      = {}
GUI.Time       = 0
local MenuType = 'default'

local openMenu = function(namespace, name, data)
	SendNUIMessage({action = 'openMenu', namespace = namespace, name = name, data = data })
end

local closeMenu = function(namespace, name)
	SendNUIMessage({action = 'closeMenu', namespace = namespace, name = name, data = data})
end

ESX.UI.Menu.RegisterType(MenuType, openMenu, closeMenu)

RegisterNUICallback('menu_submit', function(data, cb)
	local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)
	if menu.submit ~= nil then
		menu.submit(data, menu)
	end
	if Config.UseSoundEffects then
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
	end
	cb('OK')
end)

RegisterNUICallback('menu_cancel', function(data, cb)
	local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)
	if menu.cancel ~= nil then
		menu.cancel(data, menu)
	end
	if Config.UseSoundEffects then
		PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
	end
	cb('OK')
end)

RegisterNUICallback('menu_change', function(data, cb)
	local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)
	for i=1, #data.elements, 1 do
		menu.setElement(i, 'value', data.elements[i].value)
		if Config.UseSoundEffects then
			PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
		end
		if data.elements[i].selected then
			menu.setElement(i, 'selected', true)
		else
			menu.setElement(i, 'selected', false)
		end
	end
	if menu.change ~= nil then
		menu.change(data, menu)
	end
	cb('OK')
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if IsControlPressed(0, Keys['ENTER'])and (GetGameTimer() - GUI.Time) > 150 then
			SendNUIMessage({action  = 'controlPressed', control = 'ENTER'})
			GUI.Time = GetGameTimer()
		end
		if IsControlPressed(0, Keys['BACKSPACE'])and (GetGameTimer() - GUI.Time) > 150 then
			SendNUIMessage({action  = 'controlPressed', control = 'BACKSPACE'})
			GUI.Time = GetGameTimer()
		end
		if IsControlPressed(0, Keys['TOP'])and (GetGameTimer() - GUI.Time) > 120 then
			SendNUIMessage({action  = 'controlPressed', control = 'TOP'})
			GUI.Time = GetGameTimer()
		elseif IsControlPressed(0, Keys['TOP']) and IsControlPressed(0, Keys['LEFTSHIFT'])and (GetGameTimer() - GUI.Time) > 25 then
			SendNUIMessage({action  = 'controlPressed', control = 'TOP'})
			GUI.Time = GetGameTimer()
		end
		if IsControlPressed(0, Keys['DOWN'])and (GetGameTimer() - GUI.Time) > 120 then
			SendNUIMessage({action  = 'controlPressed', control = 'DOWN'})
			GUI.Time = GetGameTimer()
		elseif IsControlPressed(0, Keys['DOWN']) and IsControlPressed(0, Keys['LEFTSHIFT'])and (GetGameTimer() - GUI.Time) > 25 then
			SendNUIMessage({action  = 'controlPressed', control = 'DOWN'})
			GUI.Time = GetGameTimer()
		end
		if IsControlPressed(0, Keys['LEFT'])and (GetGameTimer() - GUI.Time) > 150 then
			SendNUIMessage({action  = 'controlPressed', control = 'LEFT'})
			GUI.Time = GetGameTimer()
		elseif IsControlPressed(0, Keys['LEFT']) and IsControlPressed(0, Keys['LEFTSHIFT'])and (GetGameTimer() - GUI.Time) > 25 then
			SendNUIMessage({action  = 'controlPressed', control = 'LEFT'})
			GUI.Time = GetGameTimer()
		end
		if IsControlPressed(0, Keys['RIGHT'])and (GetGameTimer() - GUI.Time) > 150 then
			SendNUIMessage({action  = 'controlPressed', control = 'RIGHT'})
			GUI.Time = GetGameTimer()
		elseif IsControlPressed(0, Keys['RIGHT']) and IsControlPressed(0, Keys['LEFTSHIFT'])and (GetGameTimer() - GUI.Time) > 25 then
			SendNUIMessage({action  = 'controlPressed', control = 'RIGHT'})
			GUI.Time = GetGameTimer()
		end
	end
end)
local HealthValue = GetEntityHealth(GetPlayerPed(-1)) - 100
local HungerValue = 100
local ThirstValue = 100
local ArmorValue = GetPedArmour(GetPlayerPed(-1))
local StressValue = 0
local status = nil
---------------------------------------------------------------------------
-- Retrieve data from db, and apply to character.
---------------------------------------------------------------------------
RegisterNetEvent("_status:retrieveCharacterInfo")
AddEventHandler("_status:retrieveCharacterInfo", function (CharacterHealth, CharacterHunger , CharacterThirst, CharacterArmor, CharacterStress)
    HealthValue = CharacterHealth
    HungerValue = CharacterHunger
    ThirstValue = CharacterThirst
    ArmorValue = CharacterArmor
    StressValue = CharacterStress
end)

---------------------------------------------------------------------------
-- Stress
---------------------------------------------------------------------------
-- TODO!!!

---------------------------------------------------------------------------
-- Hunger and thirst
---------------------------------------------------------------------------
Citizen.CreateThread(function()
  while true do 
    local PlayerDead = IsEntityDead(PlayerPedId())
    local tick = 150000 -- 2,5 minutes
    Citizen.Wait(tick)
    if not PlayerDead then
      if HungerValue > 0 then
        HungerValue = HungerValue - 2
      else
        tick = 40000
        ApplyDamageToPed(PlayerPedId(), 2, false)
        print(GetEntityHealth(GetPlayerPed(-1)) - 100)
      end

      if ThirstValue > 0 then
        ThirstValue = ThirstValue - 3
      else
        tick = 40000
        ApplyDamageToPed(PlayerPedId(), 2, false)
        print(GetEntityHealth(GetPlayerPed(-1)) - 100)
      end
    else
      print("Stopped")
    end
  end
end)

---------------------------------------------------------------------------
-- Save data to DB every 5 min
---------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300000)
    local values =  {
      health = HealthValue,
      hunger = HungerValue,
      thirst = ThirstValue,
      stress = StressValue,
      armor = ArmorValue,
    }
    print('Data sent to DB')
		TriggerServerEvent("_status:saveData", values)
	end
end)

---------------------------------------------------------------------------
-- Send data to UI
---------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
      Citizen.Wait(2500)
      local values =  {
        show = true,
        health = HealthValue,
        hunger = HungerValue,
        thirst = ThirstValue,
        stress = StressValue,
        armor = ArmorValue,
      }
      TriggerEvent('_status:updateStatus', values)
    end
end)

---------------------------------------------------------------------------
-- All UI Stuff
---------------------------------------------------------------------------
RegisterNetEvent('_status:updateStatus')
AddEventHandler('_status:updateStatus', function(Status)
  SendNUIMessage({
    type = "update_ui",
    values = Status,
  })
end)

RegisterNetEvent('_status:showUI')
AddEventHandler('_status:showUI', function()
  SendNUIMessage({ type = "show_needs_ui" })
end)

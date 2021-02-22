---------------------------------------------------------------------------
-- Save data to DB
---------------------------------------------------------------------------
RegisterServerEvent("_status:saveData")
AddEventHandler("_status:saveData", function(Status)
    local src = source
    local character = exports["drp_id"]:GetCharacterData(src)
    if character == false then
        return
        print("no character data")
    else
        exports["externalsql"]:AsyncQueryCallback({
			query = "UPDATE characters SET `user_data` = :user_data WHERE `id` = :charid",
			data = {
                charid = character.charid,
                user_data = json.encode({health = Status.health, hunger = Status.hunger, thirst = Status.thirst, armor = Status.armor, stress = Status.stress})
			}
		}, function(results)
		end)
    end
end)

---------------------------------------------------------------------------
-- Send data to client
---------------------------------------------------------------------------
RegisterServerEvent("_status:sendCharacterInfo")
AddEventHandler("_status:sendCharacterInfo", function()
    local src = source
	local character = exports["drp_id"]:GetCharacterData(src)
	local characterData = exports["externalsql"]:AsyncQuery({
		query = [[SELECT * FROM `characters` WHERE `id` = :character_id]],
		data = {character_id = character.charid}
	})
	local PlayerData = json.decode(characterData["data"][1].user_data)
    local CharacterHealth = PlayerData.health
	local CharacterHunger = PlayerData.hunger
    local CharacterThirst = PlayerData.thirst
    local CharacterArmor = PlayerData.armor
    local CharacterStress = PlayerData.stress
    CharacterHealth = tonumber(CharacterHealth)
    CharacterHunger = tonumber(CharacterHunger)
    CharacterThirst = tonumber(CharacterThirst)
    CharacterArmor = tonumber(CharacterArmor)
    CharacterStress = tonumber(CharacterStress)
    
	TriggerClientEvent("_status:retrieveCharacterInfo", src, CharacterHealth, CharacterHunger, CharacterThirst, CharacterArmor, CharacterStress)
end)
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
                user_data = json.encode({hunger = Status.hunger, thirst = Status.thirst, stress = Status.stress})
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
	local CharacterHunger = PlayerData.hunger
    local CharacterThirst = PlayerData.thirst
    local CharacterStress = PlayerData.stress
    CharacterHunger = tonumber(CharacterHunger)
    CharacterThirst = tonumber(CharacterThirst)
    CharacterStress = tonumber(CharacterStress)
    
	TriggerClientEvent("_status:retrieveCharacterInfo", src, CharacterHunger, CharacterThirst, CharacterStress)
end)
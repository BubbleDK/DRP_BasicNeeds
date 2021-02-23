# DRP_BASICNEEDS - CREATED BY BUBBLE [Bubble#8785]

I have made this super simple Basic-needs system. It's very simple, and could properly be made some changes to make it even better, but i've picked up a new project, so i might as well just release this.

In order to make this work, you would have to make some changes, in the DRP_ID.

These are some of changes/additions you have to make:

Inside DRP_ID -> characterOnLoadEvents.lua inset this line:
```
TriggerServerEvent("_status:sendCharacterInfo")

``` 
You would also have to add a new column called user_data:
```
ALTER TABLE characters
  ADD user_data varchar(255) COLLATE utf8_bin DEFAULT NULL;
```

Inside DRP_ID -> server.lua, make sure your CreateCharacter event looks somewhat like this:
```
RegisterServerEvent("DRP_ID:CreateCharacter")
AddEventHandler("DRP_ID:CreateCharacter", function(newCharacterData)
	local src = source
	local playerData = exports["drp_core"]:GetPlayerData(src)
	local characters = exports["externalsql"]:AsyncQuery({
		query = [[SELECT * FROM `characters` WHERE `playerid` = :playerid]],
		data = {playerid = playerData.playerid}
	})
	local characterCount = #characters["data"]
	if characterCount < DRPCharacters.MaxCharacters then
	exports["externalsql"]:AsyncQuery({
		query = [[
			INSERT INTO characters
			(`name`, `age`, `dob`, `gender`, `cash`, `bank`, `dirtyCash`, `licenses`, `playerid`, `user_data`)
			VALUES
			(:name, :age, :dob, :gender, :cash, :bank, :dirtycash, :licenses, :playerid, :user_data)
		]],
		data = {
			name = newCharacterData.name,
			age = newCharacterData.age,
			dob = newCharacterData.dob,
			gender = newCharacterData.gender,
			cash = DRPCharacters.StarterCash,
			bank = DRPCharacters.StarterBank,
			dirtycash = DRPCharacters.StartDirtyCash,				
			licenses = json.encode({}),
			playerid = playerData.playerid,
			user_data = json.encode({hunger = "100", thirst = "100", stress = "0"})
		}
	})
		TriggerEvent("DRP_ID:UpdateCharactersInUI", src)
	else
		TriggerClientEvent("DRP_Core:Error", src, "Characters", "You have ran out of Character spaces, the max is "..DRPCharacters.MaxCharacters.."", 2500, false, "leftCenter")
	end
end)
```

# HUGE CREDIT TO Shinigami#5461, if it wasn't for him, this wouldn't have been made. Also credit to his work, which i've taken some inspiration from:
https://github.com/ioShinigami/status-hud

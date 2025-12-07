-- ass executors
local dogshit = identifyexecutor()
local dogshitlist = { "Solara", "Xeno" }
  
-- game id shit

local allowed1 = 8206123457
local allowed2 = 8204899140

if game.PlaceId ~= allowed1 and game.PlaceId ~= allowed2 then
    game.Players.LocalPlayer:Kick("This game is not supported by Astra Hub! Join Football Fusion 2 to use this.")
end

print("Detected Version: v2.0.6 - You are up to date with the latest version.")
print("Selected Game: Football Fusion 2 - Updated!")

wait(3)

if table.find(dogshitlist, dogshit) then
    game.Players.LocalPlayer:Kick("We do not support your executor. For more executor information go to our Discord Server!")
end

-- anti cheat bypass
loadstring(game:HttpGet("https://raw.githubusercontent.com/azureblueday/astrahub/refs/heads/main/bypass.luau"))()

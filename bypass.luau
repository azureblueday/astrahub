local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local mt = getrawmetatable(game)
local oldNamecall

-- Hook __namecall for FF2-specific remotes (blocks ban/kick calls)
setreadonly(mt, false)
oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    -- Block FF2 ban/kick remotes (e.g., "ReportCheater", "BanPlayer", "Kick")
    if not checkcaller() and method == "FireServer" then
        local remoteName = tostring(self):lower()
        if remoteName:find("ban") or remoteName:find("kick") or remoteName:find("report") or remoteName:find("cheat") or remoteName:find("ac") then
            return nil  -- Silent block
        end
    end
    
    -- Block Kick method entirely
    if not checkcaller() and method == "Kick" then
        return nil
    end
    
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- Spoof __index for AC value checks (e.g., speed, jump, velocity flags in FF2)
local oldIndex = mt.__index
mt.__index = newcclosure(function(self, key)
    -- Spoof common FF2 detection values (e.g., "Banned", "Cheating", velocity anomalies)
    if tostring(self):lower():find("ac") or tostring(self):lower():find("anticheat") or tostring(self):lower():find("ff2") then
        if key == "Value" or key == "Cheating" or key == "Banned" then
            return false  -- Always spoof as clean
        end
        if key == "Velocity" or key == "JumpPower" or key == "WalkSpeed" then
            return 16  -- Default human values to spoof
        end
    end
    return oldIndex(self, key)
end)

-- Destroy FF2 client-side AC scripts/objects (runs on load & respawn)
local function destroyFF2AC()
    -- Workspace AC (common in FF2: hidden scripts monitoring physics)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("LocalScript") and (obj.Name:lower():find("ac") or obj.Name:lower():find("anticheat") or obj.Name:lower():find("ff2") or obj.Name:lower():find("monitor")) then
            pcall(function() obj:Destroy() end)
        end
        -- Destroy physics detectors (FF2 often uses attachments for velocity checks)
        if obj.Name:lower():find("detector") or obj.Name:lower():find("check") then
            pcall(function() obj:Destroy() end)
        end
    end
    
    -- ReplicatedStorage remotes that flag cheats (FF2-specific: "AntiExploit", "CheatReport")
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") and (remote.Name:lower():find("anti") or remote.Name:lower():find("cheat") or remote.Name:lower():find("exploit")) then
            pcall(function() remote:Destroy() end)
        end
    end
    
    -- PlayerGui AC (FF2 injects hidden GUIs for script detection)
    local pgui = LocalPlayer:WaitForChild("PlayerGui")
    for _, obj in pairs(pgui:GetDescendants()) do
        if obj:IsA("LocalScript") and obj.Name:match("AC") or obj.Name:match("Check") then
            pcall(function() obj:Destroy() end)
        end
    end
end

-- Run destruction on load
destroyFF2AC()

-- Re-run on character respawn (FF2 AC reloads per life)
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)  -- Wait for AC to load
    destroyFF2AC()
end)

-- Extra layer: Hook Heartbeat to spoof velocity changes (FF2 detects direct AssemblyLinearVelocity writes)
local oldHeartbeat
oldHeartbeat = RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        -- Randomize slightly to mimic human input (undetectable physics)
        if math.random(1, 100) == 1 then  -- Rare spoof
            hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(math.random(-1,1)/10, 0, math.random(-1,1)/10)
        end
    end
end)

print("✅ FF2 AC Bypass Loaded - Fully Undetected. Run your scripts now!")

-- new bypass in script this is OLD! and BANS!

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local mt = getrawmetatable(game)

-- HOOKMETAMETHOD __namecall (FULLY UNDETECTABLE - NO SETREADONLY!)
local oldNamecall = hookmetamethod(mt, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    -- BLOCK FF2 BAN/KICK/REPORT REMOTES (exact names from FF2 AC)
    if not checkcaller() and method == "FireServer" then
        local remoteName = tostring(self):lower()
        local blocked = remoteName:find("anticheat") or remoteName:find("ac") or 
                        remoteName:find("ban") or remoteName:find("kick") or 
                        remoteName:find("report") or remoteName:find("exploit") or
                        remoteName:find("cheat") or remoteName:find("ff2") or
                        remoteName:find("monitor") or remoteName:find("detect")
        if blocked then
            return -- Silent block (undetectable)
        end
    end
    
    -- BLOCK Kick entirely
    if not checkcaller() and method == "Kick" then
        return nil
    end
    
    return oldNamecall(self, ...)
end)

-- HOOKMETAMETHOD __index (SPOOF DETECTION VALUES)
hookmetamethod(mt, "__index", function(self, idx)
    -- FF2 AC checks (spoof clean values)
    local selfName = tostring(self):lower()
    if selfName:find("anticheat") or selfName:find("ac") or selfName:find("ff2") then
        if idx == "Value" or idx == "Cheating" or idx == "Banned" or idx == "Kicked" then
            return false
        end
        if idx == "WalkSpeed" then return 16 end
        if idx == "JumpPower" then return 50 end
        if idx == "Velocity" or idx == "YVelocity" then
            return Vector3.new(0, 0, 0) -- Spoof no anomalies
        end
    end
    return mt.__index(self, idx)
end)

-- DESTROY FF2 CLIENT AC (runs continuously + on respawn)
local function nukeFF2AC()
    -- Workspace (FF2 hidden detectors)
    for _, obj in workspace:GetDescendants() do
        if obj:IsA("LocalScript") and (obj.Name:lower():find("ac") or obj.Name:lower():find("ff2") or obj.Name:lower():find("anti") or obj.Name:lower():find("detect")) then
            obj:Destroy()
        end
        if obj.Name:lower():find("detector") or obj.Name:lower():find("monitor") then
            obj:Destroy()
        end
    end
    
    -- ReplicatedStorage FF2 remotes
    for _, rem in ReplicatedStorage:GetDescendants() do
        if rem:IsA("RemoteEvent") and (rem.Name:lower():find("ac") or rem.Name:lower():find("anti") or rem.Name:lower():find("cheat")) then
            rem:Destroy()
        end
    end
    
    -- PlayerGui (FF2 injects AC GUIs)
    pcall(function()
        for _, obj in LocalPlayer.PlayerGui:GetDescendants() do
            if obj:IsA("LocalScript") and obj.Name:match("AC|Check|Anti") then
                obj:Destroy()
            end
        end
    end)
end

-- NUKE ON LOAD
nukeFF2AC()

-- RE-NUKE ON RESPAWN (FF2 reloads AC per life)
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.3)
    nukeFF2AC()
end)

-- VELOCITY NORMALIZER (FF2 physics AC - humanizes jumps/speeds)
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            -- Clamp to human limits (undetectable)
            local vel = hrp.AssemblyLinearVelocity
            if vel.Magnitude > 100 then -- FF2 flags >100
                hrp.AssemblyLinearVelocity = Vector3.new(
                    math.clamp(vel.X, -50, 50),
                    math.clamp(vel.Y, -100, 100),
                    math.clamp(vel.Z, -50, 50)
                )
            end
            -- Spoof properties
            hum.WalkSpeed = math.clamp(hum.WalkSpeed, 0, 20)
            hum.JumpPower = math.clamp(hum.JumpPower, 0, 60)
        end
    end
end)

-- CONNECTION DISABLER (FF2 Heartbeat monitors)
for _, conn in getconnections(RunService.Heartbeat) do
    if conn.Function and debug.getinfo(conn.Function).short_src:find("ac") then
        conn:Disable()
    end
end

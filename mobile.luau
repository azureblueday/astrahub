-- StarterPlayerScripts / TouchAsClick.global.lua
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

local function PatchButton(btn)
	if btn:GetAttribute("TouchPatched") then return end
	btn:SetAttribute("TouchPatched", true)

	-- Fire the button's MouseButton1Click when touched
	btn.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			for _, conn in ipairs(getconnections(btn.MouseButton1Click)) do
				conn:Fire()
			end
		end
	end)
end

local function Scan(obj)
	if obj:IsA("GuiButton") then
		PatchButton(obj)
	end
	for _, child in ipairs(obj:GetChildren()) do
		Scan(child)
	end
end

-- Initial scan
pg.DescendantAdded:Connect(function(d)
	if d:IsA("GuiButton") then
		PatchButton(d)
	end
end)

-- Scan any Guis that appear later
for _, s in ipairs(pg:GetChildren()) do
	Scan(s)
end

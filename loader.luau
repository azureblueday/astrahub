--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local lp = Players.LocalPlayer

--// CONFIG
local NOVA_DISCORD = "https://discord.gg/d7zJgeTy8C"
local ASTRA_SCRIPT_URL = "https://raw.githubusercontent.com/azureblueday/starscripts/refs/heads/main/astra60.luau"

--// GUI SETUP
local gui = Instance.new("ScreenGui")
gui.Name = "AstraDiscontinuedGUI"
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

--// BACKDROP
local backdrop = Instance.new("Frame", gui)
backdrop.Size = UDim2.fromScale(1, 1)
backdrop.BackgroundColor3 = Color3.new(0, 0, 0)
backdrop.BackgroundTransparency = 1
backdrop.BorderSizePixel = 0

--// MAIN FRAME
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(430, 270)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
main.BorderSizePixel = 0
main.BackgroundTransparency = 1

-- UIScale (proper scaling)
local uiScale = Instance.new("UIScale")
uiScale.Scale = 0.9
uiScale.Parent = main

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(70, 60, 90)
stroke.Thickness = 1
stroke.Transparency = 1

--// TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -24, 0, 34)
title.Position = UDim2.fromOffset(12, 12)
title.BackgroundTransparency = 1
title.Text = "Astra Hub Discontinued"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(180, 140, 255)
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextTransparency = 1

--// DESCRIPTION
local desc = Instance.new("TextLabel", main)
desc.Size = UDim2.new(1, -24, 0, 120)
desc.Position = UDim2.fromOffset(12, 54)
desc.BackgroundTransparency = 1
desc.TextWrapped = true
desc.TextYAlignment = Enum.TextYAlignment.Top
desc.Font = Enum.Font.Gotham
desc.TextSize = 14
desc.TextColor3 = Color3.fromRGB(210, 210, 210)
desc.TextTransparency = 1
desc.Text =
	"Astra Hub has officially been discontinued and replaced by Nova Hub.\n\n" ..
	"You may still launch Astra Hub keyless, however it is no longer updated and may be unstable.\n\n" ..
	"For fixes, updates, and future support — use Nova Hub."

--// CONFIRM MODAL
local function showConfirm()
	local modal = Instance.new("Frame", gui)
	modal.Size = UDim2.fromOffset(340, 160)
	modal.Position = UDim2.fromScale(0.5, 0.5)
	modal.AnchorPoint = Vector2.new(0.5, 0.5)
	modal.BackgroundColor3 = Color3.fromRGB(24, 20, 20)
	modal.BackgroundTransparency = 1
	modal.BorderSizePixel = 0

	Instance.new("UICorner", modal).CornerRadius = UDim.new(0, 8)

	local mStroke = Instance.new("UIStroke", modal)
	mStroke.Color = Color3.fromRGB(255, 90, 90)
	mStroke.Transparency = 1

	local txt = Instance.new("TextLabel", modal)
	txt.Size = UDim2.new(1, -20, 0, 60)
	txt.Position = UDim2.fromOffset(10, 14)
	txt.BackgroundTransparency = 1
	txt.TextWrapped = true
	txt.Font = Enum.Font.GothamMedium
	txt.TextSize = 14
	txt.TextColor3 = Color3.fromRGB(240, 200, 200)
	txt.TextTransparency = 1
	txt.Text =
		"You are about to launch Astra Hub.\n\n" ..
		"It is outdated, unmaintained, and may be unsafe."

	local confirm = Instance.new("TextButton", modal)
	confirm.Size = UDim2.new(1, -20, 0, 32)
	confirm.Position = UDim2.fromOffset(10, 100)
	confirm.Text = "Confirm Launch"
	confirm.Font = Enum.Font.GothamBold
	confirm.TextSize = 14
	confirm.BackgroundColor3 = Color3.fromRGB(45, 25, 25)
	confirm.TextColor3 = Color3.fromRGB(255, 130, 130)
	confirm.BackgroundTransparency = 1
	confirm.TextTransparency = 1

	Instance.new("UICorner", confirm).CornerRadius = UDim.new(0, 6)

	confirm.MouseButton1Click:Connect(function()
		-- destroy GUI first
		gui:Destroy()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/azureblueday/astrahub/refs/heads/main/astra60.luau"))()
	
	end)

	TweenService:Create(modal, TweenInfo.new(0.2), { BackgroundTransparency = 0 }):Play()
	TweenService:Create(mStroke, TweenInfo.new(0.2), { Transparency = 0 }):Play()
	TweenService:Create(txt, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()
	TweenService:Create(confirm, TweenInfo.new(0.2), {
		TextTransparency = 0,
		BackgroundTransparency = 0
	}):Play()
end

--// BUTTON CREATOR
local function makeButton(text, y, accent, callback)
	local b = Instance.new("TextButton", main)
	b.Size = UDim2.new(1, -24, 0, 38)
	b.Position = UDim2.fromOffset(12, y)
	b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	b.Text = text
	b.Font = Enum.Font.GothamMedium
	b.TextSize = 14
	b.TextColor3 = Color3.fromRGB(235, 235, 235)
	b.AutoButtonColor = false
	b.TextTransparency = 1
	b.BackgroundTransparency = 1

	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

	local s = Instance.new("UIStroke", b)
	s.Color = accent
	s.Thickness = 1
	s.Transparency = 1

	b.MouseButton1Click:Connect(callback)
	return b, s
end

--// BUTTONS
local discordBtn, discordStroke = makeButton(
	"📋 Copy Nova Hub Discord",
	182,
	Color3.fromRGB(160, 120, 255),
	function()
		if setclipboard then
			setclipboard(NOVA_DISCORD)
		end
	end
)

local astraBtn, astraStroke = makeButton(
	"⚠ Launch Astra Hub (Risky)",
	226,
	Color3.fromRGB(255, 90, 90),
	showConfirm
)

--// INTRO ANIMATION
TweenService:Create(backdrop, TweenInfo.new(0.25), {
	BackgroundTransparency = 0.35
}):Play()

TweenService:Create(main, TweenInfo.new(0.3), {
	BackgroundTransparency = 0
}):Play()

TweenService:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
	Scale = 1
}):Play()

TweenService:Create(stroke, TweenInfo.new(0.3), { Transparency = 0 }):Play()
TweenService:Create(title, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()
TweenService:Create(desc, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()

TweenService:Create(discordBtn, TweenInfo.new(0.3), {
	BackgroundTransparency = 0,
	TextTransparency = 0
}):Play()
TweenService:Create(discordStroke, TweenInfo.new(0.3), { Transparency = 0 }):Play()

TweenService:Create(astraBtn, TweenInfo.new(0.3), {
	BackgroundTransparency = 0,
	TextTransparency = 0
}):Play()
TweenService:Create(astraStroke, TweenInfo.new(0.3), { Transparency = 0 }):Play()

--// DRAG
do
	local dragging, startPos, dragStart
	main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			startPos = main.Position
			dragStart = i.Position
		end
	end)
	main.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = i.Position - dragStart
			main.Position = startPos + UDim2.fromOffset(delta.X, delta.Y)
		end
	end)
end

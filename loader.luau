-- // Settings
local correctText = "inrainbows" -- change this

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- // ScreenGui
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- // Main Frame (dark glass theme)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 380, 0, 240)
frame.Position = UDim2.new(0.5, -190, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.15
frame.Parent = gui

-- Rounded corners
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Soft border outline
local border = Instance.new("UIStroke")
border.Parent = frame
border.Color = Color3.fromRGB(70, 70, 95)
border.Thickness = 1.2
border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Subtle shadow
local shadow = Instance.new("ImageLabel")
shadow.Parent = frame
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6015897843"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.45

-- Title
local title = Instance.new("TextLabel")
title.Parent = frame
title.Text = "Astra Hub Key System"
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 10)
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.TextScaled = true
title.Font = Enum.Font.GothamMedium
title.TextColor3 = Color3.fromRGB(200, 200, 220)
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 6)

-- TextBox
local box = Instance.new("TextBox")
box.Parent = frame
box.Size = UDim2.new(1, -20, 0, 40)
box.Position = UDim2.new(0, 10, 0, 55)
box.PlaceholderText = "Key here..""
box.Text = ""
box.TextScaled = true
box.Font = Enum.Font.GothamSemibold
box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
box.TextColor3 = Color3.fromRGB(230, 230, 240)

Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

local boxBorder = Instance.new("UIStroke", box)
boxBorder.Thickness = 1
boxBorder.Color = Color3.fromRGB(60, 60, 80)

-- Submit Button (blue accent)
local submit = Instance.new("TextButton")
submit.Parent = frame
submit.Size = UDim2.new(1, -20, 0, 40)
submit.Position = UDim2.new(0, 10, 0, 110)
submit.Text = "Submit"
submit.TextScaled = true
submit.Font = Enum.Font.GothamSemibold
submit.TextColor3 = Color3.fromRGB(255, 255, 255)
submit.BackgroundColor3 = Color3.fromRGB(60, 120, 255)

Instance.new("UICorner", submit).CornerRadius = UDim.new(0, 8)

local submitGlow = Instance.new("UIStroke", submit)
submitGlow.Thickness = 1.3
submitGlow.Color = Color3.fromRGB(100, 150, 255)

-- Copy Button
local copyBtn = Instance.new("TextButton")
copyBtn.Parent = frame
copyBtn.Size = UDim2.new(1, -20, 0, 35)
copyBtn.Position = UDim2.new(0, 10, 0, 160)
copyBtn.Text = "Copy Key Link"
copyBtn.TextScaled = true
copyBtn.Font = Enum.Font.Gotham
copyBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
copyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)

Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 8)
local copyStroke = Instance.new("UIStroke", copyBtn)
copyStroke.Thickness = 1
copyStroke.Color = Color3.fromRGB(80, 80, 100)

-- // Tween fade-in
frame.BackgroundTransparency = 1
border.Transparency = 1
box.BackgroundTransparency = 1
submit.BackgroundTransparency = 1
copyBtn.BackgroundTransparency = 1

local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 0.15}):Play()
TweenService:Create(border, tweenInfo, {Transparency = 0}):Play()
TweenService:Create(box, tweenInfo, {BackgroundTransparency = 0}):Play()
TweenService:Create(submit, tweenInfo, {BackgroundTransparency = 0}):Play()
TweenService:Create(copyBtn, tweenInfo, {BackgroundTransparency = 0}):Play()

-- // Submit Logic
submit.MouseButton1Click:Connect(function()
    if box.Text == correctText then
        print("Correct!")

     loadstring(game:HttpGet("https://raw.githubusercontent.com/azureblueday/astrahub/refs/heads/main/execute.luau"))()

        frame.Visible = false
    else
        -- error shake tween
        local original = frame.Position
        local shake1 = TweenService:Create(frame, TweenInfo.new(0.05), {Position = original + UDim2.new(0, -10, 0, 0)})
        local shake2 = TweenService:Create(frame, TweenInfo.new(0.05), {Position = original + UDim2.new(0, 10, 0, 0)})
        
        shake1:Play()
        shake1.Completed:Connect(function()
            shake2:Play()
            shake2.Completed:Connect(function()
                frame.Position = original
            end)
        end)

        box.Text = ""
        box.PlaceholderText = "Incorrect, try again..."
        box.PlaceholderColor3 = Color3.fromRGB(255, 90, 90)
    end
end)

-- // Copy Button
copyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("https://discord.gg/hNDZXMd2Bq")
        print("Copied link!")
    end
end)

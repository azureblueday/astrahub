--// CONFIG
local TARGET_PART_NAME = "Football"   -- ball name in Workspace

local MIN_RANGE        = 0
local MAX_RANGE        = 25
local DEFAULT_RANGE    = 5

local SNAP_DISTANCE    = 5            -- default snap distance
local MAGNET_SPEED     = 400          -- default magnet speed
local JUMP_POWER       = 50

local VERSION          = "v1.14"

-- slider ranges
local MIN_SNAP_DISTANCE    = 0
local MAX_SNAP_DISTANCE    = 20

local MIN_MAGNET_SPEED     = 50
local MAX_MAGNET_SPEED     = 2500

-- Lerp smoothness (only used in Lerp mode)
local SMOOTHNESS = 16  -- higher = snappier, lower = floaty

--// SERVICES
local Players              = game:GetService("Players")
local RunService           = game:GetService("RunService")
local UserInputService     = game:GetService("UserInputService")
local LocalizationService  = game:GetService("LocalizationService")
local VirtualUser          = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

----------------------------------------------------------------------
-- Character / catch part lookup  (STRICTLY CatchRight, no HRP fallback)
----------------------------------------------------------------------

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid  = Character:WaitForChild("Humanoid")
Humanoid.JumpPower = JUMP_POWER

local function findCatchPart(char)
    if not char then return nil end

    -- Only use CatchRight (anywhere under the character)
    local found = char:FindFirstChild("CatchRight", true)
    if found then
        if found:IsA("BasePart") then
            return found
        elseif found:IsA("Attachment") and found.Parent and found.Parent:IsA("BasePart") then
            return found.Parent
        end
    end

    -- If no CatchRight, just return nil so magnet doesn't use HRP
    return nil
end

local CatchPart = findCatchPart(Character)

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid  = char:WaitForChild("Humanoid")
    Humanoid.JumpPower = JUMP_POWER
    CatchPart = findCatchPart(char)
end)

----------------------------------------------------------------------
-- SERVER REGION (for stats)
----------------------------------------------------------------------

local serverRegion = "Unknown"
pcall(function()
    local result = LocalizationService:GetCountryRegionForPlayerAsync(LocalPlayer)
    if result and result ~= "" then
        serverRegion = result
    end
end)

----------------------------------------------------------------------
-- UI CREATION
----------------------------------------------------------------------

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerMagnetUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MagnetFrame"
mainFrame.AnchorPoint = Vector2.new(1, 0) -- top-right anchor
mainFrame.Position = UDim2.new(1, -20, 0, 20)
mainFrame.Size = UDim2.new(0, 260, 0, 280)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Active = true -- needed for dragging
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop    = UDim.new(0, 8)
uiPadding.PaddingBottom = UDim.new(0, 8)
uiPadding.PaddingLeft   = UDim.new(0, 8)
uiPadding.PaddingRight  = UDim.new(0, 8)
uiPadding.Parent = mainFrame

-- TAB BAR (top)
local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(1, 0, 0, 30)
tabBar.BackgroundColor3 = Color3.fromRGB(15, 18, 24)
tabBar.BorderSizePixel = 0
tabBar.Parent = mainFrame

local tabBarCorner = Instance.new("UICorner")
tabBarCorner.CornerRadius = UDim.new(0, 8)
tabBarCorner.Parent = tabBar

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 6)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
tabLayout.Parent = tabBar

-- Tab Buttons
local magnetsTabButton = Instance.new("TextButton")
magnetsTabButton.Size = UDim2.new(0.5, -9, 1, -6)
magnetsTabButton.Position = UDim2.new(0, 0, 0, 3)
magnetsTabButton.BackgroundColor3 = Color3.fromRGB(40, 86, 140)
magnetsTabButton.BorderSizePixel = 0
magnetsTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
magnetsTabButton.Font = Enum.Font.GothamSemibold
magnetsTabButton.TextSize = 14
magnetsTabButton.Text = "Magnets"
magnetsTabButton.AutoButtonColor = true
magnetsTabButton.LayoutOrder = 1
magnetsTabButton.Parent = tabBar

local magnetsTabCorner = Instance.new("UICorner")
magnetsTabCorner.CornerRadius = UDim.new(0, 6)
magnetsTabCorner.Parent = magnetsTabButton

local miscTabButton = Instance.new("TextButton")
miscTabButton.Size = UDim2.new(0.5, -9, 1, -6)
miscTabButton.Position = UDim2.new(0, 0, 0, 3)
miscTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
miscTabButton.BorderSizePixel = 0
miscTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
miscTabButton.Font = Enum.Font.GothamSemibold
miscTabButton.TextSize = 14
miscTabButton.Text = "Misc"
miscTabButton.AutoButtonColor = true
miscTabButton.LayoutOrder = 2
miscTabButton.Parent = tabBar

local miscTabCorner = Instance.new("UICorner")
miscTabCorner.CornerRadius = UDim.new(0, 6)
miscTabCorner.Parent = miscTabButton

-- CONTENT FRAME (below tab bar)
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Position = UDim2.new(0, 0, 0, 36)
contentFrame.Size = UDim2.new(1, 0, 1, -44)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Magnets Page
local magnetsPage = Instance.new("Frame")
magnetsPage.Name = "MagnetsPage"
magnetsPage.Size = UDim2.new(1, 0, 1, 0)
magnetsPage.BackgroundTransparency = 1
magnetsPage.Parent = contentFrame

local magList = Instance.new("UIListLayout")
magList.FillDirection = Enum.FillDirection.Vertical
magList.Padding       = UDim.new(0, 6)
magList.SortOrder     = Enum.SortOrder.LayoutOrder
magList.Parent = magnetsPage

-- Misc Page
local miscPage = Instance.new("Frame")
miscPage.Name = "MiscPage"
miscPage.Size = UDim2.new(1, 0, 1, 0)
miscPage.BackgroundTransparency = 1
miscPage.Visible = false
miscPage.Parent = contentFrame

local miscList = Instance.new("UIListLayout")
miscList.FillDirection = Enum.FillDirection.Vertical
miscList.Padding       = UDim.new(0, 6)
miscList.SortOrder     = Enum.SortOrder.LayoutOrder
miscList.Parent = miscPage

----------------------------------------------------------------------
-- MAGNETS TAB CONTENT
----------------------------------------------------------------------

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 20)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Astra Hub | v1.14"
titleLabel.TextColor3 = Color3.fromRGB(235, 243, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.LayoutOrder = 1
titleLabel.Parent = magnetsPage

-- Toggle magnet button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, 0, 0, 26)
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 120, 70)
toggleButton.BorderSizePixel = 0
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.Gotham
toggleButton.TextSize = 14
toggleButton.Text = "Magnet: ON"
toggleButton.AutoButtonColor = true
toggleButton.LayoutOrder = 2
toggleButton.Parent = magnetsPage

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Range label
local rangeLabel = Instance.new("TextLabel")
rangeLabel.Size = UDim2.new(1, 0, 0, 18)
rangeLabel.BackgroundTransparency = 1
rangeLabel.TextColor3 = Color3.fromRGB(210, 220, 240)
rangeLabel.Font = Enum.Font.GothamSemibold
rangeLabel.TextSize = 13
rangeLabel.TextXAlignment = Enum.TextXAlignment.Left
rangeLabel.LayoutOrder = 3
rangeLabel.Parent = magnetsPage

-- Range slider bar
local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(1, 0, 0, 8)
sliderBar.BackgroundColor3 = Color3.fromRGB(40, 44, 52)
sliderBar.BorderSizePixel = 0
sliderBar.LayoutOrder = 4
sliderBar.Parent = magnetsPage

local sliderBarCorner = Instance.new("UICorner")
sliderBarCorner.CornerRadius = UDim.new(0, 4)
sliderBarCorner.Parent = sliderBar

local sliderHandle = Instance.new("Frame")
sliderHandle.Size = UDim2.new(0, 12, 0, 18)
sliderHandle.BackgroundColor3 = Color3.fromRGB(125, 180, 255)
sliderHandle.BorderSizePixel = 0
sliderHandle.Parent = sliderBar

local handleCorner = Instance.new("UICorner")
handleCorner.CornerRadius = UDim.new(1, 0)
handleCorner.Parent = sliderHandle

-- Hitbox toggle button
local hitboxButton = Instance.new("TextButton")
hitboxButton.Size = UDim2.new(1, 0, 0, 26)
hitboxButton.BackgroundColor3 = Color3.fromRGB(35, 46, 90)
hitboxButton.BorderSizePixel = 0
hitboxButton.TextColor3 = Color3.fromRGB(225, 235, 255)
hitboxButton.Font = Enum.Font.Gotham
hitboxButton.TextSize = 14
hitboxButton.Text = "Show Hitbox: OFF"
hitboxButton.AutoButtonColor = true
hitboxButton.LayoutOrder = 5
hitboxButton.Parent = magnetsPage

local hitboxCorner = Instance.new("UICorner")
hitboxCorner.CornerRadius = UDim.new(0, 8)
hitboxCorner.Parent = hitboxButton

----------------------------------------------------------------------
-- SLIDER: SNAP DISTANCE
----------------------------------------------------------------------

local snapLabel = Instance.new("TextLabel")
snapLabel.Size = UDim2.new(1, 0, 0, 18)
snapLabel.BackgroundTransparency = 1
snapLabel.TextColor3 = Color3.fromRGB(210, 220, 240)
snapLabel.Font = Enum.Font.GothamSemibold
snapLabel.TextSize = 13
snapLabel.TextXAlignment = Enum.TextXAlignment.Left
snapLabel.LayoutOrder = 6
snapLabel.Parent = magnetsPage

local snapSliderBar = Instance.new("Frame")
snapSliderBar.Size = UDim2.new(1, 0, 0, 8)
snapSliderBar.BackgroundColor3 = Color3.fromRGB(40, 44, 52)
snapSliderBar.BorderSizePixel = 0
snapSliderBar.LayoutOrder = 7
snapSliderBar.Parent = magnetsPage

local snapSliderBarCorner = Instance.new("UICorner")
snapSliderBarCorner.CornerRadius = UDim.new(0, 4)
snapSliderBarCorner.Parent = snapSliderBar

local snapSliderHandle = Instance.new("Frame")
snapSliderHandle.Size = UDim2.new(0, 12, 0, 18)
snapSliderHandle.BackgroundColor3 = Color3.fromRGB(125, 180, 255)
snapSliderHandle.BorderSizePixel = 0
snapSliderHandle.Parent = snapSliderBar

local snapHandleCorner = Instance.new("UICorner")
snapHandleCorner.CornerRadius = UDim.new(1, 0)
snapHandleCorner.Parent = snapSliderHandle

----------------------------------------------------------------------
-- SLIDER: MAGNET SPEED
----------------------------------------------------------------------

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 18)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(210, 220, 240)
speedLabel.Font = Enum.Font.GothamSemibold
speedLabel.TextSize = 13
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.LayoutOrder = 8
speedLabel.Parent = magnetsPage

local speedSliderBar = Instance.new("Frame")
speedSliderBar.Size = UDim2.new(1, 0, 0, 8)
speedSliderBar.BackgroundColor3 = Color3.fromRGB(40, 44, 52)
speedSliderBar.BorderSizePixel = 0
speedSliderBar.LayoutOrder = 9
speedSliderBar.Parent = magnetsPage

local speedSliderBarCorner = Instance.new("UICorner")
speedSliderBarCorner.CornerRadius = UDim.new(0, 4)
speedSliderBarCorner.Parent = speedSliderBar

local speedSliderHandle = Instance.new("Frame")
speedSliderHandle.Size = UDim2.new(0, 12, 0, 18)
speedSliderHandle.BackgroundColor3 = Color3.fromRGB(125, 180, 255)
speedSliderHandle.BorderSizePixel = 0
speedSliderHandle.Parent = speedSliderBar

local speedHandleCorner = Instance.new("UICorner")
speedHandleCorner.CornerRadius = UDim.new(1, 0)
speedHandleCorner.Parent = speedSliderHandle

----------------------------------------------------------------------
-- MODE SWITCHER (CFRAME / LERP) - mini tab-style toggle
----------------------------------------------------------------------

local modeFrame = Instance.new("Frame")
modeFrame.Name = "ModeSwitcher"
modeFrame.Size = UDim2.new(1, 0, 0, 26)
modeFrame.BackgroundColor3 = Color3.fromRGB(18, 22, 30)
modeFrame.BorderSizePixel = 0
modeFrame.LayoutOrder = 10
modeFrame.Parent = magnetsPage

local modeCorner = Instance.new("UICorner")
modeCorner.CornerRadius = UDim.new(0, 8)
modeCorner.Parent = modeFrame

local modeLayout = Instance.new("UIListLayout")
modeLayout.FillDirection = Enum.FillDirection.Horizontal
modeLayout.Padding = UDim.new(0, 6)
modeLayout.SortOrder = Enum.SortOrder.LayoutOrder
modeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
modeLayout.Parent = modeFrame

local cframeButton = Instance.new("TextButton")
cframeButton.Size = UDim2.new(0.5, -9, 1, -6)
cframeButton.Position = UDim2.new(0, 0, 0, 3)
cframeButton.BackgroundColor3 = Color3.fromRGB(40, 86, 140)
cframeButton.BorderSizePixel = 0
cframeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
cframeButton.Font = Enum.Font.GothamSemibold
cframeButton.TextSize = 13
cframeButton.Text = "CFrame"
cframeButton.AutoButtonColor = true
cframeButton.LayoutOrder = 1
cframeButton.Parent = modeFrame

local cframeCorner = Instance.new("UICorner")
cframeCorner.CornerRadius = UDim.new(0, 6)
cframeCorner.Parent = cframeButton

local lerpButton = Instance.new("TextButton")
lerpButton.Size = UDim2.new(0.5, -9, 1, -6)
lerpButton.Position = UDim2.new(0, 0, 0, 3)
lerpButton.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
lerpButton.BorderSizePixel = 0
lerpButton.TextColor3 = Color3.fromRGB(200, 200, 200)
lerpButton.Font = Enum.Font.GothamSemibold
lerpButton.TextSize = 13
lerpButton.Text = "Lerp"
lerpButton.AutoButtonColor = true
lerpButton.LayoutOrder = 2
lerpButton.Parent = modeFrame

local lerpCorner = Instance.new("UICorner")
lerpCorner.CornerRadius = UDim.new(0, 6)
lerpCorner.Parent = lerpButton

local useLerp = false

local function updateModeButtons()
    if useLerp then
        lerpButton.BackgroundColor3   = Color3.fromRGB(40, 86, 140)
        lerpButton.TextColor3         = Color3.fromRGB(255, 255, 255)
        cframeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
        cframeButton.TextColor3       = Color3.fromRGB(200, 200, 200)
    else
        cframeButton.BackgroundColor3 = Color3.fromRGB(40, 86, 140)
        cframeButton.TextColor3       = Color3.fromRGB(255, 255, 255)
        lerpButton.BackgroundColor3   = Color3.fromRGB(30, 30, 36)
        lerpButton.TextColor3         = Color3.fromRGB(200, 200, 200)
    end
end

cframeButton.MouseButton1Click:Connect(function()
    useLerp = false
    updateModeButtons()
end)

lerpButton.MouseButton1Click:Connect(function()
    useLerp = true
    updateModeButtons()
end)

updateModeButtons()

----------------------------------------------------------------------
-- MISC TAB CONTENT
----------------------------------------------------------------------

-- FUCK IT button
local fuckItButton = Instance.new("TextButton")
fuckItButton.Size = UDim2.new(1, 0, 0, 30)
fuckItButton.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
fuckItButton.BorderSizePixel = 0
fuckItButton.TextColor3 = Color3.fromRGB(255, 255, 255)
fuckItButton.Font = Enum.Font.GothamBold
fuckItButton.TextSize = 16
fuckItButton.Text = "FUCK IT (BANS!)"
fuckItButton.AutoButtonColor = true
fuckItButton.LayoutOrder = 1
fuckItButton.Parent = miscPage

local fuckItCorner = Instance.new("UICorner")
fuckItCorner.CornerRadius = UDim.new(0, 8)
fuckItCorner.Parent = fuckItButton

local fuckItNote = Instance.new("TextLabel")
fuckItNote.Size = UDim2.new(1, 0, 0, 14)
fuckItNote.BackgroundTransparency = 1
fuckItNote.TextColor3 = Color3.fromRGB(230, 180, 180)
fuckItNote.Font = Enum.Font.Gotham
fuckItNote.TextSize = 11
fuckItNote.TextXAlignment = Enum.TextXAlignment.Left
fuckItNote.Text = "Note: max rage values, use at your own risk."
fuckItNote.LayoutOrder = 2
fuckItNote.Parent = miscPage

-- Stats title
local statsTitle = Instance.new("TextLabel")
statsTitle.Size = UDim2.new(1, 0, 0, 18)
statsTitle.BackgroundTransparency = 1
statsTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
statsTitle.Font = Enum.Font.GothamSemibold
statsTitle.TextSize = 14
statsTitle.TextXAlignment = Enum.TextXAlignment.Left
statsTitle.Text = "Stats"
statsTitle.LayoutOrder = 3
statsTitle.Parent = miscPage

-- Version label
local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(1, 0, 0, 18)
versionLabel.BackgroundTransparency = 1
versionLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
versionLabel.Font = Enum.Font.Gotham
versionLabel.TextSize = 13
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.Text = "Version " .. VERSION
versionLabel.LayoutOrder = 4
versionLabel.Parent = miscPage

-- Region label
local regionLabel = Instance.new("TextLabel")
regionLabel.Size = UDim2.new(1, 0, 0, 18)
regionLabel.BackgroundTransparency = 1
regionLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
regionLabel.Font = Enum.Font.Gotham
regionLabel.TextSize = 13
regionLabel.TextXAlignment = Enum.TextXAlignment.Left
regionLabel.Text = "Server Region: " .. serverRegion
regionLabel.LayoutOrder = 5
regionLabel.Parent = miscPage

-- Discord Button (copy invite to clipboard)
local discordButton = Instance.new("TextButton")
discordButton.Size = UDim2.new(1, 0, 0, 26)
discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordButton.BorderSizePixel = 0
discordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
discordButton.Font = Enum.Font.GothamBold
discordButton.TextSize = 14
discordButton.Text = "Discord (Copy Invite)"
discordButton.AutoButtonColor = true
discordButton.LayoutOrder = 6
discordButton.Parent = miscPage

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 8)
discordCorner.Parent = discordButton

local discordInvite = "https://discord.gg/hNDZXMd2Bq"

discordButton.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then
            setclipboard(discordInvite)
            print("[FF2] Discord invite copied to clipboard:", discordInvite)
        else
            print("[FF2] Copy to clipboard not available. Invite:", discordInvite)
        end
    end)
end)

-- STATE

local magnetEnabled       = true
local hitboxVisible       = false

local draggingRangeSlider = false
local draggingSnapSlider  = false
local draggingSpeedSlider = false

local currentRange        = DEFAULT_RANGE
local uiDestroyed         = false

-- for auto click debounce
local lastClickedFootball = nil

-- Hitbox sphere (ON THE NEAREST FOOTBALL)

local hitboxPart = Instance.new("Part")
hitboxPart.Name = "FootballMagnetHitbox_Local"
hitboxPart.Shape = Enum.PartType.Ball
hitboxPart.Anchored = true
hitboxPart.CanCollide = false
hitboxPart.Massless = true
hitboxPart.Material = Enum.Material.ForceField
hitboxPart.Color = Color3.fromRGB(0, 0, 255)
hitboxPart.Transparency = 1
hitboxPart.Size = Vector3.new(DEFAULT_RANGE * 2, DEFAULT_RANGE * 2, DEFAULT_RANGE * 2)
hitboxPart.Parent = workspace

-- helper to clamp & UI updates
local function clamp(x, a, b)
    if x < a then return a end
    if x > b then return b end
    return x
end

local function updateRangeLabel()
    rangeLabel.Text = ("Range: %.1f studs"):format(currentRange)
end

local function updateHitboxSize()
    hitboxPart.Size = Vector3.new(currentRange * 2, currentRange * 2, currentRange * 2)
end

local function setMagnetEnabled(on)
    magnetEnabled = on
    toggleButton.Text = on and "Magnet: ON" or "Magnet: OFF"
    toggleButton.BackgroundColor3 = on and Color3.fromRGB(30, 120, 70)
                                       or Color3.fromRGB(60, 60, 60)
end

local function setHitboxVisible(on)
    hitboxVisible = on
    hitboxButton.Text = on and "Show Hitbox: ON" or "Show Hitbox: OFF"
    hitboxButton.BackgroundColor3 = on and Color3.fromRGB(30, 90, 160)
                                       or Color3.fromRGB(35, 46, 90)
    hitboxPart.Transparency = on and 0.7 or 1
end

-- slider helpers for distance

local function setSliderFromRange()
    local barAbsPos  = sliderBar.AbsolutePosition.X
    local barAbsSize = sliderBar.AbsoluteSize.X
    if barAbsSize <= 0 then return end

    local alpha = (currentRange - MIN_RANGE) / (MAX_RANGE - MIN_RANGE)
    alpha = clamp(alpha, 0, 1)
    local handleX = barAbsPos + alpha * barAbsSize

    sliderHandle.Position = UDim2.new(
        0,
        handleX - barAbsPos - sliderHandle.AbsoluteSize.X / 2,
        0.5,
        -sliderHandle.AbsoluteSize.Y / 2
    )
end

local function updateRangeFromInput(input)
    local barAbsPos  = sliderBar.AbsolutePosition.X
    local barAbsSize = sliderBar.AbsoluteSize.X
    if barAbsSize <= 0 then return end

    local x     = input.Position.X
    local alpha = clamp((x - barAbsPos) / barAbsSize, 0, 1)
    currentRange = MIN_RANGE + (MAX_RANGE - MIN_RANGE) * alpha

    updateRangeLabel()
    updateHitboxSize()
    setSliderFromRange()
end

-- SLIDER HELPERS: SNAP DISTANCE

local function updateSnapLabel()
    snapLabel.Text = ("Snap Distance: %.1f studs"):format(SNAP_DISTANCE)
end

local function setSnapSliderFromValue()
    local barAbsPos  = snapSliderBar.AbsolutePosition.X
    local barAbsSize = snapSliderBar.AbsoluteSize.X
    if barAbsSize <= 0 then return end

    local alpha = (SNAP_DISTANCE - MIN_SNAP_DISTANCE) / (MAX_SNAP_DISTANCE - MIN_SNAP_DISTANCE)
    alpha = clamp(alpha, 0, 1)
    local handleX = barAbsPos + alpha * barAbsSize

    snapSliderHandle.Position = UDim2.new(
        0,
        handleX - barAbsPos - snapSliderHandle.AbsoluteSize.X / 2,
        0.5,
        -snapSliderHandle.AbsoluteSize.Y / 2
    )
end

local function updateSnapFromInput(input)
    local barAbsPos  = snapSliderBar.AbsolutePosition.X
    local barAbsSize = snapSliderBar.AbsoluteSize.X
    if barAbsSize <= 0 then return end

    local x     = input.Position.X
    local alpha = clamp((x - barAbsPos) / barAbsSize, 0, 1)
    SNAP_DISTANCE = MIN_SNAP_DISTANCE + (MAX_SNAP_DISTANCE - MIN_SNAP_DISTANCE) * alpha

    updateSnapLabel()
    setSnapSliderFromValue()
end

----------------------------------------------------------------------
-- SLIDER HELPERS: MAGNET SPEED
----------------------------------------------------------------------

local function updateSpeedLabel()
    speedLabel.Text = ("Magnet Speed: %d"):format(math.floor(MAGNET_SPEED + 0.5))
end

local function setSpeedSliderFromValue()
    local barAbsPos  = speedSliderBar.AbsolutePosition.X
    local barAbsSize = speedSliderBar.AbsoluteSize.X
    if barAbsSize <= 0 then return end

    local alpha = (MAGNET_SPEED - MIN_MAGNET_SPEED) / (MAX_MAGNET_SPEED - MIN_MAGNET_SPEED)
    alpha = clamp(alpha, 0, 1)
    local handleX = barAbsPos + alpha * barAbsSize

    speedSliderHandle.Position = UDim2.new(
        0,
        handleX - barAbsPos - speedSliderHandle.AbsoluteSize.X / 2,
        0.5,
        -speedSliderHandle.AbsoluteSize.Y / 2
    )
end

local function updateSpeedFromInput(input)
    local barAbsPos  = speedSliderBar.AbsolutePosition.X
    local barAbsSize = speedSliderBar.AbsoluteSize.X
    if barAbsSize <= 0 then return end

    local x     = input.Position.X
    local alpha = clamp((x - barAbsPos) / barAbsSize, 0, 1)
    MAGNET_SPEED = MIN_MAGNET_SPEED + (MAX_MAGNET_SPEED - MIN_MAGNET_SPEED) * alpha

    updateSpeedLabel()
    setSpeedSliderFromValue()
end

-- init UI

currentRange = clamp(DEFAULT_RANGE, MIN_RANGE, MAX_RANGE)
SNAP_DISTANCE = clamp(SNAP_DISTANCE, MIN_SNAP_DISTANCE, MAX_SNAP_DISTANCE)
MAGNET_SPEED  = clamp(MAGNET_SPEED, MIN_MAGNET_SPEED, MAX_MAGNET_SPEED)

updateRangeLabel()
updateHitboxSize()
updateSnapLabel()
updateSpeedLabel()

RunService.Heartbeat:Wait()
setSliderFromRange()
setSnapSliderFromValue()
setSpeedSliderFromValue()
setMagnetEnabled(true)
setHitboxVisible(false)

-- TAB SWITCHING

local function setActiveTab(tabName)
    if tabName == "Magnets" then
        magnetsPage.Visible = true
        miscPage.Visible    = false

        magnetsTabButton.BackgroundColor3 = Color3.fromRGB(40, 86, 140)
        magnetsTabButton.TextColor3       = Color3.fromRGB(255, 255, 255)
        miscTabButton.BackgroundColor3    = Color3.fromRGB(30, 30, 36)
        miscTabButton.TextColor3          = Color3.fromRGB(200, 200, 200)
    elseif tabName == "Misc" then
        magnetsPage.Visible = false
        miscPage.Visible    = true

        miscTabButton.BackgroundColor3    = Color3.fromRGB(40, 86, 140)
        miscTabButton.TextColor3          = Color3.fromRGB(255, 255, 255)
        magnetsTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
        magnetsTabButton.TextColor3       = Color3.fromRGB(200, 200, 200)
    end
end

setActiveTab("Magnets")

magnetsTabButton.MouseButton1Click:Connect(function()
    setActiveTab("Magnets")
end)

miscTabButton.MouseButton1Click:Connect(function()
    setActiveTab("Misc")
end)

-- DRAGGABLE (ONLY TAB BAR, SO SLIDERS STAY USABLE)

local draggingFrame = false
local dragStart
local startPos

tabBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        draggingFrame = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function(change)
            if change == "UserInputState" and input.UserInputState == Enum.UserInputState.End then
                draggingFrame = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingFrame and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then

        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- UI input (buttons, sliders, Left Ctrl, FUCK IT)

toggleButton.MouseButton1Click:Connect(function()
    setMagnetEnabled(not magnetEnabled)
end)

hitboxButton.MouseButton1Click:Connect(function()
    setHitboxVisible(not hitboxVisible)
end)

-- RANGE SLIDER
sliderHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        draggingRangeSlider = true
    end
end)

sliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        draggingRangeSlider = true
        updateRangeFromInput(input)
    end
end)

-- SNAP SLIDER
snapSliderHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        draggingSnapSlider = true
    end
end)

snapSliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        draggingSnapSlider = true
        updateSnapFromInput(input)
    end
end)

-- SPEED SLIDER
speedSliderHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        draggingSpeedSlider = true
    end
end)

speedSliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        draggingSpeedSlider = true
        updateSpeedFromInput(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        draggingRangeSlider = false
        draggingSnapSlider  = false
        draggingSpeedSlider = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    if draggingRangeSlider then
        updateRangeFromInput(input)
    end
    if draggingSnapSlider then
        updateSnapFromInput(input)
    end
    if draggingSpeedSlider then
        updateSpeedFromInput(input)
    end
end)

-- Left Ctrl to show/hide the whole UI (unless destroyed by FUCK IT)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if uiDestroyed then return end

    if input.KeyCode == Enum.KeyCode.LeftControl then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- FUCK IT button logic
fuckItButton.MouseButton1Click:Connect(function()
    currentRange  = 100
    updateRangeLabel()
    updateHitboxSize()
    setSliderFromRange()

    MAGNET_SPEED  = 2500
    SNAP_DISTANCE = 20
    updateSnapLabel()
    updateSpeedLabel()
    setSnapSliderFromValue()
    setSpeedSliderFromValue()

    uiDestroyed = true
    if screenGui then
        screenGui:Destroy()
    end
end)

-- Auto-click helper (when ball hits CatchRight)

local function autoClick()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(0, 0))
    end)
end

-- MAGNET + HITBOX UPDATE (toward CatchRight ONLY)

RunService.Heartbeat:Connect(function(dt)
    if not Character or not Character.Parent then return end

    -- re-acquire CatchRight if needed
    if not CatchPart or not CatchPart.Parent then
        CatchPart = findCatchPart(Character)
    end
    if not CatchPart then return end

    local catchPos = CatchPart.Position
    local nearestFootball
    local nearestDist = math.huge

    -- find nearest football and pull it in
    for _, inst in ipairs(workspace:GetDescendants()) do
        if inst:IsA("BasePart") and inst.Name == TARGET_PART_NAME then
            local offset   = catchPos - inst.Position
            local distance = offset.Magnitude

            if distance < nearestDist then
                nearestDist = distance
                nearestFootball = inst
            end

            if magnetEnabled and distance <= currentRange and distance > 0.01 then

                ----------------------------------------------------------------
                -- CFRAME MODE (OG style, strong and snappy)
                ----------------------------------------------------------------
                if not useLerp then
                    if distance <= SNAP_DISTANCE then
                        inst.CFrame = CFrame.new(catchPos, catchPos + CatchPart.CFrame.LookVector)

                        if lastClickedFootball ~= inst then
                            lastClickedFootball = inst
                            autoClick()
                        end
                    else
                        local dir    = offset.Unit
                        local step   = math.min(MAGNET_SPEED * dt, distance)
                        local newPos = inst.Position + dir * step
                        inst.CFrame = CFrame.new(newPos, catchPos)
                    end
                else
                ----------------------------------------------------------------
                -- LERP MODE (smooth / legit)
                ----------------------------------------------------------------
                    if distance <= SNAP_DISTANCE then
                        local alpha = 1 - math.exp(-SMOOTHNESS * 2 * dt)
                        local targetCF = CFrame.new(catchPos, catchPos + CatchPart.CFrame.LookVector)

                        -- soft snap
                        inst.CFrame = inst.CFrame:Lerp(targetCF, alpha)

                        -- final snap + click when very close
                        if distance <= (SNAP_DISTANCE * 0.3) then
                            inst.CFrame = targetCF
                            if lastClickedFootball ~= inst then
                                lastClickedFootball = inst
                                autoClick()
                            end
                        end
                    else
                        local alpha = 1 - math.exp(-SMOOTHNESS * dt)
                        local targetPos = catchPos
                        local newPos    = inst.Position:Lerp(targetPos, alpha)
                        local targetCF  = CFrame.new(newPos, catchPos)

                        inst.CFrame = inst.CFrame:Lerp(targetCF, alpha)
                    end
                end
            end
        end
    end

    -- move hitbox to the nearest football (or keep hidden)
    if nearestFootball and hitboxVisible then
        hitboxPart.CFrame = nearestFootball.CFrame
    end
end)

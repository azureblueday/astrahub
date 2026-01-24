local AstraLib = {}
AstraLib.__index = AstraLib
print("Astra UI Library - by @d1starzz (discord.gg/getnova)
-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- ═══════════════════════════════════════════════════════════════════
-- ZINDEX SYSTEM
-- ═══════════════════════════════════════════════════════════════════
local ZIndex = {
    Shadow = 1,
    Background = 2,
    Sidebar = 10,
    SidebarContent = 15,
    Content = 20,
    Cards = 25,
    Elements = 30,
    ElementsTop = 35,
    Dropdown = 100,
    DropdownItems = 105,
    TopBar = 50,
    Modal = 200,
    MobileButton = 500
}

-- ═══════════════════════════════════════════════════════════════════
-- ANIMATION PRESETS
-- ═══════════════════════════════════════════════════════════════════
local TweenPresets = {
    Instant = TweenInfo.new(0.08, Enum.EasingStyle.Linear),
    Quick = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Normal = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    Elastic = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
}

-- ═══════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════
local function Create(instanceType, properties, children)
    local instance = Instance.new(instanceType)
    for prop, value in pairs(properties or {}) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    for _, child in pairs(children or {}) do
        child.Parent = instance
    end
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function Tween(instance, properties, preset)
    preset = preset or TweenPresets.Normal
    local tween = TweenService:Create(instance, preset, properties)
    tween:Play()
    return tween
end

local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function GetScale()
    local viewport = workspace.CurrentCamera.ViewportSize
    if IsMobile() then
        return math.clamp(viewport.X / 1200, 0.5, 1)
    end
    return 1
end

local function Ripple(button, x, y)
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    local ripple = Create("Frame", {
        Parent = button,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.7,
        Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = button.ZIndex + 1
    }, {
        Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    Tween(ripple, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1}, TweenPresets.Smooth)
    task.delay(0.4, function()
        if ripple then ripple:Destroy() end
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- THEMES (Glass Design - RGB 58, 133, 212 accent)
-- ═══════════════════════════════════════════════════════════════════
local Themes = {
    Dark = {
        Name = "Dark",
        Background = Color3.fromRGB(15, 15, 22),
        Sidebar = Color3.fromRGB(18, 18, 28),
        Card = Color3.fromRGB(22, 22, 35),
        CardTransparency = 0.25,
        CardBorder = Color3.fromRGB(50, 50, 70),
        CardHover = Color3.fromRGB(30, 30, 48),
        Text = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(140, 140, 160),
        Accent = Color3.fromRGB(58, 133, 212),
        AccentHover = Color3.fromRGB(70, 145, 220),
        AccentDark = Color3.fromRGB(45, 110, 180),
        Toggle = Color3.fromRGB(58, 133, 212),
        ToggleOff = Color3.fromRGB(45, 45, 60),
        SliderFill = Color3.fromRGB(58, 133, 212),
        SliderBg = Color3.fromRGB(35, 35, 50),
        Input = Color3.fromRGB(25, 25, 38),
        InputTransparency = 0.4,
        InputBorder = Color3.fromRGB(55, 55, 75),
        InputFocus = Color3.fromRGB(58, 133, 212),
        Shadow = Color3.fromRGB(0, 0, 0),
        Success = Color3.fromRGB(34, 197, 94),
        Error = Color3.fromRGB(239, 68, 68),
        Glass = Color3.fromRGB(255, 255, 255),
        GlassTransparency = 0.95,
    },
    Midnight = {
        Name = "Midnight",
        Background = Color3.fromRGB(8, 8, 18),
        Sidebar = Color3.fromRGB(12, 12, 25),
        Card = Color3.fromRGB(18, 18, 35),
        CardTransparency = 0.3,
        CardBorder = Color3.fromRGB(40, 40, 70),
        CardHover = Color3.fromRGB(28, 28, 50),
        Text = Color3.fromRGB(220, 220, 255),
        TextMuted = Color3.fromRGB(110, 110, 150),
        Accent = Color3.fromRGB(58, 133, 212),
        AccentHover = Color3.fromRGB(70, 145, 220),
        AccentDark = Color3.fromRGB(45, 110, 180),
        Toggle = Color3.fromRGB(58, 133, 212),
        ToggleOff = Color3.fromRGB(40, 40, 60),
        SliderFill = Color3.fromRGB(58, 133, 212),
        SliderBg = Color3.fromRGB(30, 30, 50),
        Input = Color3.fromRGB(20, 20, 38),
        InputTransparency = 0.45,
        InputBorder = Color3.fromRGB(50, 50, 80),
        InputFocus = Color3.fromRGB(58, 133, 212),
        Shadow = Color3.fromRGB(0, 0, 0),
        Success = Color3.fromRGB(34, 197, 94),
        Error = Color3.fromRGB(239, 68, 68),
        Glass = Color3.fromRGB(200, 200, 255),
        GlassTransparency = 0.93,
    },
    Ocean = {
        Name = "Ocean",
        Background = Color3.fromRGB(8, 15, 28),
        Sidebar = Color3.fromRGB(10, 20, 35),
        Card = Color3.fromRGB(15, 28, 48),
        CardTransparency = 0.3,
        CardBorder = Color3.fromRGB(35, 60, 95),
        CardHover = Color3.fromRGB(22, 40, 65),
        Text = Color3.fromRGB(220, 240, 255),
        TextMuted = Color3.fromRGB(100, 145, 180),
        Accent = Color3.fromRGB(58, 133, 212),
        AccentHover = Color3.fromRGB(70, 145, 220),
        AccentDark = Color3.fromRGB(45, 110, 180),
        Toggle = Color3.fromRGB(58, 133, 212),
        ToggleOff = Color3.fromRGB(28, 50, 75),
        SliderFill = Color3.fromRGB(58, 133, 212),
        SliderBg = Color3.fromRGB(22, 42, 68),
        Input = Color3.fromRGB(12, 25, 45),
        InputTransparency = 0.45,
        InputBorder = Color3.fromRGB(40, 70, 105),
        InputFocus = Color3.fromRGB(58, 133, 212),
        Shadow = Color3.fromRGB(0, 0, 0),
        Success = Color3.fromRGB(34, 197, 94),
        Error = Color3.fromRGB(239, 68, 68),
        Glass = Color3.fromRGB(180, 220, 255),
        GlassTransparency = 0.9,
    },
    Purple = {
        Name = "Purple",
        Background = Color3.fromRGB(12, 8, 22),
        Sidebar = Color3.fromRGB(18, 12, 32),
        Card = Color3.fromRGB(28, 20, 48),
        CardTransparency = 0.3,
        CardBorder = Color3.fromRGB(60, 45, 90),
        CardHover = Color3.fromRGB(40, 30, 65),
        Text = Color3.fromRGB(240, 230, 255),
        TextMuted = Color3.fromRGB(145, 130, 175),
        Accent = Color3.fromRGB(58, 133, 212),
        AccentHover = Color3.fromRGB(70, 145, 220),
        AccentDark = Color3.fromRGB(45, 110, 180),
        Toggle = Color3.fromRGB(58, 133, 212),
        ToggleOff = Color3.fromRGB(50, 38, 72),
        SliderFill = Color3.fromRGB(58, 133, 212),
        SliderBg = Color3.fromRGB(42, 32, 65),
        Input = Color3.fromRGB(25, 18, 42),
        InputTransparency = 0.45,
        InputBorder = Color3.fromRGB(70, 52, 100),
        InputFocus = Color3.fromRGB(58, 133, 212),
        Shadow = Color3.fromRGB(0, 0, 0),
        Success = Color3.fromRGB(34, 197, 94),
        Error = Color3.fromRGB(239, 68, 68),
        Glass = Color3.fromRGB(220, 200, 255),
        GlassTransparency = 0.9,
    },
    Emerald = {
        Name = "Emerald",
        Background = Color3.fromRGB(8, 15, 12),
        Sidebar = Color3.fromRGB(10, 22, 18),
        Card = Color3.fromRGB(15, 32, 26),
        CardTransparency = 0.3,
        CardBorder = Color3.fromRGB(35, 70, 58),
        CardHover = Color3.fromRGB(22, 45, 38),
        Text = Color3.fromRGB(220, 255, 245),
        TextMuted = Color3.fromRGB(105, 160, 145),
        Accent = Color3.fromRGB(58, 133, 212),
        AccentHover = Color3.fromRGB(70, 145, 220),
        AccentDark = Color3.fromRGB(45, 110, 180),
        Toggle = Color3.fromRGB(58, 133, 212),
        ToggleOff = Color3.fromRGB(30, 55, 48),
        SliderFill = Color3.fromRGB(58, 133, 212),
        SliderBg = Color3.fromRGB(25, 48, 40),
        Input = Color3.fromRGB(12, 28, 22),
        InputTransparency = 0.45,
        InputBorder = Color3.fromRGB(40, 80, 65),
        InputFocus = Color3.fromRGB(58, 133, 212),
        Shadow = Color3.fromRGB(0, 0, 0),
        Success = Color3.fromRGB(34, 197, 94),
        Error = Color3.fromRGB(239, 68, 68),
        Glass = Color3.fromRGB(200, 255, 235),
        GlassTransparency = 0.9,
    },
    Rose = {
        Name = "Rose",
        Background = Color3.fromRGB(18, 10, 15),
        Sidebar = Color3.fromRGB(25, 15, 20),
        Card = Color3.fromRGB(38, 22, 30),
        CardTransparency = 0.3,
        CardBorder = Color3.fromRGB(75, 48, 60),
        CardHover = Color3.fromRGB(52, 32, 42),
        Text = Color3.fromRGB(255, 235, 245),
        TextMuted = Color3.fromRGB(170, 135, 150),
        Accent = Color3.fromRGB(58, 133, 212),
        AccentHover = Color3.fromRGB(70, 145, 220),
        AccentDark = Color3.fromRGB(45, 110, 180),
        Toggle = Color3.fromRGB(58, 133, 212),
        ToggleOff = Color3.fromRGB(62, 42, 52),
        SliderFill = Color3.fromRGB(58, 133, 212),
        SliderBg = Color3.fromRGB(55, 35, 45),
        Input = Color3.fromRGB(32, 18, 25),
        InputTransparency = 0.45,
        InputBorder = Color3.fromRGB(88, 55, 68),
        InputFocus = Color3.fromRGB(58, 133, 212),
        Shadow = Color3.fromRGB(0, 0, 0),
        Success = Color3.fromRGB(34, 197, 94),
        Error = Color3.fromRGB(239, 68, 68),
        Glass = Color3.fromRGB(255, 210, 230),
        GlassTransparency = 0.9,
    },
}

-- ═══════════════════════════════════════════════════════════════════
-- CONFIG SYSTEM
-- ═══════════════════════════════════════════════════════════════════
local ConfigSystem = {}
ConfigSystem.__index = ConfigSystem

function ConfigSystem.new(folder)
    local self = setmetatable({}, ConfigSystem)
    self.Folder = folder or "AstraLib"
    self.Elements = {}
    pcall(function()
        if not isfolder(self.Folder) then makefolder(self.Folder) end
    end)
    return self
end

function ConfigSystem:RegisterElement(id, element)
    self.Elements[id] = element
end

function ConfigSystem:GetConfigs()
    local configs = {}
    pcall(function()
        if isfolder(self.Folder) then
            for _, file in pairs(listfiles(self.Folder)) do
                local name = file:match("([^/\\]+)%.json$")
                if name then table.insert(configs, name) end
            end
        end
    end)
    return configs
end

function ConfigSystem:SaveConfig(name)
    local data = {}
    for id, element in pairs(self.Elements) do
        if element.Type == "Toggle" then data[id] = element.Value
        elseif element.Type == "Slider" then data[id] = element.Value
        elseif element.Type == "Dropdown" then data[id] = element.Value
        elseif element.Type == "Keybind" then data[id] = element.Value.Name
        elseif element.Type == "Input" then data[id] = element.Value
        end
    end
    pcall(function()
        writefile(self.Folder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
    end)
end

function ConfigSystem:LoadConfig(name)
    pcall(function()
        local path = self.Folder .. "/" .. name .. ".json"
        if isfile(path) then
            local data = HttpService:JSONDecode(readfile(path))
            for id, value in pairs(data) do
                local element = self.Elements[id]
                if element then
                    if element.Type == "Toggle" then element:Set(value)
                    elseif element.Type == "Slider" then element:Set(value)
                    elseif element.Type == "Dropdown" then element:Set(value)
                    elseif element.Type == "Keybind" then element:Set(Enum.KeyCode[value])
                    elseif element.Type == "Input" then element:Set(value)
                    end
                end
            end
        end
    end)
end

function ConfigSystem:DeleteConfig(name)
    pcall(function()
        local path = self.Folder .. "/" .. name .. ".json"
        if isfile(path) then delfile(path) end
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- MAIN LIBRARY
-- ═══════════════════════════════════════════════════════════════════
function AstraLib:CreateWindow(options)
    options = options or {}
    local Title = options.Title or "Nova Hub"
    local Version = options.Version or "v1.0"
    local ThemeName = options.Theme or "Dark"
    local ConfigFolder = options.ConfigFolder or "NovaHub"
    local DefaultTab = options.DefaultTab
    local MinimizeKey = options.MinimizeKey or Enum.KeyCode.LeftControl
    
    local Theme = Themes[ThemeName] or Themes.Dark
    local Window = {
        Tabs = {},
        ActiveTab = nil,
        Theme = Theme,
        ThemeName = ThemeName,
        Open = true,
        Config = ConfigSystem.new(ConfigFolder),
        OpenDropdown = nil
    }
    
    local Scale = GetScale()
    
    -- Destroy existing
    if CoreGui:FindFirstChild("AstraLib") then
        CoreGui:FindFirstChild("AstraLib"):Destroy()
    end
    
    -- ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "AstraLib",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false,
        IgnoreGuiInset = true
    })
    
    -- Mobile Button
    local MobileButton = Create("ImageButton", {
        Name = "MobileToggle",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.15,
        Position = UDim2.new(0, 15, 0.5, -25),
        Size = UDim2.new(0, 50, 0, 50),
        Visible = IsMobile(),
        ZIndex = ZIndex.MobileButton,
        Image = "rbxassetid://7072718362",
        ImageColor3 = Color3.new(1, 1, 1),
        AutoButtonColor = false
    }, {Create("UICorner", {CornerRadius = UDim.new(0, 25)}), Create("UIStroke", {Color = Theme.CardBorder, Thickness = 1, Transparency = 0.6})})
    
    MobileButton.MouseEnter:Connect(function()
        Tween(MobileButton, {BackgroundColor3 = Theme.AccentHover, Size = UDim2.new(0, 55, 0, 55)}, TweenPresets.Bounce)
    end)
    MobileButton.MouseLeave:Connect(function()
        Tween(MobileButton, {BackgroundColor3 = Theme.Accent, Size = UDim2.new(0, 50, 0, 50)}, TweenPresets.Normal)
    end)
    
    -- Main Container
    local MainContainer = Create("Frame", {
        Name = "MainContainer",
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 900 * Scale, 0, 600 * Scale),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = ZIndex.Background
    })
    
    -- Main Frame (Glass)
    local MainFrame = Create("Frame", {
        Name = "Main",
        Parent = MainContainer,
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.08,
        Size = UDim2.new(1, 0, 1, 0),
        ClipsDescendants = true,
        ZIndex = ZIndex.Background
    }, {Create("UICorner", {CornerRadius = UDim.new(0, 12)}), Create("UIStroke", {Color = Theme.CardBorder, Thickness = 1, Transparency = 0.4})})
    
    -- Shadow
    Create("ImageLabel", {
        Name = "Shadow",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 80, 1, 80),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = ZIndex.Shadow,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Theme.Shadow,
        ImageTransparency = 0.55,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450)
    })
    
    -- Sidebar (Glass)
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor3 = Theme.Sidebar,
        BackgroundTransparency = 0.15,
        Size = UDim2.new(0, 200 * Scale, 1, 0),
        ZIndex = ZIndex.Sidebar,
        ClipsDescendants = true
    }, {Create("UICorner", {CornerRadius = UDim.new(0, 12)})})
    
    -- Sidebar corner fix
    Create("Frame", {
        Name = "Fix",
        Parent = Sidebar,
        BackgroundColor3 = Theme.Sidebar,
        BackgroundTransparency = 0.15,
        Position = UDim2.new(1, -12, 0, 0),
        Size = UDim2.new(0, 14, 1, 0),
        BorderSizePixel = 0,
        ZIndex = ZIndex.Sidebar + 1
    })
    
    -- Sidebar divider (Glass line)
    Create("Frame", {
        Name = "Divider",
        Parent = MainFrame,
        BackgroundColor3 = Theme.Glass,
        BackgroundTransparency = 0.88,
        Position = UDim2.new(0, 200 * Scale, 0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        BorderSizePixel = 0,
        ZIndex = ZIndex.Sidebar + 2
    })
    
    -- Title
    Create("TextLabel", {
        Name = "Title",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20 * Scale, 0, 18 * Scale),
        Size = UDim2.new(1, -40 * Scale, 0, 24 * Scale),
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = Theme.Text,
        TextSize = 18 * Scale,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = ZIndex.SidebarContent
    })
    
    Create("TextLabel", {
        Name = "Version",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -55 * Scale, 0, 22 * Scale),
        Size = UDim2.new(0, 40 * Scale, 0, 16 * Scale),
        Font = Enum.Font.Gotham,
        Text = Version,
        TextColor3 = Theme.TextMuted,
        TextSize = 12 * Scale,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = ZIndex.SidebarContent
    })
    
    Create("TextLabel", {
        Name = "TabSection",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20 * Scale, 0, 60 * Scale),
        Size = UDim2.new(1, -40 * Scale, 0, 20 * Scale),
        Font = Enum.Font.Gotham,
        Text = "NAVIGATION",
        TextColor3 = Theme.TextMuted,
        TextSize = 10 * Scale,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = ZIndex.SidebarContent
    })
    
    -- Tab Container
    local TabContainer = Create("ScrollingFrame", {
        Name = "Tabs",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10 * Scale, 0, 85 * Scale),
        Size = UDim2.new(1, -20 * Scale, 1, -155 * Scale),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        ScrollBarImageTransparency = 0.5,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = ZIndex.SidebarContent,
        BorderSizePixel = 0
    }, {
        Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4 * Scale)}),
        Create("UIPadding", {PaddingRight = UDim.new(0, 5)})
    })
    
    -- User Profile
    local UserFrame = Create("Frame", {
        Name = "User",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10 * Scale, 1, -60 * Scale),
        Size = UDim2.new(1, -20 * Scale, 0, 50 * Scale),
        ZIndex = ZIndex.SidebarContent
    })
    
    Create("ImageLabel", {
        Name = "Avatar",
        Parent = UserFrame,
        BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 0.5,
        Position = UDim2.new(0, 5 * Scale, 0.5, 0),
        Size = UDim2.new(0, 40 * Scale, 0, 40 * Scale),
        AnchorPoint = Vector2.new(0, 0.5),
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. Player.UserId .. "&w=150&h=150",
        ZIndex = ZIndex.SidebarContent + 1
    }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)}), Create("UIStroke", {Color = Theme.CardBorder, Thickness = 1, Transparency = 0.5})})
    
    Create("TextLabel", {
        Name = "Name",
        Parent = UserFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 55 * Scale, 0, 8 * Scale),
        Size = UDim2.new(1, -65 * Scale, 0, 16 * Scale),
        Font = Enum.Font.GothamMedium,
        Text = Player.Name,
        TextColor3 = Theme.Text,
        TextSize = 13 * Scale,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = ZIndex.SidebarContent
    })
    
    Create("TextLabel", {
        Name = "Display",
        Parent = UserFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 55 * Scale, 0, 26 * Scale),
        Size = UDim2.new(1, -65 * Scale, 0, 14 * Scale),
        Font = Enum.Font.Gotham,
        Text = Player.DisplayName,
        TextColor3 = Theme.TextMuted,
        TextSize = 11 * Scale,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = ZIndex.SidebarContent
    })
    
    -- Content Area
    local ContentArea = Create("Frame", {
        Name = "Content",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 200 * Scale, 0, 0),
        Size = UDim2.new(1, -200 * Scale, 1, 0),
        ZIndex = ZIndex.Content
    })
    
    -- Top Bar
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Parent = ContentArea,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 50 * Scale),
        ZIndex = ZIndex.TopBar
    })
    
    Create("TextLabel", {
        Name = "Version",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20 * Scale, 0.5, 0),
        Size = UDim2.new(0, 100 * Scale, 0, 20 * Scale),
        AnchorPoint = Vector2.new(0, 0.5),
        Font = Enum.Font.Gotham,
        Text = Version,
        TextColor3 = Theme.TextMuted,
        TextSize = 12 * Scale,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = ZIndex.TopBar
    })
    
    -- Top Icons
    local TopIcons = Create("Frame", {
        Name = "Icons",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -20 * Scale, 0.5, 0),
        Size = UDim2.new(0, 100 * Scale, 0, 30 * Scale),
        AnchorPoint = Vector2.new(1, 0.5),
        ZIndex = ZIndex.TopBar
    }, {
        Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 10 * Scale)
        })
    })
    
    -- Minimize Button (Glass)
    local MinimizeBtn = Create("TextButton", {
        Name = "Minimize",
        Parent = TopIcons,
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.25,
        Size = UDim2.new(0, 16 * Scale, 0, 16 * Scale),
        Text = "",
        AutoButtonColor = false,
        ZIndex = ZIndex.TopBar
    }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
    
    MinimizeBtn.MouseEnter:Connect(function()
        Tween(MinimizeBtn, {Size = UDim2.new(0, 18 * Scale, 0, 18 * Scale), BackgroundTransparency = 0}, TweenPresets.Quick)
    end)
    MinimizeBtn.MouseLeave:Connect(function()
        Tween(MinimizeBtn, {Size = UDim2.new(0, 16 * Scale, 0, 16 * Scale), BackgroundTransparency = 0.25}, TweenPresets.Quick)
    end)
    
    -- Close Button (Glass)
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        Parent = TopIcons,
        BackgroundColor3 = Theme.Error,
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0, 16 * Scale, 0, 16 * Scale),
        Text = "",
        AutoButtonColor = false,
        ZIndex = ZIndex.TopBar
    }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
    
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, {Size = UDim2.new(0, 18 * Scale, 0, 18 * Scale), BackgroundTransparency = 0}, TweenPresets.Quick)
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, {Size = UDim2.new(0, 16 * Scale, 0, 16 * Scale), BackgroundTransparency = 0.5}, TweenPresets.Quick)
    end)
    
    -- Tab Content
    local TabContent = Create("Frame", {
        Name = "TabContent",
        Parent = ContentArea,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 50 * Scale),
        Size = UDim2.new(1, 0, 1, -50 * Scale),
        ZIndex = ZIndex.Content
    })
    
    -- Dragging
    local Dragging, DragStart, StartPos = false, nil, nil
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = MainContainer.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = input.Position - DragStart
            MainContainer.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
    
    -- Window animations
    local function ToggleWindow()
        Window.Open = not Window.Open
        if Window.Open then
            MainContainer.Visible = true
            MainContainer.Size = UDim2.new(0, 0, 0, 0)
            Tween(MainContainer, {Size = UDim2.new(0, 900 * Scale, 0, 600 * Scale)}, TweenPresets.Bounce)
        else
            Tween(MainContainer, {Size = UDim2.new(0, 900 * Scale, 0, 0)}, TweenPresets.Smooth)
            task.wait(0.35)
            MainContainer.Visible = false
        end
    end
    
    local function CloseWindowAnim()
        Tween(MainContainer, {Size = UDim2.new(0, 0, 0, 0)}, TweenPresets.Smooth)
        task.wait(0.35)
        ScreenGui:Destroy()
    end
    
    CloseBtn.MouseButton1Click:Connect(CloseWindowAnim)
    MinimizeBtn.MouseButton1Click:Connect(ToggleWindow)
    MobileButton.MouseButton1Click:Connect(ToggleWindow)
    
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == MinimizeKey then ToggleWindow() end
    end)
    
    -- Opening animation
    MainContainer.Size = UDim2.new(0, 0, 0, 0)
    task.wait(0.05)
    Tween(MainContainer, {Size = UDim2.new(0, 900 * Scale, 0, 600 * Scale)}, TweenPresets.Bounce)
    
    -- ═══════════════════════════════════════════════════════════════
    -- TAB CREATION
    -- ═══════════════════════════════════════════════════════════════
    function Window:CreateTab(options)
        options = options or {}
        local TabName = options.Name or "Tab"
        local TabIcon = options.Icon or "rbxassetid://7072706796"
        
        local Tab = {Name = TabName, Sections = {Left = {}, Right = {}}}
        
        local TabButton = Create("TextButton", {
            Name = TabName,
            Parent = TabContainer,
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 34 * Scale),
            Text = "",
            AutoButtonColor = false,
            ZIndex = ZIndex.SidebarContent + 1
        }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
        
        local TabIconImg = Create("ImageLabel", {
            Name = "Icon",
            Parent = TabButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12 * Scale, 0.5, 0),
            Size = UDim2.new(0, 16 * Scale, 0, 16 * Scale),
            AnchorPoint = Vector2.new(0, 0.5),
            Image = TabIcon,
            ImageColor3 = Theme.TextMuted,
            ZIndex = ZIndex.SidebarContent + 2
        })
        
        local TabLabel = Create("TextLabel", {
            Name = "Label",
            Parent = TabButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 36 * Scale, 0, 0),
            Size = UDim2.new(1, -46 * Scale, 1, 0),
            Font = Enum.Font.GothamMedium,
            Text = TabName,
            TextColor3 = Theme.TextMuted,
            TextSize = 12 * Scale,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = ZIndex.SidebarContent + 2
        })
        
        local TabPage = Create("Frame", {
            Name = TabName,
            Parent = TabContent,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ZIndex = ZIndex.Content
        })
        
        local LeftColumn = Create("ScrollingFrame", {
            Name = "Left",
            Parent = TabPage,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15 * Scale, 0, 0),
            Size = UDim2.new(0.5, -22 * Scale, 1, -15 * Scale),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Accent,
            ScrollBarImageTransparency = 0.5,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ZIndex = ZIndex.Content,
            BorderSizePixel = 0
        }, {
            Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10 * Scale)}),
            Create("UIPadding", {PaddingRight = UDim.new(0, 5), PaddingBottom = UDim.new(0, 60 * Scale)})
        })
        
        local RightColumn = Create("ScrollingFrame", {
            Name = "Right",
            Parent = TabPage,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 7 * Scale, 0, 0),
            Size = UDim2.new(0.5, -22 * Scale, 1, -15 * Scale),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Accent,
            ScrollBarImageTransparency = 0.5,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ZIndex = ZIndex.Content,
            BorderSizePixel = 0
        }, {
            Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10 * Scale)}),
            Create("UIPadding", {PaddingRight = UDim.new(0, 5), PaddingBottom = UDim.new(0, 60 * Scale)})
        })
        
        TabButton.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 0.8}, TweenPresets.Quick)
                Tween(TabLabel, {TextColor3 = Theme.Text}, TweenPresets.Quick)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 1}, TweenPresets.Quick)
                Tween(TabLabel, {TextColor3 = Theme.TextMuted}, TweenPresets.Quick)
            end
        end)
        
        local function SelectTab()
            for _, t in pairs(Window.Tabs) do
                Tween(t.Button, {BackgroundTransparency = 1}, TweenPresets.Normal)
                Tween(t.Label, {TextColor3 = Theme.TextMuted}, TweenPresets.Normal)
                Tween(t.Icon, {ImageColor3 = Theme.TextMuted}, TweenPresets.Normal)
                t.Page.Visible = false
            end
            Tween(TabButton, {BackgroundTransparency = 0.35}, TweenPresets.Normal)
            Tween(TabLabel, {TextColor3 = Theme.Text}, TweenPresets.Normal)
            Tween(TabIconImg, {ImageColor3 = Theme.Accent}, TweenPresets.Normal)
            TabPage.Visible = true
            Window.ActiveTab = Tab
        end
        
        TabButton.MouseButton1Click:Connect(function()
            Ripple(TabButton, Mouse.X, Mouse.Y)
            SelectTab()
        end)
        
        Tab.Button = TabButton
        Tab.Label = TabLabel
        Tab.Icon = TabIconImg
        Tab.Page = TabPage
        Tab.LeftColumn = LeftColumn
        Tab.RightColumn = RightColumn
        
        -- ═══════════════════════════════════════════════════════════
        -- SECTION CREATION (Glass Cards)
        -- ═══════════════════════════════════════════════════════════
        function Tab:CreateSection(options)
            options = options or {}
            local SectionName = options.Name or "Section"
            local Side = options.Side or "Left"
            
            local Section = {}
            local Column = Side == "Left" and LeftColumn or RightColumn
            
            -- Glass Card
            local SectionFrame = Create("Frame", {
                Name = SectionName,
                Parent = Column,
                BackgroundColor3 = Theme.Card,
                BackgroundTransparency = Theme.CardTransparency or 0.25,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = ZIndex.Cards
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
                Create("UIStroke", {Color = Theme.CardBorder, Thickness = 1, Transparency = 0.6}),
                Create("UIPadding", {
                    PaddingTop = UDim.new(0, 14 * Scale),
                    PaddingBottom = UDim.new(0, 14 * Scale),
                    PaddingLeft = UDim.new(0, 14 * Scale),
                    PaddingRight = UDim.new(0, 14 * Scale)
                }),
                Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 0)})
            })
            
            -- Section Header
            Create("TextLabel", {
                Name = "Header",
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20 * Scale),
                Font = Enum.Font.GothamBold,
                Text = SectionName,
                TextColor3 = Theme.Text,
                TextSize = 13 * Scale,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = 0,
                ZIndex = ZIndex.Cards + 1
            })
            
            -- Spacer
            Create("Frame", {
                Name = "Spacer",
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 10 * Scale),
                LayoutOrder = 1,
                ZIndex = ZIndex.Cards
            })
            
            local Content = Create("Frame", {
                Name = "Content",
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = 2,
                ZIndex = ZIndex.Cards + 1
            }, {Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8 * Scale)})})
            
            Section.Frame = SectionFrame
            Section.Content = Content
            
            -- LABEL
            function Section:CreateLabel(opt)
                opt = opt or {}
                local Text = opt.Text or "Label"
                local LabelFrame = Create("Frame", {Name = "Label", Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16 * Scale), ZIndex = ZIndex.Elements})
                local Label = Create("TextLabel", {Name = "Text", Parent = LabelFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.Gotham, Text = Text, TextColor3 = Theme.TextMuted, TextSize = 11 * Scale, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = ZIndex.Elements})
                local obj = {Frame = LabelFrame, Label = Label}
                function obj:Set(t) Label.Text = t end
                return obj
            end
            
            -- TOGGLE (Glass)
            function Section:CreateToggle(opt)
                opt = opt or {}
                local Name = opt.Name or "Toggle"
                local Default = opt.Default or false
                local Callback = opt.Callback or function() end
                local Flag = opt.Flag
                
                local Frame = Create("Frame", {Name = Name, Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 28 * Scale), ZIndex = ZIndex.Elements})
                Create("TextLabel", {Parent = Frame, BackgroundTransparency = 1, Size = UDim2.new(1, -55 * Scale, 1, 0), Font = Enum.Font.Gotham, Text = Name, TextColor3 = Theme.Text, TextSize = 12 * Scale, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = ZIndex.Elements})
                
                local Button = Create("TextButton", {
                    Name = "Toggle", Parent = Frame,
                    BackgroundColor3 = Default and Theme.Toggle or Theme.ToggleOff,
                    BackgroundTransparency = 0.15,
                    Position = UDim2.new(1, -46 * Scale, 0.5, 0),
                    Size = UDim2.new(0, 46 * Scale, 0, 22 * Scale),
                    AnchorPoint = Vector2.new(0, 0.5), Text = "", AutoButtonColor = false,
                    ZIndex = ZIndex.Elements + 1
                }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                
                local Circle = Create("Frame", {
                    Name = "Circle", Parent = Button,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 0.1,
                    Position = Default and UDim2.new(1, -20 * Scale, 0.5, 0) or UDim2.new(0, 4 * Scale, 0.5, 0),
                    Size = UDim2.new(0, 16 * Scale, 0, 16 * Scale),
                    AnchorPoint = Vector2.new(0, 0.5), ZIndex = ZIndex.Elements + 2
                }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                
                local Value = Default
                local Toggle = {Type = "Toggle", Value = Value, Frame = Frame}
                
                function Toggle:Set(v, skip)
                    Value = v
                    Toggle.Value = v
                    Tween(Button, {BackgroundColor3 = v and Theme.Toggle or Theme.ToggleOff}, TweenPresets.Normal)
                    Tween(Circle, {Position = v and UDim2.new(1, -20 * Scale, 0.5, 0) or UDim2.new(0, 4 * Scale, 0.5, 0)}, TweenPresets.Bounce)
                    if not skip then Callback(v) end
                end
                
                Button.MouseEnter:Connect(function() Tween(Circle, {Size = UDim2.new(0, 18 * Scale, 0, 18 * Scale), BackgroundTransparency = 0}, TweenPresets.Quick) end)
                Button.MouseLeave:Connect(function() Tween(Circle, {Size = UDim2.new(0, 16 * Scale, 0, 16 * Scale), BackgroundTransparency = 0.1}, TweenPresets.Quick) end)
                Button.MouseButton1Click:Connect(function() Toggle:Set(not Value) end)
                
                if Flag then Window.Config:RegisterElement(Flag, Toggle) end
                return Toggle
            end
            
            -- SLIDER (Glass)
            function Section:CreateSlider(opt)
                opt = opt or {}
                local Name = opt.Name or "Slider"
                local Min = opt.Min or 0
                local Max = opt.Max or 100
                local Default = opt.Default or Min
                local Increment = opt.Increment or 1
                local Callback = opt.Callback or function() end
                local Flag = opt.Flag
                
                local Frame = Create("Frame", {Name = Name, Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 42 * Scale), ZIndex = ZIndex.Elements})
                Create("TextLabel", {Parent = Frame, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, -60 * Scale, 0, 18 * Scale), Font = Enum.Font.Gotham, Text = Name, TextColor3 = Theme.Text, TextSize = 12 * Scale, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = ZIndex.Elements})
                local ValueLabel = Create("TextLabel", {Parent = Frame, BackgroundTransparency = 1, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 55 * Scale, 0, 18 * Scale), AnchorPoint = Vector2.new(1, 0), Font = Enum.Font.GothamMedium, Text = tostring(Default), TextColor3 = Theme.Accent, TextSize = 12 * Scale, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = ZIndex.Elements})
                
                local Bg = Create("Frame", {Parent = Frame, BackgroundColor3 = Theme.SliderBg, BackgroundTransparency = 0.4, Position = UDim2.new(0, 0, 0, 26 * Scale), Size = UDim2.new(1, 0, 0, 6 * Scale), ZIndex = ZIndex.Elements}, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                local Fill = Create("Frame", {Parent = Bg, BackgroundColor3 = Theme.SliderFill, BackgroundTransparency = 0.15, Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0), ZIndex = ZIndex.Elements + 1}, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                local Knob = Create("Frame", {Parent = Bg, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.1, Position = UDim2.new((Default - Min) / (Max - Min), 0, 0.5, 0), Size = UDim2.new(0, 14 * Scale, 0, 14 * Scale), AnchorPoint = Vector2.new(0.5, 0.5), ZIndex = ZIndex.Elements + 2}, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                
                local Value = Default
                local Sliding = false
                local Slider = {Type = "Slider", Value = Value, Frame = Frame}
                
                function Slider:Set(v, skip)
                    v = math.clamp(v, Min, Max)
                    v = math.floor(v / Increment + 0.5) * Increment
                    Value = v
                    Slider.Value = v
                    local p = (v - Min) / (Max - Min)
                    Tween(Fill, {Size = UDim2.new(p, 0, 1, 0)}, TweenPresets.Instant)
                    Tween(Knob, {Position = UDim2.new(p, 0, 0.5, 0)}, TweenPresets.Instant)
                    ValueLabel.Text = tostring(v)
                    if not skip then Callback(v) end
                end
                
                Bg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Sliding = true
                        Tween(Knob, {Size = UDim2.new(0, 18 * Scale, 0, 18 * Scale), BackgroundTransparency = 0}, TweenPresets.Quick)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and Sliding then
                        Sliding = false
                        Tween(Knob, {Size = UDim2.new(0, 14 * Scale, 0, 14 * Scale), BackgroundTransparency = 0.1}, TweenPresets.Quick)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if Sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local p = math.clamp((input.Position.X - Bg.AbsolutePosition.X) / Bg.AbsoluteSize.X, 0, 1)
                        Slider:Set(Min + (Max - Min) * p)
                    end
                end)
                
                if Flag then Window.Config:RegisterElement(Flag, Slider) end
                return Slider
            end
            
            -- DROPDOWN (Fixed Glass)
            function Section:CreateDropdown(opt)
                opt = opt or {}
                local Name = opt.Name or "Dropdown"
                local Items = opt.Items or {}
                local Default = opt.Default or (Items[1] or "")
                local Callback = opt.Callback or function() end
                local Flag = opt.Flag
                
                local Frame = Create("Frame", {Name = Name, Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 52 * Scale), ZIndex = ZIndex.Elements})
                Create("TextLabel", {Parent = Frame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16 * Scale), Font = Enum.Font.GothamMedium, Text = Name, TextColor3 = Theme.Text, TextSize = 12 * Scale, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = ZIndex.Elements})
                
                local Button = Create("TextButton", {
                    Parent = Frame, BackgroundColor3 = Theme.Input,
                    BackgroundTransparency = Theme.InputTransparency or 0.4,
                    Position = UDim2.new(0, 0, 0, 20 * Scale), Size = UDim2.new(1, 0, 0, 30 * Scale),
                    Text = "", AutoButtonColor = false, ZIndex = ZIndex.Elements + 1
                }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)}), Create("UIStroke", {Color = Theme.InputBorder, Thickness = 1, Transparency = 0.6})})
                
                local Selected = Create("TextLabel", {Parent = Button, BackgroundTransparency = 1, Position = UDim2.new(0, 10 * Scale, 0, 0), Size = UDim2.new(1, -35 * Scale, 1, 0), Font = Enum.Font.Gotham, Text = Default, TextColor3 = Theme.Text, TextSize = 11 * Scale, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = ZIndex.Elements + 2})
                local Arrow = Create("TextLabel", {Parent = Button, BackgroundTransparency = 1, Position = UDim2.new(1, -22 * Scale, 0.5, 0), Size = UDim2.new(0, 12 * Scale, 0, 12 * Scale), AnchorPoint = Vector2.new(0, 0.5), Font = Enum.Font.GothamBold, Text = "▼", TextColor3 = Theme.TextMuted, TextSize = 8 * Scale, ZIndex = ZIndex.Elements + 2})
                
                local Value = Default
                local Open = false
                local Dropdown = {Type = "Dropdown", Value = Value, Frame = Frame}
                
                -- Dropdown list (separate container in ScreenGui)
                local ListContainer = Create("Frame", {
                    Parent = ScreenGui,
                    BackgroundTransparency = 1,
                    Visible = false,
                    ZIndex = ZIndex.Dropdown
                })
                
                local List = Create("Frame", {
                    Parent = ListContainer,
                    BackgroundColor3 = Theme.Card,
                    BackgroundTransparency = 0.08,
                    Size = UDim2.new(1, 0, 1, 0),
                    ClipsDescendants = true,
                    ZIndex = ZIndex.Dropdown
                }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)}), Create("UIStroke", {Color = Theme.CardBorder, Thickness = 1, Transparency = 0.4})})
                
                local Scroll = Create("ScrollingFrame", {
                    Name = "Scroll",
                    Parent = List,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarThickness = 2,
                    ScrollBarImageColor3 = Theme.Accent,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    ZIndex = ZIndex.DropdownItems
                }, {
                    Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)}),
                    Create("UIPadding", {PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4)})
                })
                
                local function GetListHeight()
                    return math.min(#Items * (26 * Scale + 2) + 10, 140 * Scale)
                end
                
                local function UpdatePos()
                    if not Button or not Button.Parent then return end
                    local bp = Button.AbsolutePosition
                    local bs = Button.AbsoluteSize
                    local height = GetListHeight()
                    ListContainer.Position = UDim2.new(0, bp.X, 0, bp.Y + bs.Y + 4)
                    ListContainer.Size = UDim2.new(0, bs.X, 0, height)
                end
                
                local function CreateOption(item)
                    local Opt = Create("TextButton", {
                        Name = item, Parent = Scroll, BackgroundColor3 = Theme.CardHover,
                        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 26 * Scale),
                        Text = "", AutoButtonColor = false, ZIndex = ZIndex.DropdownItems
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                        Create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 0), Size = UDim2.new(1, -16, 1, 0), Font = Enum.Font.Gotham, Text = item, TextColor3 = Theme.Text, TextSize = 11 * Scale, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = ZIndex.DropdownItems + 1})
                    })
                    Opt.MouseEnter:Connect(function() Tween(Opt, {BackgroundTransparency = 0.3}, TweenPresets.Quick) end)
                    Opt.MouseLeave:Connect(function() Tween(Opt, {BackgroundTransparency = 1}, TweenPresets.Quick) end)
                    Opt.MouseButton1Click:Connect(function()
                        Dropdown:Set(item)
                        Dropdown:CloseDropdown()
                    end)
                end
                
                function Dropdown:CloseDropdown()
                    if not Open then return end
                    Open = false
                    if Window.OpenDropdown == Dropdown then Window.OpenDropdown = nil end
                    Tween(Arrow, {Rotation = 0, TextColor3 = Theme.TextMuted}, TweenPresets.Normal)
                    Tween(Button:FindFirstChild("UIStroke"), {Color = Theme.InputBorder}, TweenPresets.Quick)
                    Tween(Button, {BackgroundTransparency = Theme.InputTransparency or 0.4}, TweenPresets.Quick)
                    ListContainer.Visible = false
                end
                
                function Dropdown:OpenDropdown()
                    if Window.OpenDropdown and Window.OpenDropdown ~= Dropdown then
                        Window.OpenDropdown:CloseDropdown()
                    end
                    Open = true
                    Window.OpenDropdown = Dropdown
                    UpdatePos()
                    ListContainer.Visible = true
                    Tween(Arrow, {Rotation = 180, TextColor3 = Theme.Accent}, TweenPresets.Normal)
                    Tween(Button:FindFirstChild("UIStroke"), {Color = Theme.Accent}, TweenPresets.Quick)
                    Tween(Button, {BackgroundTransparency = 0.15}, TweenPresets.Quick)
                end
                
                for _, item in ipairs(Items) do CreateOption(item) end
                
                function Dropdown:Set(v, skip)
                    Value = v
                    Dropdown.Value = v
                    Selected.Text = v
                    if not skip then Callback(v) end
                end
                
                function Dropdown:Refresh(newItems)
                    for _, c in pairs(Scroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                    Items = newItems
                    for _, item in ipairs(Items) do CreateOption(item) end
                end
                
                Button.MouseEnter:Connect(function()
                    if not Open then
                        Tween(Button:FindFirstChild("UIStroke"), {Color = Theme.TextMuted}, TweenPresets.Quick)
                        Tween(Arrow, {TextColor3 = Theme.Text}, TweenPresets.Quick)
                        Tween(Button, {BackgroundTransparency = 0.2}, TweenPresets.Quick)
                    end
                end)
                Button.MouseLeave:Connect(function()
                    if not Open then
                        Tween(Button:FindFirstChild("UIStroke"), {Color = Theme.InputBorder}, TweenPresets.Quick)
                        Tween(Arrow, {TextColor3 = Theme.TextMuted}, TweenPresets.Quick)
                        Tween(Button, {BackgroundTransparency = Theme.InputTransparency or 0.4}, TweenPresets.Quick)
                    end
                end)
                
                Button.MouseButton1Click:Connect(function()
                    if Open then Dropdown:CloseDropdown() else Dropdown:OpenDropdown() end
                end)
                
                -- Close when clicking outside
                local clickConnection
                clickConnection = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and Open then
                        local mousePos = UserInputService:GetMouseLocation()
                        local listPos = ListContainer.AbsolutePosition
                        local listSize = ListContainer.AbsoluteSize
                        local btnPos = Button.AbsolutePosition
                        local btnSize = Button.AbsoluteSize
                        
                        local inList = mousePos.X >= listPos.X and mousePos.X <= listPos.X + listSize.X and
                                       mousePos.Y >= listPos.Y and mousePos.Y <= listPos.Y + listSize.Y
                        local inButton = mousePos.X >= btnPos.X and mousePos.X <= btnPos.X + btnSize.X and
                                         mousePos.Y >= btnPos.Y and mousePos.Y <= btnPos.Y + btnSize.Y
                        
                        if not inList and not inButton then
                            task.defer(function() Dropdown:CloseDropdown() end)
                        end
                    end
                end)
                
                Column:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
                    if Open then UpdatePos() end
                end)
                MainContainer:GetPropertyChangedSignal("Position"):Connect(function()
                    if Open then UpdatePos() end
                end)
                
                Frame.Destroying:Connect(function()
                    if clickConnection then clickConnection:Disconnect() end
                    if Window.OpenDropdown == Dropdown then Window.OpenDropdown = nil end
                    ListContainer:Destroy()
                end)
                
                if Flag then Window.Config:RegisterElement(Flag, Dropdown) end
                return Dropdown
            end
            
            -- BUTTON (Glass)
            function Section:CreateButton(opt)
                opt = opt or {}
                local Name = opt.Name or "Button"
                local Callback = opt.Callback or function() end
                
                local Frame = Create("Frame", {Name = Name, Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32 * Scale), ZIndex = ZIndex.Elements, ClipsDescendants = true})
                local Btn = Create("TextButton", {
                    Parent = Frame, BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.2,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.GothamMedium, Text = Name, TextColor3 = Color3.new(1, 1, 1),
                    TextSize = 12 * Scale, AutoButtonColor = false, ZIndex = ZIndex.Elements + 1, ClipsDescendants = true
                }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
                
                Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundTransparency = 0}, TweenPresets.Quick) end)
                Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundTransparency = 0.2}, TweenPresets.Quick) end)
                Btn.MouseButton1Click:Connect(function()
                    Ripple(Btn, Mouse.X, Mouse.Y)
                    Tween(Btn, {BackgroundColor3 = Theme.AccentDark}, TweenPresets.Quick)
                    task.wait(0.1)
                    Tween(Btn, {BackgroundColor3 = Theme.Accent}, TweenPresets.Quick)
                    Callback()
                end)
                return {Frame = Frame, Button = Btn}
            end
            
            -- INPUT (Glass)
            function Section:CreateInput(opt)
                opt = opt or {}
                local Name = opt.Name or "Input"
                local Placeholder = opt.Placeholder or "Enter text..."
                local Default = opt.Default or ""
                local Callback = opt.Callback or function() end
                local Flag = opt.Flag
                
                local Frame = Create("Frame", {Name = Name, Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 52 * Scale), ZIndex = ZIndex.Elements})
                Create("TextLabel", {Parent = Frame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16 * Scale), Font = Enum.Font.GothamMedium, Text = Name, TextColor3 = Theme.Text, TextSize = 12 * Scale, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = ZIndex.Elements})
                
                local Box = Create("TextBox", {
                    Parent = Frame, BackgroundColor3 = Theme.Input,
                    BackgroundTransparency = Theme.InputTransparency or 0.4,
                    Position = UDim2.new(0, 0, 0, 20 * Scale), Size = UDim2.new(1, 0, 0, 30 * Scale),
                    Font = Enum.Font.Gotham, PlaceholderText = Placeholder, PlaceholderColor3 = Theme.TextMuted,
                    Text = Default, TextColor3 = Theme.Text, TextSize = 11 * Scale, ClearTextOnFocus = false, ZIndex = ZIndex.Elements + 1
                }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)}), Create("UIStroke", {Color = Theme.InputBorder, Thickness = 1, Transparency = 0.6}), Create("UIPadding", {PaddingLeft = UDim.new(0, 10 * Scale), PaddingRight = UDim.new(0, 10 * Scale)})})
                
                local Value = Default
                local Input = {Type = "Input", Value = Value, Frame = Frame}
                
                function Input:Set(v, skip)
                    Value = v
                    Input.Value = v
                    Box.Text = v
                    if not skip then Callback(v) end
                end
                
                Box.Focused:Connect(function()
                    Tween(Box:FindFirstChild("UIStroke"), {Color = Theme.InputFocus, Transparency = 0}, TweenPresets.Quick)
                    Tween(Box, {BackgroundTransparency = 0.15}, TweenPresets.Quick)
                end)
                Box.FocusLost:Connect(function()
                    Tween(Box:FindFirstChild("UIStroke"), {Color = Theme.InputBorder, Transparency = 0.6}, TweenPresets.Quick)
                    Tween(Box, {BackgroundTransparency = Theme.InputTransparency or 0.4}, TweenPresets.Quick)
                    Value = Box.Text
                    Input.Value = Value
                    Callback(Value)
                end)
                Box.MouseEnter:Connect(function()
                    if not Box:IsFocused() then
                        Tween(Box:FindFirstChild("UIStroke"), {Color = Theme.TextMuted}, TweenPresets.Quick)
                        Tween(Box, {BackgroundTransparency = 0.2}, TweenPresets.Quick)
                    end
                end)
                Box.MouseLeave:Connect(function()
                    if not Box:IsFocused() then
                        Tween(Box:FindFirstChild("UIStroke"), {Color = Theme.InputBorder}, TweenPresets.Quick)
                        Tween(Box, {BackgroundTransparency = Theme.InputTransparency or 0.4}, TweenPresets.Quick)
                    end
                end)
                
                if Flag then Window.Config:RegisterElement(Flag, Input) end
                return Input
            end
            
            -- KEYBIND (Glass)
            function Section:CreateKeybind(opt)
                opt = opt or {}
                local Name = opt.Name or "Keybind"
                local Default = opt.Default or Enum.KeyCode.Unknown
                local Callback = opt.Callback or function() end
                local Flag = opt.Flag
                
                local Frame = Create("Frame", {Name = Name, Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 28 * Scale), ZIndex = ZIndex.Elements})
                Create("TextLabel", {Parent = Frame, BackgroundTransparency = 1, Size = UDim2.new(1, -70 * Scale, 1, 0), Font = Enum.Font.Gotham, Text = Name, TextColor3 = Theme.Text, TextSize = 12 * Scale, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = ZIndex.Elements})
                
                local Btn = Create("TextButton", {
                    Parent = Frame, BackgroundColor3 = Theme.Input,
                    BackgroundTransparency = Theme.InputTransparency or 0.4,
                    Position = UDim2.new(1, -65 * Scale, 0.5, 0), Size = UDim2.new(0, 65 * Scale, 0, 24 * Scale),
                    AnchorPoint = Vector2.new(0, 0.5), Font = Enum.Font.GothamMedium, Text = Default.Name or "None",
                    TextColor3 = Theme.Text, TextSize = 10 * Scale, AutoButtonColor = false, ZIndex = ZIndex.Elements + 1
                }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)}), Create("UIStroke", {Color = Theme.InputBorder, Thickness = 1, Transparency = 0.6})})
                
                local Value = Default
                local Listening = false
                local Keybind = {Type = "Keybind", Value = Value, Frame = Frame}
                
                function Keybind:Set(k)
                    Value = k
                    Keybind.Value = k
                    Btn.Text = k.Name or "None"
                end
                
                Btn.MouseEnter:Connect(function()
                    Tween(Btn:FindFirstChild("UIStroke"), {Color = Theme.TextMuted}, TweenPresets.Quick)
                    Tween(Btn, {BackgroundTransparency = 0.2}, TweenPresets.Quick)
                end)
                Btn.MouseLeave:Connect(function()
                    if not Listening then
                        Tween(Btn:FindFirstChild("UIStroke"), {Color = Theme.InputBorder}, TweenPresets.Quick)
                        Tween(Btn, {BackgroundTransparency = Theme.InputTransparency or 0.4}, TweenPresets.Quick)
                    end
                end)
                Btn.MouseButton1Click:Connect(function()
                    Listening = true
                    Btn.Text = "..."
                    Tween(Btn:FindFirstChild("UIStroke"), {Color = Theme.Accent, Transparency = 0}, TweenPresets.Quick)
                    Tween(Btn, {BackgroundTransparency = 0.15}, TweenPresets.Quick)
                end)
                
                UserInputService.InputBegan:Connect(function(input, processed)
                    if Listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        Listening = false
                        Keybind:Set(input.KeyCode)
                        Tween(Btn:FindFirstChild("UIStroke"), {Color = Theme.InputBorder, Transparency = 0.6}, TweenPresets.Quick)
                        Tween(Btn, {BackgroundTransparency = Theme.InputTransparency or 0.4}, TweenPresets.Quick)
                    elseif input.KeyCode == Value and not processed then
                        Callback(Value)
                    end
                end)
                
                if Flag then Window.Config:RegisterElement(Flag, Keybind) end
                return Keybind
            end
            
            table.insert(Tab.Sections[Side], Section)
            return Section
        end
        
        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 or (DefaultTab and TabName == DefaultTab) then
            task.wait(0.1)
            TabButton.BackgroundTransparency = 0.35
            TabLabel.TextColor3 = Theme.Text
            TabIconImg.ImageColor3 = Theme.Accent
            TabPage.Visible = true
            Window.ActiveTab = Tab
        end
        return Tab
    end
    
    -- Config Tab
    function Window:CreateConfigTab()
        local ConfigTab = Window:CreateTab({Name = "Configs", Icon = "rbxassetid://7072719587"})
        local ConfigSection = ConfigTab:CreateSection({Name = "Configuration", Side = "Left"})
        local CurrentConfigs = Window.Config:GetConfigs()
        
        local ConfigNameInput = ConfigSection:CreateInput({Name = "Config Name", Placeholder = "Enter config name...", Callback = function() end})
        local ConfigDropdown = ConfigSection:CreateDropdown({Name = "Config List", Items = CurrentConfigs, Default = CurrentConfigs[1] or "", Callback = function() end})
        
        ConfigSection:CreateButton({Name = "Save Config", Callback = function()
            local name = ConfigNameInput.Value
            if name and name ~= "" then
                Window.Config:SaveConfig(name)
                ConfigDropdown:Refresh(Window.Config:GetConfigs())
            end
        end})
        
        ConfigSection:CreateButton({Name = "Load Config", Callback = function()
            local name = ConfigDropdown.Value
            if name and name ~= "" then Window.Config:LoadConfig(name) end
        end})
        
        ConfigSection:CreateButton({Name = "Delete Config", Callback = function()
            local name = ConfigDropdown.Value
            if name and name ~= "" then
                Window.Config:DeleteConfig(name)
                ConfigDropdown:Refresh(Window.Config:GetConfigs())
            end
        end})
        
        ConfigSection:CreateButton({Name = "Refresh Configs", Callback = function()
            ConfigDropdown:Refresh(Window.Config:GetConfigs())
        end})
        
        return ConfigTab
    end
    
    function Window:SetTheme(name)
        if Themes[name] then
            Theme = Themes[name]
            Window.Theme = Theme
            Window.ThemeName = name
        end
    end
    
    function Window:GetThemes()
        local t = {}
        for name in pairs(Themes) do table.insert(t, name) end
        return t
    end
    
    function Window:Toggle() ToggleWindow() end
    function Window:Destroy() CloseWindowAnim() end
    
    return Window
end

return AstraLib

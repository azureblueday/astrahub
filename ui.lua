--[[
    AstraLib v3 - Roblox UI Library
    Based on Astra Hub Design
    
    Features:
    - Multiple themes support
    - Mobile scaling & toggle button
    - Config system (save/load/delete)
    - Toggles, Sliders, Dropdowns, Buttons, Labels, Keybinds
    
    Usage:
    local AstraLib = loadstring(game:HttpGet("YOUR_URL"))()
    local Window = AstraLib:CreateWindow({
        Title = "My Hub",
        Version = "v1.0",
        Theme = "Dark",
        ConfigFolder = "MyHub"
    })
    local Tab = Window:CreateTab({Name = "Main", Icon = "rbxassetid://0"})
    local Section = Tab:CreateSection({Name = "Features", Side = "Left"})
    Section:CreateToggle({Name = "Toggle", Default = false, Callback = function(v) end})
]]

local AstraLib = {}
AstraLib.__index = AstraLib

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Utility Functions
local function Create(instanceType, properties, children)
    local instance = Instance.new(instanceType)
    for prop, value in pairs(properties or {}) do
        instance[prop] = value
    end
    for _, child in pairs(children or {}) do
        child.Parent = instance
    end
    return instance
end

local function Tween(instance, properties, duration, style, direction)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
        properties
    )
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

-- Themes
local Themes = {
    Dark = {
        Name = "Dark",
        Background = Color3.fromRGB(10, 14, 26),
        Sidebar = Color3.fromRGB(15, 21, 37),
        Card = Color3.fromRGB(20, 28, 47),
        CardBorder = Color3.fromRGB(30, 42, 69),
        Text = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(107, 122, 153),
        Accent = Color3.fromRGB(59, 130, 246),
        AccentHover = Color3.fromRGB(37, 99, 235),
        Toggle = Color3.fromRGB(59, 130, 246),
        ToggleOff = Color3.fromRGB(30, 42, 69),
        SliderFill = Color3.fromRGB(59, 130, 246),
        SliderBg = Color3.fromRGB(30, 42, 69),
        Input = Color3.fromRGB(26, 37, 64),
        InputBorder = Color3.fromRGB(42, 58, 90),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
    Midnight = {
        Name = "Midnight",
        Background = Color3.fromRGB(13, 13, 26),
        Sidebar = Color3.fromRGB(18, 18, 31),
        Card = Color3.fromRGB(26, 26, 46),
        CardBorder = Color3.fromRGB(42, 42, 74),
        Text = Color3.fromRGB(224, 224, 255),
        TextMuted = Color3.fromRGB(112, 112, 160),
        Accent = Color3.fromRGB(99, 102, 241),
        AccentHover = Color3.fromRGB(79, 70, 229),
        Toggle = Color3.fromRGB(99, 102, 241),
        ToggleOff = Color3.fromRGB(42, 42, 74),
        SliderFill = Color3.fromRGB(99, 102, 241),
        SliderBg = Color3.fromRGB(42, 42, 74),
        Input = Color3.fromRGB(31, 31, 53),
        InputBorder = Color3.fromRGB(58, 58, 90),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
    Ocean = {
        Name = "Ocean",
        Background = Color3.fromRGB(10, 22, 40),
        Sidebar = Color3.fromRGB(13, 31, 53),
        Card = Color3.fromRGB(18, 42, 74),
        CardBorder = Color3.fromRGB(26, 58, 95),
        Text = Color3.fromRGB(224, 240, 255),
        TextMuted = Color3.fromRGB(96, 144, 176),
        Accent = Color3.fromRGB(6, 182, 212),
        AccentHover = Color3.fromRGB(8, 145, 178),
        Toggle = Color3.fromRGB(6, 182, 212),
        ToggleOff = Color3.fromRGB(26, 58, 95),
        SliderFill = Color3.fromRGB(6, 182, 212),
        SliderBg = Color3.fromRGB(26, 58, 95),
        Input = Color3.fromRGB(15, 37, 64),
        InputBorder = Color3.fromRGB(26, 64, 96),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
    Purple = {
        Name = "Purple",
        Background = Color3.fromRGB(18, 8, 31),
        Sidebar = Color3.fromRGB(26, 15, 46),
        Card = Color3.fromRGB(34, 21, 64),
        CardBorder = Color3.fromRGB(58, 32, 96),
        Text = Color3.fromRGB(240, 224, 255),
        TextMuted = Color3.fromRGB(144, 112, 176),
        Accent = Color3.fromRGB(168, 85, 247),
        AccentHover = Color3.fromRGB(147, 51, 234),
        Toggle = Color3.fromRGB(168, 85, 247),
        ToggleOff = Color3.fromRGB(58, 32, 96),
        SliderFill = Color3.fromRGB(168, 85, 247),
        SliderBg = Color3.fromRGB(58, 32, 96),
        Input = Color3.fromRGB(31, 16, 53),
        InputBorder = Color3.fromRGB(74, 32, 112),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
    Emerald = {
        Name = "Emerald",
        Background = Color3.fromRGB(6, 18, 16),
        Sidebar = Color3.fromRGB(10, 26, 24),
        Card = Color3.fromRGB(16, 37, 32),
        CardBorder = Color3.fromRGB(26, 58, 53),
        Text = Color3.fromRGB(224, 255, 248),
        TextMuted = Color3.fromRGB(96, 160, 144),
        Accent = Color3.fromRGB(16, 185, 129),
        AccentHover = Color3.fromRGB(5, 150, 105),
        Toggle = Color3.fromRGB(16, 185, 129),
        ToggleOff = Color3.fromRGB(26, 58, 53),
        SliderFill = Color3.fromRGB(16, 185, 129),
        SliderBg = Color3.fromRGB(26, 58, 53),
        Input = Color3.fromRGB(13, 31, 28),
        InputBorder = Color3.fromRGB(26, 69, 64),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
    Rose = {
        Name = "Rose",
        Background = Color3.fromRGB(20, 10, 15),
        Sidebar = Color3.fromRGB(30, 15, 22),
        Card = Color3.fromRGB(45, 20, 32),
        CardBorder = Color3.fromRGB(70, 30, 50),
        Text = Color3.fromRGB(255, 230, 240),
        TextMuted = Color3.fromRGB(170, 120, 140),
        Accent = Color3.fromRGB(244, 63, 94),
        AccentHover = Color3.fromRGB(225, 29, 72),
        Toggle = Color3.fromRGB(244, 63, 94),
        ToggleOff = Color3.fromRGB(70, 30, 50),
        SliderFill = Color3.fromRGB(244, 63, 94),
        SliderBg = Color3.fromRGB(70, 30, 50),
        Input = Color3.fromRGB(35, 15, 25),
        InputBorder = Color3.fromRGB(90, 40, 60),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
}

-- Config System
local ConfigSystem = {}
ConfigSystem.__index = ConfigSystem

function ConfigSystem.new(folder)
    local self = setmetatable({}, ConfigSystem)
    self.Folder = folder or "AstraLib"
    self.Elements = {}
    
    -- Create folder if it doesn't exist
    if not isfolder(self.Folder) then
        makefolder(self.Folder)
    end
    
    return self
end

function ConfigSystem:RegisterElement(id, element)
    self.Elements[id] = element
end

function ConfigSystem:GetConfigs()
    local configs = {}
    if isfolder(self.Folder) then
        for _, file in pairs(listfiles(self.Folder)) do
            local name = file:match("([^/\\]+)%.json$")
            if name then
                table.insert(configs, name)
            end
        end
    end
    return configs
end

function ConfigSystem:SaveConfig(name)
    local data = {}
    for id, element in pairs(self.Elements) do
        if element.Type == "Toggle" then
            data[id] = element.Value
        elseif element.Type == "Slider" then
            data[id] = element.Value
        elseif element.Type == "Dropdown" then
            data[id] = element.Value
        elseif element.Type == "Keybind" then
            data[id] = element.Value.Name
        elseif element.Type == "Input" then
            data[id] = element.Value
        elseif element.Type == "ColorPicker" then
            data[id] = {element.Value.R * 255, element.Value.G * 255, element.Value.B * 255}
        end
    end
    
    local json = HttpService:JSONEncode(data)
    writefile(self.Folder .. "/" .. name .. ".json", json)
end

function ConfigSystem:LoadConfig(name)
    local path = self.Folder .. "/" .. name .. ".json"
    if isfile(path) then
        local json = readfile(path)
        local data = HttpService:JSONDecode(json)
        
        for id, value in pairs(data) do
            local element = self.Elements[id]
            if element then
                if element.Type == "Toggle" then
                    element:Set(value)
                elseif element.Type == "Slider" then
                    element:Set(value)
                elseif element.Type == "Dropdown" then
                    element:Set(value)
                elseif element.Type == "Keybind" then
                    element:Set(Enum.KeyCode[value])
                elseif element.Type == "Input" then
                    element:Set(value)
                elseif element.Type == "ColorPicker" then
                    element:Set(Color3.fromRGB(value[1], value[2], value[3]))
                end
            end
        end
        return true
    end
    return false
end

function ConfigSystem:DeleteConfig(name)
    local path = self.Folder .. "/" .. name .. ".json"
    if isfile(path) then
        delfile(path)
        return true
    end
    return false
end

-- Main Library
function AstraLib:CreateWindow(options)
    options = options or {}
    local Title = options.Title or "Astra Hub"
    local Version = options.Version or "v3"
    local ThemeName = options.Theme or "Dark"
    local ConfigFolder = options.ConfigFolder or "AstraLib"
    local DefaultTab = options.DefaultTab
    
    local Theme = Themes[ThemeName] or Themes.Dark
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    Window.Theme = Theme
    Window.Open = true
    Window.Config = ConfigSystem.new(ConfigFolder)
    
    local Scale = GetScale()
    
    -- Destroy existing GUI
    if CoreGui:FindFirstChild("AstraLib") then
        CoreGui:FindFirstChild("AstraLib"):Destroy()
    end
    
    -- Main ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "AstraLib",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Mobile Toggle Button
    local MobileButton = Create("ImageButton", {
        Name = "MobileToggle",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Accent,
        Position = UDim2.new(0, 10, 0.5, -25),
        Size = UDim2.new(0, 50, 0, 50),
        Visible = IsMobile(),
        ZIndex = 100,
        Image = "rbxassetid://7072718362"
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 25)}),
        Create("UIStroke", {Color = Theme.CardBorder, Thickness = 2})
    })
    
    -- Main Frame
    local MainFrame = Create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Background,
        Position = UDim2.new(0.5, -450 * Scale, 0.5, -300 * Scale),
        Size = UDim2.new(0, 900 * Scale, 0, 600 * Scale),
        ClipsDescendants = true
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
        Create("UIStroke", {Color = Theme.CardBorder, Thickness = 1})
    })
    
    -- Shadow
    local Shadow = Create("ImageLabel", {
        Name = "Shadow",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 60, 1, 60),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = -1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Theme.Shadow,
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450)
    })
    
    -- Sidebar
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor3 = Theme.Sidebar,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 200 * Scale, 1, 0)
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 12)})
    })
    
    -- Fix corner overlap
    local SidebarFix = Create("Frame", {
        Name = "Fix",
        Parent = Sidebar,
        BackgroundColor3 = Theme.Sidebar,
        Position = UDim2.new(1, -12, 0, 0),
        Size = UDim2.new(0, 12, 1, 0),
        BorderSizePixel = 0
    })
    
    -- Title
    local TitleFrame = Create("Frame", {
        Name = "Title",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 60 * Scale)
    })
    
    local TitleLabel = Create("TextLabel", {
        Name = "Title",
        Parent = TitleFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20 * Scale, 0.5, 0),
        Size = UDim2.new(1, -40 * Scale, 0, 24 * Scale),
        AnchorPoint = Vector2.new(0, 0.5),
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = Theme.Text,
        TextSize = 18 * Scale,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local VersionLabel = Create("TextLabel", {
        Name = "Version",
        Parent = TitleFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -20 * Scale, 0.5, 0),
        Size = UDim2.new(0, 40 * Scale, 0, 16 * Scale),
        AnchorPoint = Vector2.new(1, 0.5),
        Font = Enum.Font.Gotham,
        Text = Version,
        TextColor3 = Theme.TextMuted,
        TextSize = 12 * Scale,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    -- Tab Section Label
    local TabSectionLabel = Create("TextLabel", {
        Name = "TabSection",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20 * Scale, 0, 70 * Scale),
        Size = UDim2.new(1, -40 * Scale, 0, 20 * Scale),
        Font = Enum.Font.Gotham,
        Text = "Tab Section",
        TextColor3 = Theme.TextMuted,
        TextSize = 11 * Scale,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Tab Container
    local TabContainer = Create("ScrollingFrame", {
        Name = "Tabs",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10 * Scale, 0, 95 * Scale),
        Size = UDim2.new(1, -20 * Scale, 1, -165 * Scale),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    }, {
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5 * Scale)
        })
    })
    
    -- User Profile
    local UserFrame = Create("Frame", {
        Name = "User",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10 * Scale, 1, -60 * Scale),
        Size = UDim2.new(1, -20 * Scale, 0, 50 * Scale)
    })
    
    local UserAvatar = Create("ImageLabel", {
        Name = "Avatar",
        Parent = UserFrame,
        BackgroundColor3 = Theme.Card,
        Position = UDim2.new(0, 5 * Scale, 0.5, 0),
        Size = UDim2.new(0, 40 * Scale, 0, 40 * Scale),
        AnchorPoint = Vector2.new(0, 0.5),
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. Player.UserId .. "&w=150&h=150"
    }, {
        Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    local UserName = Create("TextLabel", {
        Name = "Name",
        Parent = UserFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 55 * Scale, 0, 8 * Scale),
        Size = UDim2.new(1, -60 * Scale, 0, 16 * Scale),
        Font = Enum.Font.GothamMedium,
        Text = Player.Name,
        TextColor3 = Theme.Text,
        TextSize = 13 * Scale,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    })
    
    local UserDisplay = Create("TextLabel", {
        Name = "Display",
        Parent = UserFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 55 * Scale, 0, 26 * Scale),
        Size = UDim2.new(1, -60 * Scale, 0, 14 * Scale),
        Font = Enum.Font.Gotham,
        Text = Player.DisplayName,
        TextColor3 = Theme.TextMuted,
        TextSize = 11 * Scale,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    })
    
    -- Content Area
    local ContentArea = Create("Frame", {
        Name = "Content",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 200 * Scale, 0, 0),
        Size = UDim2.new(1, -200 * Scale, 1, 0)
    })
    
    -- Top Bar
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Parent = ContentArea,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 50 * Scale)
    })
    
    local TopVersion = Create("TextLabel", {
        Name = "Version",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20 * Scale, 0.5, 0),
        Size = UDim2.new(0, 50 * Scale, 0, 20 * Scale),
        AnchorPoint = Vector2.new(0, 0.5),
        Font = Enum.Font.Gotham,
        Text = "v10",
        TextColor3 = Theme.TextMuted,
        TextSize = 12 * Scale,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Top Bar Icons Container
    local TopIcons = Create("Frame", {
        Name = "Icons",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -20 * Scale, 0.5, 0),
        Size = UDim2.new(0, 100 * Scale, 0, 30 * Scale),
        AnchorPoint = Vector2.new(1, 0.5)
    }, {
        Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 10 * Scale)
        })
    })
    
    -- Search Icon
    local SearchIcon = Create("ImageButton", {
        Name = "Search",
        Parent = TopIcons,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20 * Scale, 0, 20 * Scale),
        Image = "rbxassetid://7072717857",
        ImageColor3 = Theme.TextMuted
    })
    
    -- Minimize Button
    local MinimizeBtn = Create("TextButton", {
        Name = "Minimize",
        Parent = TopIcons,
        BackgroundColor3 = Theme.Accent,
        Size = UDim2.new(0, 16 * Scale, 0, 16 * Scale),
        Text = ""
    }, {
        Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Close Button
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        Parent = TopIcons,
        BackgroundColor3 = Theme.CardBorder,
        Size = UDim2.new(0, 16 * Scale, 0, 16 * Scale),
        Text = ""
    }, {
        Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Tab Content Container
    local TabContent = Create("Frame", {
        Name = "TabContent",
        Parent = ContentArea,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 50 * Scale),
        Size = UDim2.new(1, 0, 1, -50 * Scale)
    })
    
    -- Dragging
    local Dragging = false
    local DragStart, StartPos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = input.Position - DragStart
            MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
    
    -- Close/Minimize Functions
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        Window.Open = not Window.Open
        MainFrame.Visible = Window.Open
    end)
    
    MobileButton.MouseButton1Click:Connect(function()
        Window.Open = not Window.Open
        MainFrame.Visible = Window.Open
    end)
    
    -- Tab Creation Function
    function Window:CreateTab(options)
        options = options or {}
        local TabName = options.Name or "Tab"
        local TabIcon = options.Icon or "rbxassetid://7072706796"
        
        local Tab = {}
        Tab.Name = TabName
        Tab.Sections = {Left = {}, Right = {}}
        
        -- Tab Button
        local TabButton = Create("TextButton", {
            Name = TabName,
            Parent = TabContainer,
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 35 * Scale),
            Text = "",
            AutoButtonColor = false
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            Create("UIPadding", {
                PaddingLeft = UDim.new(0, 10 * Scale),
                PaddingRight = UDim.new(0, 10 * Scale)
            })
        })
        
        local TabIconImg = Create("ImageLabel", {
            Name = "Icon",
            Parent = TabButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(0, 18 * Scale, 0, 18 * Scale),
            AnchorPoint = Vector2.new(0, 0.5),
            Image = TabIcon,
            ImageColor3 = Theme.TextMuted
        })
        
        local TabLabel = Create("TextLabel", {
            Name = "Label",
            Parent = TabButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 28 * Scale, 0, 0),
            Size = UDim2.new(1, -28 * Scale, 1, 0),
            Font = Enum.Font.GothamMedium,
            Text = TabName,
            TextColor3 = Theme.TextMuted,
            TextSize = 13 * Scale,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        -- Tab Page
        local TabPage = Create("Frame", {
            Name = TabName,
            Parent = TabContent,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false
        })
        
        -- Left Column
        local LeftColumn = Create("ScrollingFrame", {
            Name = "Left",
            Parent = TabPage,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15 * Scale, 0, 0),
            Size = UDim2.new(0.5, -22 * Scale, 1, -15 * Scale),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Accent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        }, {
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10 * Scale)
            })
        })
        
        -- Right Column
        local RightColumn = Create("ScrollingFrame", {
            Name = "Right",
            Parent = TabPage,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 7 * Scale, 0, 0),
            Size = UDim2.new(0.5, -22 * Scale, 1, -15 * Scale),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Accent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        }, {
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10 * Scale)
            })
        })
        
        -- Tab Selection
        local function SelectTab()
            -- Deselect all tabs
            for _, t in pairs(Window.Tabs) do
                t.Button.BackgroundTransparency = 1
                t.Label.TextColor3 = Theme.TextMuted
                t.Icon.ImageColor3 = Theme.TextMuted
                t.Page.Visible = false
            end
            
            -- Select this tab
            TabButton.BackgroundTransparency = 0
            TabLabel.TextColor3 = Theme.Text
            TabIconImg.ImageColor3 = Theme.Accent
            TabPage.Visible = true
            Window.ActiveTab = Tab
        end
        
        TabButton.MouseButton1Click:Connect(SelectTab)
        
        Tab.Button = TabButton
        Tab.Label = TabLabel
        Tab.Icon = TabIconImg
        Tab.Page = TabPage
        Tab.LeftColumn = LeftColumn
        Tab.RightColumn = RightColumn
        
        -- Section Creation
        function Tab:CreateSection(options)
            options = options or {}
            local SectionName = options.Name or "Section"
            local Side = options.Side or "Left"
            
            local Section = {}
            local Column = Side == "Left" and LeftColumn or RightColumn
            
            -- Section Frame
            local SectionFrame = Create("Frame", {
                Name = SectionName,
                Parent = Column,
                BackgroundColor3 = Theme.Card,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
                Create("UIStroke", {Color = Theme.CardBorder, Thickness = 1}),
                Create("UIPadding", {
                    PaddingTop = UDim.new(0, 12 * Scale),
                    PaddingBottom = UDim.new(0, 12 * Scale),
                    PaddingLeft = UDim.new(0, 15 * Scale),
                    PaddingRight = UDim.new(0, 15 * Scale)
                })
            })
            
            -- Section Header
            local SectionHeader = Create("TextLabel", {
                Name = "Header",
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 16 * Scale),
                Font = Enum.Font.Gotham,
                Text = SectionName,
                TextColor3 = Theme.TextMuted,
                TextSize = 11 * Scale,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = 0
            })
            
            -- Content Container
            local ContentContainer = Create("Frame", {
                Name = "Content",
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = 1
            }, {
                Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 8 * Scale)
                })
            })
            
            Section.Frame = SectionFrame
            Section.Content = ContentContainer
            
            -- Create Label
            function Section:CreateLabel(options)
                options = options or {}
                local Text = options.Text or "Label"
                
                local LabelFrame = Create("Frame", {
                    Name = "Label",
                    Parent = ContentContainer,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 25 * Scale)
                })
                
                local Label = Create("TextLabel", {
                    Name = "Text",
                    Parent = LabelFrame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.GothamMedium,
                    Text = Text,
                    TextColor3 = Theme.Text,
                    TextSize = 14 * Scale,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local LabelObj = {Frame = LabelFrame, Label = Label}
                
                function LabelObj:Set(text)
                    Label.Text = text
                end
                
                return LabelObj
            end
            
            -- Create Toggle
            function Section:CreateToggle(options)
                options = options or {}
                local Name = options.Name or "Toggle"
                local Default = options.Default or false
                local Callback = options.Callback or function() end
                local Flag = options.Flag
                
                local ToggleFrame = Create("Frame", {
                    Name = Name,
                    Parent = ContentContainer,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30 * Scale)
                })
                
                local ToggleLabel = Create("TextLabel", {
                    Name = "Label",
                    Parent = ToggleFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, -60 * Scale, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = Name,
                    TextColor3 = Theme.Text,
                    TextSize = 13 * Scale,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local ToggleButton = Create("TextButton", {
                    Name = "Toggle",
                    Parent = ToggleFrame,
                    BackgroundColor3 = Default and Theme.Toggle or Theme.ToggleOff,
                    Position = UDim2.new(1, -48 * Scale, 0.5, 0),
                    Size = UDim2.new(0, 48 * Scale, 0, 24 * Scale),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Text = "",
                    AutoButtonColor = false
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(1, 0)})
                })
                
                local ToggleCircle = Create("Frame", {
                    Name = "Circle",
                    Parent = ToggleButton,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Position = Default and UDim2.new(1, -22 * Scale, 0.5, 0) or UDim2.new(0, 4 * Scale, 0.5, 0),
                    Size = UDim2.new(0, 18 * Scale, 0, 18 * Scale),
                    AnchorPoint = Vector2.new(0, 0.5)
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(1, 0)})
                })
                
                local Value = Default
                
                local Toggle = {
                    Type = "Toggle",
                    Value = Value,
                    Frame = ToggleFrame
                }
                
                function Toggle:Set(val)
                    Value = val
                    Toggle.Value = val
                    Tween(ToggleButton, {BackgroundColor3 = val and Theme.Toggle or Theme.ToggleOff}, 0.2)
                    Tween(ToggleCircle, {Position = val and UDim2.new(1, -22 * Scale, 0.5, 0) or UDim2.new(0, 4 * Scale, 0.5, 0)}, 0.2)
                    Callback(val)
                end
                
                ToggleButton.MouseButton1Click:Connect(function()
                    Toggle:Set(not Value)
                end)
                
                if Flag then
                    Window.Config:RegisterElement(Flag, Toggle)
                end
                
                return Toggle
            end
            
            -- Create Slider
            function Section:CreateSlider(options)
                options = options or {}
                local Name = options.Name or "Slider"
                local Min = options.Min or 0
                local Max = options.Max or 100
                local Default = options.Default or Min
                local Increment = options.Increment or 1
                local Callback = options.Callback or function() end
                local Flag = options.Flag
                
                local SliderFrame = Create("Frame", {
                    Name = Name,
                    Parent = ContentContainer,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 45 * Scale)
                })
                
                local SliderLabel = Create("TextLabel", {
                    Name = "Label",
                    Parent = SliderFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10 * Scale, 0, 0),
                    Size = UDim2.new(1, -70 * Scale, 0, 20 * Scale),
                    Font = Enum.Font.Gotham,
                    Text = Name,
                    TextColor3 = Theme.Text,
                    TextSize = 13 * Scale,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local SliderValue = Create("TextLabel", {
                    Name = "Value",
                    Parent = SliderFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 60 * Scale, 0, 20 * Scale),
                    AnchorPoint = Vector2.new(1, 0),
                    Font = Enum.Font.Gotham,
                    Text = tostring(Default) .. "/" .. tostring(Max),
                    TextColor3 = Theme.TextMuted,
                    TextSize = 12 * Scale,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                local SliderBg = Create("Frame", {
                    Name = "Background",
                    Parent = SliderFrame,
                    BackgroundColor3 = Theme.SliderBg,
                    Position = UDim2.new(0, 0, 0, 28 * Scale),
                    Size = UDim2.new(1, 0, 0, 4 * Scale)
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(1, 0)})
                })
                
                local SliderFill = Create("Frame", {
                    Name = "Fill",
                    Parent = SliderBg,
                    BackgroundColor3 = Theme.SliderFill,
                    Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(1, 0)})
                })
                
                local SliderKnob = Create("Frame", {
                    Name = "Knob",
                    Parent = SliderBg,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Position = UDim2.new((Default - Min) / (Max - Min), 0, 0.5, 0),
                    Size = UDim2.new(0, 12 * Scale, 0, 12 * Scale),
                    AnchorPoint = Vector2.new(0.5, 0.5)
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(1, 0)})
                })
                
                local Value = Default
                local Sliding = false
                
                local Slider = {
                    Type = "Slider",
                    Value = Value,
                    Frame = SliderFrame
                }
                
                function Slider:Set(val)
                    val = math.clamp(val, Min, Max)
                    val = math.floor(val / Increment + 0.5) * Increment
                    Value = val
                    Slider.Value = val
                    
                    local percent = (val - Min) / (Max - Min)
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    SliderKnob.Position = UDim2.new(percent, 0, 0.5, 0)
                    SliderValue.Text = tostring(val) .. "/" .. tostring(Max)
                    Callback(val)
                end
                
                SliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Sliding = true
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Sliding = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if Sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local pos = input.Position.X
                        local sliderPos = SliderBg.AbsolutePosition.X
                        local sliderSize = SliderBg.AbsoluteSize.X
                        
                        local percent = math.clamp((pos - sliderPos) / sliderSize, 0, 1)
                        local val = Min + (Max - Min) * percent
                        Slider:Set(val)
                    end
                end)
                
                if Flag then
                    Window.Config:RegisterElement(Flag, Slider)
                end
                
                return Slider
            end
            
            -- Create Dropdown
            function Section:CreateDropdown(options)
                options = options or {}
                local Name = options.Name or "Dropdown"
                local Items = options.Items or {}
                local Default = options.Default or (Items[1] or "")
                local Callback = options.Callback or function() end
                local Flag = options.Flag
                
                local DropdownFrame = Create("Frame", {
                    Name = Name,
                    Parent = ContentContainer,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 55 * Scale),
                    ClipsDescendants = false
                })
                
                local DropdownLabel = Create("TextLabel", {
                    Name = "Label",
                    Parent = DropdownFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 18 * Scale),
                    Font = Enum.Font.GothamMedium,
                    Text = Name,
                    TextColor3 = Theme.Text,
                    TextSize = 13 * Scale,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local DropdownButton = Create("TextButton", {
                    Name = "Button",
                    Parent = DropdownFrame,
                    BackgroundColor3 = Theme.Input,
                    Position = UDim2.new(0, 0, 0, 22 * Scale),
                    Size = UDim2.new(1, 0, 0, 32 * Scale),
                    Text = "",
                    AutoButtonColor = false
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                    Create("UIStroke", {Color = Theme.InputBorder, Thickness = 1})
                })
                
                local DropdownSelected = Create("TextLabel", {
                    Name = "Selected",
                    Parent = DropdownButton,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12 * Scale, 0, 0),
                    Size = UDim2.new(1, -40 * Scale, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = Default,
                    TextColor3 = Theme.Text,
                    TextSize = 12 * Scale,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local DropdownArrow = Create("TextLabel", {
                    Name = "Arrow",
                    Parent = DropdownButton,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -25 * Scale, 0.5, 0),
                    Size = UDim2.new(0, 15 * Scale, 0, 15 * Scale),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Font = Enum.Font.GothamBold,
                    Text = "▼",
                    TextColor3 = Theme.TextMuted,
                    TextSize = 10 * Scale
                })
                
                local DropdownList = Create("Frame", {
                    Name = "List",
                    Parent = DropdownButton,
                    BackgroundColor3 = Theme.Input,
                    Position = UDim2.new(0, 0, 1, 5 * Scale),
                    Size = UDim2.new(1, 0, 0, 0),
                    ClipsDescendants = true,
                    ZIndex = 10,
                    Visible = false
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                    Create("UIStroke", {Color = Theme.InputBorder, Thickness = 1}),
                    Create("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 2)
                    }),
                    Create("UIPadding", {
                        PaddingTop = UDim.new(0, 5),
                        PaddingBottom = UDim.new(0, 5)
                    })
                })
                
                local Value = Default
                local Open = false
                
                local Dropdown = {
                    Type = "Dropdown",
                    Value = Value,
                    Frame = DropdownFrame
                }
                
                local function CreateOption(item)
                    local Option = Create("TextButton", {
                        Name = item,
                        Parent = DropdownList,
                        BackgroundColor3 = Theme.Card,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -10, 0, 28 * Scale),
                        Font = Enum.Font.Gotham,
                        Text = item,
                        TextColor3 = Theme.Text,
                        TextSize = 12 * Scale,
                        ZIndex = 11,
                        AutoButtonColor = false
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                        Create("UIPadding", {PaddingLeft = UDim.new(0, 10)})
                    })
                    
                    Option.MouseEnter:Connect(function()
                        Tween(Option, {BackgroundTransparency = 0}, 0.1)
                    end)
                    
                    Option.MouseLeave:Connect(function()
                        Tween(Option, {BackgroundTransparency = 1}, 0.1)
                    end)
                    
                    Option.MouseButton1Click:Connect(function()
                        Dropdown:Set(item)
                        Open = false
                        DropdownList.Visible = false
                        DropdownArrow.Text = "▼"
                    end)
                end
                
                for _, item in ipairs(Items) do
                    CreateOption(item)
                end
                
                function Dropdown:Set(val)
                    Value = val
                    Dropdown.Value = val
                    DropdownSelected.Text = val
                    Callback(val)
                end
                
                function Dropdown:Refresh(newItems)
                    for _, child in pairs(DropdownList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    Items = newItems
                    for _, item in ipairs(Items) do
                        CreateOption(item)
                    end
                    DropdownList.Size = UDim2.new(1, 0, 0, #Items * (28 * Scale + 2) + 10)
                end
                
                DropdownButton.MouseButton1Click:Connect(function()
                    Open = not Open
                    DropdownList.Visible = Open
                    DropdownArrow.Text = Open and "▲" or "▼"
                    if Open then
                        DropdownList.Size = UDim2.new(1, 0, 0, math.min(#Items * (28 * Scale + 2) + 10, 150 * Scale))
                    end
                end)
                
                if Flag then
                    Window.Config:RegisterElement(Flag, Dropdown)
                end
                
                return Dropdown
            end
            
            -- Create Button
            function Section:CreateButton(options)
                options = options or {}
                local Name = options.Name or "Button"
                local Callback = options.Callback or function() end
                
                local ButtonFrame = Create("Frame", {
                    Name = Name,
                    Parent = ContentContainer,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 35 * Scale)
                })
                
                local Button = Create("TextButton", {
                    Name = "Button",
                    Parent = ButtonFrame,
                    BackgroundColor3 = Theme.Accent,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.GothamMedium,
                    Text = Name,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 13 * Scale,
                    AutoButtonColor = false
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(0, 6)})
                })
                
                Button.MouseEnter:Connect(function()
                    Tween(Button, {BackgroundColor3 = Theme.AccentHover}, 0.1)
                end)
                
                Button.MouseLeave:Connect(function()
                    Tween(Button, {BackgroundColor3 = Theme.Accent}, 0.1)
                end)
                
                Button.MouseButton1Click:Connect(function()
                    Callback()
                end)
                
                return {Frame = ButtonFrame, Button = Button}
            end
            
            -- Create Input
            function Section:CreateInput(options)
                options = options or {}
                local Name = options.Name or "Input"
                local Placeholder = options.Placeholder or "Enter text..."
                local Default = options.Default or ""
                local Callback = options.Callback or function() end
                local Flag = options.Flag
                
                local InputFrame = Create("Frame", {
                    Name = Name,
                    Parent = ContentContainer,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 55 * Scale)
                })
                
                local InputLabel = Create("TextLabel", {
                    Name = "Label",
                    Parent = InputFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 18 * Scale),
                    Font = Enum.Font.GothamMedium,
                    Text = Name,
                    TextColor3 = Theme.Text,
                    TextSize = 13 * Scale,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local InputBox = Create("TextBox", {
                    Name = "Input",
                    Parent = InputFrame,
                    BackgroundColor3 = Theme.Input,
                    Position = UDim2.new(0, 0, 0, 22 * Scale),
                    Size = UDim2.new(1, 0, 0, 32 * Scale),
                    Font = Enum.Font.Gotham,
                    PlaceholderText = Placeholder,
                    PlaceholderColor3 = Theme.TextMuted,
                    Text = Default,
                    TextColor3 = Theme.Text,
                    TextSize = 12 * Scale,
                    ClearTextOnFocus = false
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                    Create("UIStroke", {Color = Theme.InputBorder, Thickness = 1}),
                    Create("UIPadding", {
                        PaddingLeft = UDim.new(0, 12 * Scale),
                        PaddingRight = UDim.new(0, 12 * Scale)
                    })
                })
                
                local Value = Default
                
                local Input = {
                    Type = "Input",
                    Value = Value,
                    Frame = InputFrame
                }
                
                function Input:Set(val)
                    Value = val
                    Input.Value = val
                    InputBox.Text = val
                    Callback(val)
                end
                
                InputBox.FocusLost:Connect(function()
                    Value = InputBox.Text
                    Input.Value = Value
                    Callback(Value)
                end)
                
                if Flag then
                    Window.Config:RegisterElement(Flag, Input)
                end
                
                return Input
            end
            
            -- Create Keybind
            function Section:CreateKeybind(options)
                options = options or {}
                local Name = options.Name or "Keybind"
                local Default = options.Default or Enum.KeyCode.Unknown
                local Callback = options.Callback or function() end
                local Flag = options.Flag
                
                local KeybindFrame = Create("Frame", {
                    Name = Name,
                    Parent = ContentContainer,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30 * Scale)
                })
                
                local KeybindLabel = Create("TextLabel", {
                    Name = "Label",
                    Parent = KeybindFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, -80 * Scale, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = Name,
                    TextColor3 = Theme.Text,
                    TextSize = 13 * Scale,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local KeybindButton = Create("TextButton", {
                    Name = "Button",
                    Parent = KeybindFrame,
                    BackgroundColor3 = Theme.Input,
                    Position = UDim2.new(1, -70 * Scale, 0.5, 0),
                    Size = UDim2.new(0, 70 * Scale, 0, 26 * Scale),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Font = Enum.Font.Gotham,
                    Text = Default.Name or "None",
                    TextColor3 = Theme.Text,
                    TextSize = 11 * Scale,
                    AutoButtonColor = false
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                    Create("UIStroke", {Color = Theme.InputBorder, Thickness = 1})
                })
                
                local Value = Default
                local Listening = false
                
                local Keybind = {
                    Type = "Keybind",
                    Value = Value,
                    Frame = KeybindFrame
                }
                
                function Keybind:Set(key)
                    Value = key
                    Keybind.Value = key
                    KeybindButton.Text = key.Name or "None"
                end
                
                KeybindButton.MouseButton1Click:Connect(function()
                    Listening = true
                    KeybindButton.Text = "..."
                end)
                
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if Listening then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            Listening = false
                            Keybind:Set(input.KeyCode)
                        end
                    elseif input.KeyCode == Value and not gameProcessed then
                        Callback(Value)
                    end
                end)
                
                if Flag then
                    Window.Config:RegisterElement(Flag, Keybind)
                end
                
                return Keybind
            end
            
            table.insert(Tab.Sections[Side], Section)
            return Section
        end
        
        table.insert(Window.Tabs, Tab)
        
        -- Select first tab or default tab
        if #Window.Tabs == 1 or (DefaultTab and TabName == DefaultTab) then
            SelectTab()
        end
        
        return Tab
    end
    
    -- Create Config Tab
    function Window:CreateConfigTab()
        local ConfigTab = Window:CreateTab({Name = "Configs", Icon = "rbxassetid://7072719587"})
        local ConfigSection = ConfigTab:CreateSection({Name = "Configuration", Side = "Left"})
        
        local ConfigNameInput
        local ConfigDropdown
        local CurrentConfigs = Window.Config:GetConfigs()
        
        ConfigNameInput = ConfigSection:CreateInput({
            Name = "Config Name",
            Placeholder = "Enter config name...",
            Callback = function() end
        })
        
        ConfigDropdown = ConfigSection:CreateDropdown({
            Name = "Config List",
            Items = CurrentConfigs,
            Default = CurrentConfigs[1] or "",
            Callback = function() end
        })
        
        ConfigSection:CreateButton({
            Name = "Save Config",
            Callback = function()
                local name = ConfigNameInput.Value
                if name and name ~= "" then
                    Window.Config:SaveConfig(name)
                    ConfigDropdown:Refresh(Window.Config:GetConfigs())
                end
            end
        })
        
        ConfigSection:CreateButton({
            Name = "Load Config",
            Callback = function()
                local name = ConfigDropdown.Value
                if name and name ~= "" then
                    Window.Config:LoadConfig(name)
                end
            end
        })
        
        ConfigSection:CreateButton({
            Name = "Delete Config",
            Callback = function()
                local name = ConfigDropdown.Value
                if name and name ~= "" then
                    Window.Config:DeleteConfig(name)
                    ConfigDropdown:Refresh(Window.Config:GetConfigs())
                end
            end
        })
        
        ConfigSection:CreateButton({
            Name = "Refresh Configs",
            Callback = function()
                ConfigDropdown:Refresh(Window.Config:GetConfigs())
            end
        })
        
        return ConfigTab
    end
    
    -- Theme Functions
    function Window:SetTheme(themeName)
        if Themes[themeName] then
            Theme = Themes[themeName]
            Window.Theme = Theme
            -- Update would require recreating UI or implementing color updates
        end
    end
    
    function Window:GetThemes()
        local themeNames = {}
        for name, _ in pairs(Themes) do
            table.insert(themeNames, name)
        end
        return themeNames
    end
    
    -- Toggle Window
    function Window:Toggle()
        Window.Open = not Window.Open
        MainFrame.Visible = Window.Open
    end
    
    -- Destroy Window
    function Window:Destroy()
        ScreenGui:Destroy()
    end
    
    return Window
end

return AstraLib

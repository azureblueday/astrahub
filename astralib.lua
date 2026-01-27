local AstraLib = {}
AstraLib.__index = AstraLib
print("Astra UI Library - by @d1starzz (discord.gg/getnova)")
print("Loaded Version: 472")
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
    Dropdown = 40,
    DropdownItems = 45,
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
    Dropdown = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
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
-- THEMES (Glass Design with Purple Accents for Dark Theme)
-- ═══════════════════════════════════════════════════════════════════
local Themes = {
    Dark = {
        Name = "Dark",
        -- Main backgrounds with deep dark tones
        Background = Color3.fromRGB(12, 10, 18),
        BackgroundSecondary = Color3.fromRGB(16, 14, 24),
        Sidebar = Color3.fromRGB(14, 12, 22),
        SidebarTransparency = 0.1,
        
        -- Glass card styling
        Card = Color3.fromRGB(20, 18, 32),
        CardTransparency = 0.15,
        CardBorder = Color3.fromRGB(75, 50, 120),
        CardBorderTransparency = 0.5,
        CardHover = Color3.fromRGB(28, 24, 45),
        CardGlow = Color3.fromRGB(138, 92, 246),
        
        -- Text colors
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(220, 215, 235),
        TextMuted = Color3.fromRGB(140, 130, 170),
        
        -- Purple accent colors
        Accent = Color3.fromRGB(138, 92, 246),
        AccentHover = Color3.fromRGB(158, 118, 255),
        AccentDark = Color3.fromRGB(108, 72, 200),
        AccentGlow = Color3.fromRGB(138, 92, 246),
        AccentMuted = Color3.fromRGB(90, 60, 160),
        
        -- Interactive elements
        Toggle = Color3.fromRGB(138, 92, 246),
        ToggleOff = Color3.fromRGB(40, 35, 60),
        ToggleKnob = Color3.fromRGB(255, 255, 255),
        
        SliderFill = Color3.fromRGB(138, 92, 246),
        SliderBg = Color3.fromRGB(35, 30, 55),
        SliderKnob = Color3.fromRGB(255, 255, 255),
        
        -- Input styling
        Input = Color3.fromRGB(22, 20, 38),
        InputTransparency = 0.3,
        InputBorder = Color3.fromRGB(60, 50, 95),
        InputFocus = Color3.fromRGB(138, 92, 246),
        InputHover = Color3.fromRGB(28, 25, 48),
        
        -- Dropdown styling
        DropdownBg = Color3.fromRGB(18, 16, 30),
        DropdownItem = Color3.fromRGB(25, 22, 42),
        DropdownItemHover = Color3.fromRGB(45, 38, 75),
        DropdownBorder = Color3.fromRGB(70, 55, 110),
        
        -- Effects
        Shadow = Color3.fromRGB(0, 0, 0),
        ShadowTransparency = 0.5,
        
        -- Glass effects
        Glass = Color3.fromRGB(180, 160, 255),
        GlassTransparency = 0.92,
        GlassBorder = Color3.fromRGB(100, 80, 160),
        GlassShine = Color3.fromRGB(255, 255, 255),
        GlassShineTransparency = 0.95,
        
        -- Status colors
        Success = Color3.fromRGB(52, 211, 153),
        Error = Color3.fromRGB(248, 113, 113),
        Warning = Color3.fromRGB(251, 191, 36),
        Info = Color3.fromRGB(96, 165, 250),
        
        -- Gradient support
        GradientEnabled = true,
        GradientStart = Color3.fromRGB(138, 92, 246),
        GradientEnd = Color3.fromRGB(88, 62, 180),
    },
    
    Midnight = {
        Name = "Midnight",
        Background = Color3.fromRGB(8, 8, 16),
        BackgroundSecondary = Color3.fromRGB(12, 12, 22),
        Sidebar = Color3.fromRGB(10, 10, 20),
        SidebarTransparency = 0.12,
        Card = Color3.fromRGB(16, 16, 30),
        CardTransparency = 0.2,
        CardBorder = Color3.fromRGB(45, 45, 80),
        CardBorderTransparency = 0.5,
        CardHover = Color3.fromRGB(24, 24, 45),
        CardGlow = Color3.fromRGB(100, 100, 200),
        Text = Color3.fromRGB(230, 230, 255),
        TextSecondary = Color3.fromRGB(200, 200, 230),
        TextMuted = Color3.fromRGB(120, 120, 160),
        Accent = Color3.fromRGB(100, 120, 220),
        AccentHover = Color3.fromRGB(120, 140, 240),
        AccentDark = Color3.fromRGB(70, 90, 180),
        AccentGlow = Color3.fromRGB(100, 120, 220),
        AccentMuted = Color3.fromRGB(60, 70, 140),
        Toggle = Color3.fromRGB(100, 120, 220),
        ToggleOff = Color3.fromRGB(35, 35, 55),
        ToggleKnob = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(100, 120, 220),
        SliderBg = Color3.fromRGB(30, 30, 50),
        SliderKnob = Color3.fromRGB(255, 255, 255),
        Input = Color3.fromRGB(18, 18, 35),
        InputTransparency = 0.35,
        InputBorder = Color3.fromRGB(50, 50, 85),
        InputFocus = Color3.fromRGB(100, 120, 220),
        InputHover = Color3.fromRGB(25, 25, 45),
        DropdownBg = Color3.fromRGB(14, 14, 28),
        DropdownItem = Color3.fromRGB(22, 22, 40),
        DropdownItemHover = Color3.fromRGB(40, 40, 70),
        DropdownBorder = Color3.fromRGB(55, 55, 90),
        Shadow = Color3.fromRGB(0, 0, 0),
        ShadowTransparency = 0.45,
        Glass = Color3.fromRGB(150, 150, 220),
        GlassTransparency = 0.9,
        GlassBorder = Color3.fromRGB(70, 70, 120),
        GlassShine = Color3.fromRGB(255, 255, 255),
        GlassShineTransparency = 0.94,
        Success = Color3.fromRGB(52, 211, 153),
        Error = Color3.fromRGB(248, 113, 113),
        Warning = Color3.fromRGB(251, 191, 36),
        Info = Color3.fromRGB(96, 165, 250),
        GradientEnabled = true,
        GradientStart = Color3.fromRGB(100, 120, 220),
        GradientEnd = Color3.fromRGB(60, 80, 160),
    },
    
    Ocean = {
        Name = "Ocean",
        Background = Color3.fromRGB(8, 14, 22),
        BackgroundSecondary = Color3.fromRGB(12, 20, 30),
        Sidebar = Color3.fromRGB(10, 18, 28),
        SidebarTransparency = 0.1,
        Card = Color3.fromRGB(14, 25, 40),
        CardTransparency = 0.18,
        CardBorder = Color3.fromRGB(40, 80, 130),
        CardBorderTransparency = 0.5,
        CardHover = Color3.fromRGB(20, 38, 60),
        CardGlow = Color3.fromRGB(56, 189, 248),
        Text = Color3.fromRGB(240, 250, 255),
        TextSecondary = Color3.fromRGB(210, 235, 250),
        TextMuted = Color3.fromRGB(120, 160, 190),
        Accent = Color3.fromRGB(56, 189, 248),
        AccentHover = Color3.fromRGB(96, 210, 255),
        AccentDark = Color3.fromRGB(30, 140, 200),
        AccentGlow = Color3.fromRGB(56, 189, 248),
        AccentMuted = Color3.fromRGB(40, 120, 170),
        Toggle = Color3.fromRGB(56, 189, 248),
        ToggleOff = Color3.fromRGB(25, 45, 70),
        ToggleKnob = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(56, 189, 248),
        SliderBg = Color3.fromRGB(20, 40, 65),
        SliderKnob = Color3.fromRGB(255, 255, 255),
        Input = Color3.fromRGB(12, 24, 40),
        InputTransparency = 0.35,
        InputBorder = Color3.fromRGB(45, 85, 130),
        InputFocus = Color3.fromRGB(56, 189, 248),
        InputHover = Color3.fromRGB(18, 35, 55),
        DropdownBg = Color3.fromRGB(10, 20, 35),
        DropdownItem = Color3.fromRGB(16, 32, 52),
        DropdownItemHover = Color3.fromRGB(30, 60, 95),
        DropdownBorder = Color3.fromRGB(50, 95, 145),
        Shadow = Color3.fromRGB(0, 0, 0),
        ShadowTransparency = 0.5,
        Glass = Color3.fromRGB(150, 220, 255),
        GlassTransparency = 0.88,
        GlassBorder = Color3.fromRGB(60, 130, 180),
        GlassShine = Color3.fromRGB(255, 255, 255),
        GlassShineTransparency = 0.92,
        Success = Color3.fromRGB(52, 211, 153),
        Error = Color3.fromRGB(248, 113, 113),
        Warning = Color3.fromRGB(251, 191, 36),
        Info = Color3.fromRGB(96, 165, 250),
        GradientEnabled = true,
        GradientStart = Color3.fromRGB(56, 189, 248),
        GradientEnd = Color3.fromRGB(20, 130, 200),
    },
    
    Emerald = {
        Name = "Emerald",
        Background = Color3.fromRGB(8, 16, 12),
        BackgroundSecondary = Color3.fromRGB(12, 22, 18),
        Sidebar = Color3.fromRGB(10, 20, 15),
        SidebarTransparency = 0.1,
        Card = Color3.fromRGB(14, 30, 22),
        CardTransparency = 0.18,
        CardBorder = Color3.fromRGB(40, 100, 70),
        CardBorderTransparency = 0.5,
        CardHover = Color3.fromRGB(22, 45, 35),
        CardGlow = Color3.fromRGB(52, 211, 153),
        Text = Color3.fromRGB(240, 255, 248),
        TextSecondary = Color3.fromRGB(210, 245, 230),
        TextMuted = Color3.fromRGB(120, 175, 150),
        Accent = Color3.fromRGB(52, 211, 153),
        AccentHover = Color3.fromRGB(80, 230, 175),
        AccentDark = Color3.fromRGB(35, 170, 120),
        AccentGlow = Color3.fromRGB(52, 211, 153),
        AccentMuted = Color3.fromRGB(40, 140, 100),
        Toggle = Color3.fromRGB(52, 211, 153),
        ToggleOff = Color3.fromRGB(25, 55, 42),
        ToggleKnob = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(52, 211, 153),
        SliderBg = Color3.fromRGB(20, 50, 38),
        SliderKnob = Color3.fromRGB(255, 255, 255),
        Input = Color3.fromRGB(12, 28, 20),
        InputTransparency = 0.35,
        InputBorder = Color3.fromRGB(45, 105, 75),
        InputFocus = Color3.fromRGB(52, 211, 153),
        InputHover = Color3.fromRGB(18, 40, 30),
        DropdownBg = Color3.fromRGB(10, 24, 18),
        DropdownItem = Color3.fromRGB(16, 38, 28),
        DropdownItemHover = Color3.fromRGB(30, 70, 52),
        DropdownBorder = Color3.fromRGB(50, 115, 85),
        Shadow = Color3.fromRGB(0, 0, 0),
        ShadowTransparency = 0.5,
        Glass = Color3.fromRGB(150, 255, 210),
        GlassTransparency = 0.88,
        GlassBorder = Color3.fromRGB(60, 150, 110),
        GlassShine = Color3.fromRGB(255, 255, 255),
        GlassShineTransparency = 0.92,
        Success = Color3.fromRGB(52, 211, 153),
        Error = Color3.fromRGB(248, 113, 113),
        Warning = Color3.fromRGB(251, 191, 36),
        Info = Color3.fromRGB(96, 165, 250),
        GradientEnabled = true,
        GradientStart = Color3.fromRGB(52, 211, 153),
        GradientEnd = Color3.fromRGB(30, 150, 100),
    },
    
    Rose = {
        Name = "Rose",
        Background = Color3.fromRGB(16, 10, 14),
        BackgroundSecondary = Color3.fromRGB(22, 14, 20),
        Sidebar = Color3.fromRGB(20, 12, 18),
        SidebarTransparency = 0.1,
        Card = Color3.fromRGB(32, 18, 28),
        CardTransparency = 0.18,
        CardBorder = Color3.fromRGB(120, 60, 95),
        CardBorderTransparency = 0.5,
        CardHover = Color3.fromRGB(48, 28, 42),
        CardGlow = Color3.fromRGB(244, 114, 182),
        Text = Color3.fromRGB(255, 245, 250),
        TextSecondary = Color3.fromRGB(250, 225, 240),
        TextMuted = Color3.fromRGB(180, 140, 165),
        Accent = Color3.fromRGB(244, 114, 182),
        AccentHover = Color3.fromRGB(255, 145, 200),
        AccentDark = Color3.fromRGB(200, 80, 145),
        AccentGlow = Color3.fromRGB(244, 114, 182),
        AccentMuted = Color3.fromRGB(170, 70, 125),
        Toggle = Color3.fromRGB(244, 114, 182),
        ToggleOff = Color3.fromRGB(60, 35, 50),
        ToggleKnob = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(244, 114, 182),
        SliderBg = Color3.fromRGB(55, 32, 45),
        SliderKnob = Color3.fromRGB(255, 255, 255),
        Input = Color3.fromRGB(28, 16, 24),
        InputTransparency = 0.35,
        InputBorder = Color3.fromRGB(110, 60, 90),
        InputFocus = Color3.fromRGB(244, 114, 182),
        InputHover = Color3.fromRGB(40, 24, 35),
        DropdownBg = Color3.fromRGB(24, 14, 20),
        DropdownItem = Color3.fromRGB(38, 22, 32),
        DropdownItemHover = Color3.fromRGB(70, 42, 58),
        DropdownBorder = Color3.fromRGB(130, 70, 105),
        Shadow = Color3.fromRGB(0, 0, 0),
        ShadowTransparency = 0.5,
        Glass = Color3.fromRGB(255, 180, 220),
        GlassTransparency = 0.88,
        GlassBorder = Color3.fromRGB(180, 100, 145),
        GlassShine = Color3.fromRGB(255, 255, 255),
        GlassShineTransparency = 0.92,
        Success = Color3.fromRGB(52, 211, 153),
        Error = Color3.fromRGB(248, 113, 113),
        Warning = Color3.fromRGB(251, 191, 36),
        Info = Color3.fromRGB(96, 165, 250),
        GradientEnabled = true,
        GradientStart = Color3.fromRGB(244, 114, 182),
        GradientEnd = Color3.fromRGB(180, 70, 130),
    },
}

-- ═══════════════════════════════════════════════════════════════════
-- IMPROVED CONFIG SYSTEM WITH SUBFOLDERS
-- ═══════════════════════════════════════════════════════════════════
local ConfigSystem = {}
ConfigSystem.__index = ConfigSystem

function ConfigSystem.new(options)
    local self = setmetatable({}, ConfigSystem)
    
    -- Support both old string format and new options table
    if type(options) == "string" then
        self.MainFolder = options
        self.SubFolder = nil
    else
        options = options or {}
        self.MainFolder = options.MainFolder or "AstraLib"
        self.SubFolder = options.SubFolder or options.GameFolder or nil
    end
    
    self.Elements = {}
    self.AutoSave = options and options.AutoSave or false
    self.AutoSaveInterval = options and options.AutoSaveInterval or 60
    
    -- Initialize folders
    self:InitializeFolders()
    
    -- Start autosave if enabled
    if self.AutoSave then
        self:StartAutoSave()
    end
    
    return self
end

function ConfigSystem:InitializeFolders()
    pcall(function()
        -- Create main folder
        if not isfolder(self.MainFolder) then
            makefolder(self.MainFolder)
        end
        
        -- Create subfolder if specified
        if self.SubFolder then
            local subPath = self.MainFolder .. "/" .. self.SubFolder
            if not isfolder(subPath) then
                makefolder(subPath)
            end
        end
    end)
end

function ConfigSystem:GetConfigPath()
    if self.SubFolder then
        return self.MainFolder .. "/" .. self.SubFolder
    end
    return self.MainFolder
end

function ConfigSystem:SetSubFolder(subFolder)
    self.SubFolder = subFolder
    self:InitializeFolders()
end

function ConfigSystem:RegisterElement(id, element)
    self.Elements[id] = element
end

function ConfigSystem:UnregisterElement(id)
    self.Elements[id] = nil
end

function ConfigSystem:GetConfigs()
    local configs = {}
    pcall(function()
        local path = self:GetConfigPath()
        if isfolder(path) then
            for _, file in pairs(listfiles(path)) do
                local name = file:match("([^/\\]+)%.json$")
                if name then
                    table.insert(configs, name)
                end
            end
        end
    end)
    return configs
end

function ConfigSystem:GetAllSubFolders()
    local folders = {}
    pcall(function()
        if isfolder(self.MainFolder) then
            for _, item in pairs(listfiles(self.MainFolder)) do
                if isfolder(item) then
                    local name = item:match("([^/\\]+)$")
                    if name then
                        table.insert(folders, name)
                    end
                end
            end
        end
    end)
    return folders
end

function ConfigSystem:SaveConfig(name)
    local data = {
        _metadata = {
            savedAt = os.time(),
            version = "2.0",
            subFolder = self.SubFolder
        },
        settings = {}
    }
    
    for id, element in pairs(self.Elements) do
        if element.Type == "Toggle" then
            data.settings[id] = {type = "Toggle", value = element.Value}
        elseif element.Type == "Slider" then
            data.settings[id] = {type = "Slider", value = element.Value}
        elseif element.Type == "Dropdown" then
            data.settings[id] = {type = "Dropdown", value = element.Value}
        elseif element.Type == "Keybind" then
            data.settings[id] = {type = "Keybind", value = element.Value.Name}
        elseif element.Type == "Input" then
            data.settings[id] = {type = "Input", value = element.Value}
        elseif element.Type == "ColorPicker" then
            local c = element.Value
            data.settings[id] = {type = "ColorPicker", value = {c.R * 255, c.G * 255, c.B * 255}}
        end
    end
    
    local success, err = pcall(function()
        local path = self:GetConfigPath() .. "/" .. name .. ".json"
        writefile(path, HttpService:JSONEncode(data))
    end)
    
    return success, err
end

function ConfigSystem:LoadConfig(name)
    local success, err = pcall(function()
        local path = self:GetConfigPath() .. "/" .. name .. ".json"
        if isfile(path) then
            local raw = readfile(path)
            local data = HttpService:JSONDecode(raw)
            
            -- Handle both old and new config formats
            local settings = data.settings or data
            
            for id, info in pairs(settings) do
                if id ~= "_metadata" then
                    local element = self.Elements[id]
                    if element then
                        local value = type(info) == "table" and info.value or info
                        local elementType = type(info) == "table" and info.type or element.Type
                        
                        if elementType == "Toggle" then
                            element:Set(value)
                        elseif elementType == "Slider" then
                            element:Set(value)
                        elseif elementType == "Dropdown" then
                            element:Set(value)
                        elseif elementType == "Keybind" then
                            local keyCode = Enum.KeyCode[value]
                            if keyCode then element:Set(keyCode) end
                        elseif elementType == "Input" then
                            element:Set(value)
                        elseif elementType == "ColorPicker" then
                            if type(value) == "table" then
                                element:Set(Color3.fromRGB(value[1], value[2], value[3]))
                            end
                        end
                    end
                end
            end
        end
    end)
    
    return success, err
end

function ConfigSystem:DeleteConfig(name)
    local success, err = pcall(function()
        local path = self:GetConfigPath() .. "/" .. name .. ".json"
        if isfile(path) then
            delfile(path)
        end
    end)
    return success, err
end

function ConfigSystem:ConfigExists(name)
    local exists = false
    pcall(function()
        local path = self:GetConfigPath() .. "/" .. name .. ".json"
        exists = isfile(path)
    end)
    return exists
end

function ConfigSystem:ExportConfig(name)
    local exported = nil
    pcall(function()
        local path = self:GetConfigPath() .. "/" .. name .. ".json"
        if isfile(path) then
            exported = readfile(path)
        end
    end)
    return exported
end

function ConfigSystem:ImportConfig(name, jsonData)
    local success, err = pcall(function()
        -- Validate JSON
        local data = HttpService:JSONDecode(jsonData)
        local path = self:GetConfigPath() .. "/" .. name .. ".json"
        writefile(path, jsonData)
    end)
    return success, err
end

function ConfigSystem:StartAutoSave()
    task.spawn(function()
        while self.AutoSave do
            task.wait(self.AutoSaveInterval)
            if self.AutoSave then
                self:SaveConfig("_autosave")
            end
        end
    end)
end

function ConfigSystem:StopAutoSave()
    self.AutoSave = false
end

-- ═══════════════════════════════════════════════════════════════════
-- MAIN LIBRARY
-- ═══════════════════════════════════════════════════════════════════
function AstraLib:CreateWindow(options)
    options = options or {}
    local Title = options.Title or "Nova Hub"
    local Version = options.Version or "v1.0"
    local ThemeName = options.Theme or "Dark"
    local DefaultTab = options.DefaultTab
    local MinimizeKey = options.MinimizeKey or Enum.KeyCode.LeftControl
    
    -- Config options with subfolder support
    local ConfigOptions = {
        MainFolder = options.ConfigFolder or options.MainFolder or "NovaHub",
        SubFolder = options.SubFolder or options.GameFolder or nil,
        AutoSave = options.AutoSave or false,
        AutoSaveInterval = options.AutoSaveInterval or 60
    }
    
    local Theme = Themes[ThemeName] or Themes.Dark
    local Window = {
        Tabs = {},
        ActiveTab = nil,
        Theme = Theme,
        ThemeName = ThemeName,
        Open = true,
        Config = ConfigSystem.new(ConfigOptions),
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
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 25)}),
        Create("UIStroke", {Color = Theme.CardBorder, Thickness = 1, Transparency = 0.6})
    })
    
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
    
    -- Main Frame (Glass Effect)
    local MainFrame = Create("Frame", {
        Name = "Main",
        Parent = MainContainer,
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.05,
        Size = UDim2.new(1, 0, 1, 0),
        ClipsDescendants = true,
        ZIndex = ZIndex.Background
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 14)}),
        Create("UIStroke", {Color = Theme.CardBorder, Thickness = 1.5, Transparency = Theme.CardBorderTransparency or 0.4})
    })
    
    -- Glass shine effect (top)
    Create("Frame", {
        Name = "GlassShine",
        Parent = MainFrame,
        BackgroundColor3 = Theme.GlassShine or Color3.new(1, 1, 1),
        BackgroundTransparency = Theme.GlassShineTransparency or 0.95,
        Size = UDim2.new(1, 0, 0, 100),
        BorderSizePixel = 0,
        ZIndex = ZIndex.Background + 1
    }, {
        Create("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1)
            }),
            Rotation = 90
        })
    })
    
    -- Shadow
    Create("ImageLabel", {
        Name = "Shadow",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 100, 1, 100),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = ZIndex.Shadow,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Theme.Shadow,
        ImageTransparency = Theme.ShadowTransparency or 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450)
    })
    
    -- Sidebar (Glass)
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor3 = Theme.Sidebar,
        BackgroundTransparency = Theme.SidebarTransparency or 0.1,
        Size = UDim2.new(0, 200 * Scale, 1, 0),
        ZIndex = ZIndex.Sidebar,
        ClipsDescendants = true
    }, {Create("UICorner", {CornerRadius = UDim.new(0, 14)})})
    
    -- Sidebar corner fix
    Create("Frame", {
        Name = "Fix",
        Parent = Sidebar,
        BackgroundColor3 = Theme.Sidebar,
        BackgroundTransparency = Theme.SidebarTransparency or 0.1,
        Position = UDim2.new(1, -14, 0, 0),
        Size = UDim2.new(0, 16, 1, 0),
        BorderSizePixel = 0,
        ZIndex = ZIndex.Sidebar + 1
    })
    
    -- Sidebar divider (Glass line)
    Create("Frame", {
        Name = "Divider",
        Parent = MainFrame,
        BackgroundColor3 = Theme.Glass or Theme.CardBorder,
        BackgroundTransparency = Theme.GlassTransparency or 0.88,
        Position = UDim2.new(0, 200 * Scale, 0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        BorderSizePixel = 0,
        ZIndex = ZIndex.Sidebar + 2
    })
    
    -- Title with accent glow
    local TitleLabel = Create("TextLabel", {
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
        TextColor3 = Theme.Accent,
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
        Font = Enum.Font.GothamMedium,
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
    
    local AvatarContainer = Create("Frame", {
        Name = "AvatarContainer",
        Parent = UserFrame,
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.8,
        Position = UDim2.new(0, 5 * Scale, 0.5, 0),
        Size = UDim2.new(0, 42 * Scale, 0, 42 * Scale),
        AnchorPoint = Vector2.new(0, 0.5),
        ZIndex = ZIndex.SidebarContent + 1
    }, {
        Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
        Create("UIStroke", {Color = Theme.Accent, Thickness = 2, Transparency = 0.5})
    })
    
    Create("ImageLabel", {
        Name = "Avatar",
        Parent = AvatarContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 38 * Scale, 0, 38 * Scale),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. Player.UserId .. "&w=150&h=150",
        ZIndex = ZIndex.SidebarContent + 2
    }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
    
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
        Text = "@" .. Player.DisplayName,
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
    
    local TabTitle = Create("TextLabel", {
        Name = "TabTitle",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20 * Scale, 0.5, 0),
        Size = UDim2.new(0, 200 * Scale, 0, 24 * Scale),
        AnchorPoint = Vector2.new(0, 0.5),
        Font = Enum.Font.GothamBold,
        Text = "",
        TextColor3 = Theme.Text,
        TextSize = 16 * Scale,
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
    
    -- Minimize Button
    local MinimizeBtn = Create("TextButton", {
        Name = "Minimize",
        Parent = TopIcons,
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.3,
        Size = UDim2.new(0, 16 * Scale, 0, 16 * Scale),
        Text = "",
        AutoButtonColor = false,
        ZIndex = ZIndex.TopBar
    }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
    
    MinimizeBtn.MouseEnter:Connect(function()
        Tween(MinimizeBtn, {Size = UDim2.new(0, 18 * Scale, 0, 18 * Scale), BackgroundTransparency = 0}, TweenPresets.Quick)
    end)
    MinimizeBtn.MouseLeave:Connect(function()
        Tween(MinimizeBtn, {Size = UDim2.new(0, 16 * Scale, 0, 16 * Scale), BackgroundTransparency = 0.3}, TweenPresets.Quick)
    end)
    
    -- Close Button
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
        
        -- Tab Button with glass effect
        local TabButton = Create("TextButton", {
            Name = TabName,
            Parent = TabContainer,
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 36 * Scale),
            Text = "",
            AutoButtonColor = false,
            ZIndex = ZIndex.SidebarContent + 1
        }, {Create("UICorner", {CornerRadius = UDim.new(0, 8)})})
        
        local TabIconImg = Create("ImageLabel", {
            Name = "Icon",
            Parent = TabButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12 * Scale, 0.5, 0),
            Size = UDim2.new(0, 18 * Scale, 0, 18 * Scale),
            AnchorPoint = Vector2.new(0, 0.5),
            Image = TabIcon,
            ImageColor3 = Theme.TextMuted,
            ZIndex = ZIndex.SidebarContent + 2
        })
        
        local TabLabel = Create("TextLabel", {
            Name = "Label",
            Parent = TabButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 38 * Scale, 0, 0),
            Size = UDim2.new(1, -48 * Scale, 1, 0),
            Font = Enum.Font.GothamMedium,
            Text = TabName,
            TextColor3 = Theme.TextMuted,
            TextSize = 13 * Scale,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = ZIndex.SidebarContent + 2
        })
        
        -- Active indicator
        local ActiveIndicator = Create("Frame", {
            Name = "Indicator",
            Parent = TabButton,
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(0, 3, 0.6, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            ZIndex = ZIndex.SidebarContent + 3
        }, {Create("UICorner", {CornerRadius = UDim.new(0, 2)})})
        
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
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            ScrollBarImageTransparency = 0.5,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ZIndex = ZIndex.Content,
            BorderSizePixel = 0
        }, {
            Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12 * Scale)}),
            Create("UIPadding", {PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 60 * Scale)})
        })
        
        local RightColumn = Create("ScrollingFrame", {
            Name = "Right",
            Parent = TabPage,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 7 * Scale, 0, 0),
            Size = UDim2.new(0.5, -22 * Scale, 1, -15 * Scale),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            ScrollBarImageTransparency = 0.5,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ZIndex = ZIndex.Content,
            BorderSizePixel = 0
        }, {
            Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12 * Scale)}),
            Create("UIPadding", {PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 60 * Scale)})
        })
        
        TabButton.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 0.85}, TweenPresets.Quick)
                Tween(TabLabel, {TextColor3 = Theme.Text}, TweenPresets.Quick)
                Tween(TabIconImg, {ImageColor3 = Theme.TextSecondary or Theme.Text}, TweenPresets.Quick)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 1}, TweenPresets.Quick)
                Tween(TabLabel, {TextColor3 = Theme.TextMuted}, TweenPresets.Quick)
                Tween(TabIconImg, {ImageColor3 = Theme.TextMuted}, TweenPresets.Quick)
            end
        end)
        
        local function SelectTab()
            -- Close any open dropdown
            if Window.OpenDropdown then
                Window.OpenDropdown:Close()
            end
            
            for _, t in pairs(Window.Tabs) do
                Tween(t.Button, {BackgroundTransparency = 1}, TweenPresets.Normal)
                Tween(t.Label, {TextColor3 = Theme.TextMuted}, TweenPresets.Normal)
                Tween(t.Icon, {ImageColor3 = Theme.TextMuted}, TweenPresets.Normal)
                Tween(t.Indicator, {BackgroundTransparency = 1}, TweenPresets.Normal)
                t.Page.Visible = false
            end
            
            Tween(TabButton, {BackgroundTransparency = 0.7}, TweenPresets.Normal)
            Tween(TabLabel, {TextColor3 = Theme.Text}, TweenPresets.Normal)
            Tween(TabIconImg, {ImageColor3 = Theme.Accent}, TweenPresets.Normal)
            Tween(ActiveIndicator, {BackgroundTransparency = 0}, TweenPresets.Normal)
            TabPage.Visible = true
            TabTitle.Text = TabName
            Window.ActiveTab = Tab
        end
        
        TabButton.MouseButton1Click:Connect(function()
            Ripple(TabButton, Mouse.X, Mouse.Y)
            SelectTab()
        end)
        
        Tab.Button = TabButton
        Tab.Label = TabLabel
        Tab.Icon = TabIconImg
        Tab.Indicator = ActiveIndicator
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
                BackgroundTransparency = Theme.CardTransparency or 0.15,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = ZIndex.Cards,
                ClipsDescendants = false
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
                Create("UIStroke", {Color = Theme.CardBorder, Thickness = 1, Transparency = Theme.CardBorderTransparency or 0.5}),
                Create("UIPadding", {
                    PaddingTop = UDim.new(0, 16 * Scale),
                    PaddingBottom = UDim.new(0, 16 * Scale),
                    PaddingLeft = UDim.new(0, 16 * Scale),
                    PaddingRight = UDim.new(0, 16 * Scale)
                }),
                Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 0)})
            })
            
            -- Section Header
            Create("TextLabel", {
                Name = "Header",
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 22 * Scale),
                Font = Enum.Font.GothamBold,
                Text = SectionName,
                TextColor3 = Theme.Text,
                TextSize = 14 * Scale,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = 0,
                ZIndex = ZIndex.Cards + 1
            })
            
            -- Accent line under header
            Create("Frame", {
                Name = "AccentLine",
                Parent = SectionFrame,
                BackgroundColor3 = Theme.Accent,
                BackgroundTransparency = 0.6,
                Size = UDim2.new(0, 40 * Scale, 0, 2),
                LayoutOrder = 1,
                ZIndex = ZIndex.Cards + 1
            }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
            
            -- Spacer
            Create("Frame", {
                Name = "Spacer",
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 12 * Scale),
                LayoutOrder = 2,
                ZIndex = ZIndex.Cards
            })
            
            local Content = Create("Frame", {
                Name = "Content",
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = 3,
                ZIndex = ZIndex.Cards + 1,
                ClipsDescendants = false
            }, {Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10 * Scale)})})
            
            Section.Frame = SectionFrame
            Section.Content = Content
            
            -- LABEL
            function Section:CreateLabel(opt)
                opt = opt or {}
                local Text = opt.Text or "Label"
                local LabelFrame = Create("Frame", {Name = "Label", Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18 * Scale), ZIndex = ZIndex.Elements})
                local Label = Create("TextLabel", {Name = "Text", Parent = LabelFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.Gotham, Text = Text, TextColor3 = Theme.TextMuted, TextSize = 12 * Scale, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = ZIndex.Elements})
                local obj = {Frame = LabelFrame, Label = Label}
                function obj:Set(t) Label.Text = t end
                return obj
            end
            
            -- TOGGLE
            function Section:CreateToggle(opt)
                opt = opt or {}
                local Name = opt.Name or "Toggle"
                local Default = opt.Default or false
                local Callback = opt.Callback or function() end
                local Flag = opt.Flag
                
                local Frame = Create("Frame", {Name = Name, Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30 * Scale), ZIndex = ZIndex.Elements})
                Create("TextLabel", {Parent = Frame, BackgroundTransparency = 1, Size = UDim2.new(1, -60 * Scale, 1, 0), Font = Enum.Font.Gotham, Text = Name, TextColor3 = Theme.Text, TextSize = 13 * Scale, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = ZIndex.Elements})
                
                local Button = Create("TextButton", {
                    Name = "Toggle", Parent = Frame,
                    BackgroundColor3 = Default and Theme.Toggle or Theme.ToggleOff,
                    BackgroundTransparency = 0.1,
                    Position = UDim2.new(1, -50 * Scale, 0.5, 0),
                    Size = UDim2.new(0, 50 * Scale, 0, 26 * Scale),
                    AnchorPoint = Vector2.new(0, 0.5), Text = "", AutoButtonColor = false,
                    ZIndex = ZIndex.Elements + 1
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
                    Create("UIStroke", {Color = Default and Theme.Accent or Theme.InputBorder, Thickness = 1, Transparency = 0.5})
                })
                
                local Circle = Create("Frame", {
                    Name = "Circle", Parent = Button,
                    BackgroundColor3 = Theme.ToggleKnob or Color3.new(1, 1, 1),
                    BackgroundTransparency = 0,
                    Position = Default and UDim2.new(1, -23 * Scale, 0.5, 0) or UDim2.new(0, 3 * Scale, 0.5, 0),
                    Size = UDim2.new(0, 20 * Scale, 0, 20 * Scale),
                    AnchorPoint = Vector2.new(0, 0.5), ZIndex = ZIndex.Elements + 2
                }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                
                local Value = Default
                local Toggle = {Type = "Toggle", Value = Value, Frame = Frame}
                
                function Toggle:Set(v, skip)
                    Value = v
                    Toggle.Value = v
                    Tween(Button, {BackgroundColor3 = v and Theme.Toggle or Theme.ToggleOff}, TweenPresets.Normal)
                    Tween(Button:FindFirstChild("UIStroke"), {Color = v and Theme.Accent or Theme.InputBorder}, TweenPresets.Normal)
                    Tween(Circle, {Position = v and UDim2.new(1, -23 * Scale, 0.5, 0) or UDim2.new(0, 3 * Scale, 0.5, 0)}, TweenPresets.Bounce)
                    if not skip then Callback(v) end
                end
                
                Button.MouseEnter:Connect(function()
                    Tween(Circle, {Size = UDim2.new(0, 22 * Scale, 0, 22 * Scale)}, TweenPresets.Quick)
                end)
                Button.MouseLeave:Connect(function()
                    Tween(Circle, {Size = UDim2.new(0, 20 * Scale, 0, 20 * Scale)}, TweenPresets.Quick)
                end)
                Button.MouseButton1Click:Connect(function() Toggle:Set(not Value) end)
                
                if Flag then Window.Config:RegisterElement(Flag, Toggle) end
                return Toggle
            end
            
            -- SLIDER
            function Section:CreateSlider(opt)
                opt = opt or {}
                local Name = opt.Name or "Slider"
                local Min = opt.Min or 0
                local Max = opt.Max or 100
                local Default = opt.Default or Min
                local Increment = opt.Increment or 1
                local Callback = opt.Callback or function() end
                local Flag = opt.Flag
                
                local Frame = Create("Frame", {Name = Name, Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 48 * Scale), ZIndex = ZIndex.Elements})
                Create("TextLabel", {Parent = Frame, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, -65 * Scale, 0, 20 * Scale), Font = Enum.Font.Gotham, Text = Name, TextColor3 = Theme.Text, TextSize = 13 * Scale, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = ZIndex.Elements})
                local ValueLabel = Create("TextLabel", {Parent = Frame, BackgroundTransparency = 1, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 60 * Scale, 0, 20 * Scale), AnchorPoint = Vector2.new(1, 0), Font = Enum.Font.GothamBold, Text = tostring(Default), TextColor3 = Theme.Accent, TextSize = 13 * Scale, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = ZIndex.Elements})
                
                local Bg = Create("Frame", {Parent = Frame, BackgroundColor3 = Theme.SliderBg, BackgroundTransparency = 0.3, Position = UDim2.new(0, 0, 0, 30 * Scale), Size = UDim2.new(1, 0, 0, 8 * Scale), ZIndex = ZIndex.Elements}, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                local Fill = Create("Frame", {Parent = Bg, BackgroundColor3 = Theme.SliderFill, BackgroundTransparency = 0.1, Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0), ZIndex = ZIndex.Elements + 1}, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                local Knob = Create("Frame", {Parent = Bg, BackgroundColor3 = Theme.SliderKnob or Color3.new(1, 1, 1), BackgroundTransparency = 0, Position = UDim2.new((Default - Min) / (Max - Min), 0, 0.5, 0), Size = UDim2.new(0, 18 * Scale, 0, 18 * Scale), AnchorPoint = Vector2.new(0.5, 0.5), ZIndex = ZIndex.Elements + 2}, {
                    Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
                    Create("UIStroke", {Color = Theme.Accent, Thickness = 2, Transparency = 0.3})
                })
                
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
                        Tween(Knob, {Size = UDim2.new(0, 22 * Scale, 0, 22 * Scale)}, TweenPresets.Quick)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and Sliding then
                        Sliding = false
                        Tween(Knob, {Size = UDim2.new(0, 18 * Scale, 0, 18 * Scale)}, TweenPresets.Quick)
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
            
            -- DROPDOWN (Inline Expansion)
            function Section:CreateDropdown(opt)
                opt = opt or {}
                local Name = opt.Name or "Dropdown"
                local Items = opt.Items or {}
                local Default = opt.Default or (Items[1] or "")
                local Callback = opt.Callback or function() end
                local Flag = opt.Flag
                local MaxVisible = opt.MaxVisible or 5
                
                local ClosedHeight = 56 * Scale
                local ItemHeight = 32 * Scale
                local ListPadding = 8 * Scale
                
                local Frame = Create("Frame", {
                    Name = Name, 
                    Parent = Content, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(1, 0, 0, ClosedHeight), 
                    ZIndex = ZIndex.Elements,
                    ClipsDescendants = false
                })
                
                Create("TextLabel", {
                    Parent = Frame, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(1, 0, 0, 18 * Scale), 
                    Font = Enum.Font.GothamMedium, 
                    Text = Name, 
                    TextColor3 = Theme.Text, 
                    TextSize = 13 * Scale, 
                    TextXAlignment = Enum.TextXAlignment.Left, 
                    ZIndex = ZIndex.Elements
                })
                
                local Button = Create("TextButton", {
                    Name = "DropdownButton",
                    Parent = Frame, 
                    BackgroundColor3 = Theme.Input,
                    BackgroundTransparency = Theme.InputTransparency or 0.3,
                    Position = UDim2.new(0, 0, 0, 22 * Scale), 
                    Size = UDim2.new(1, 0, 0, 32 * Scale),
                    Text = "", 
                    AutoButtonColor = false, 
                    ZIndex = ZIndex.Elements + 1
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(0, 8)}), 
                    Create("UIStroke", {Color = Theme.InputBorder, Thickness = 1, Transparency = 0.5})
                })
                
                local Selected = Create("TextLabel", {
                    Parent = Button, 
                    BackgroundTransparency = 1, 
                    Position = UDim2.new(0, 12 * Scale, 0, 0), 
                    Size = UDim2.new(1, -40 * Scale, 1, 0), 
                    Font = Enum.Font.Gotham, 
                    Text = Default, 
                    TextColor3 = Theme.Text, 
                    TextSize = 12 * Scale, 
                    TextXAlignment = Enum.TextXAlignment.Left, 
                    ZIndex = ZIndex.Elements + 2
                })
                
                local Arrow = Create("TextLabel", {
                    Parent = Button, 
                    BackgroundTransparency = 1, 
                    Position = UDim2.new(1, -28 * Scale, 0.5, 0), 
                    Size = UDim2.new(0, 16 * Scale, 0, 16 * Scale), 
                    AnchorPoint = Vector2.new(0, 0.5), 
                    Font = Enum.Font.GothamBold, 
                    Text = "▼", 
                    TextColor3 = Theme.TextMuted, 
                    TextSize = 10 * Scale, 
                    ZIndex = ZIndex.Elements + 2
                })
                
                local ListContainer = Create("Frame", {
                    Name = "ListContainer",
                    Parent = Frame,
                    BackgroundColor3 = Theme.DropdownBg or Theme.Card,
                    BackgroundTransparency = 0.05,
                    Position = UDim2.new(0, 0, 0, 56 * Scale),
                    Size = UDim2.new(1, 0, 0, 0),
                    ClipsDescendants = true,
                    Visible = false,
                    ZIndex = ZIndex.Dropdown
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                    Create("UIStroke", {Color = Theme.DropdownBorder or Theme.CardBorder, Thickness = 1, Transparency = 0.4})
                })
                
                local Scroll = Create("ScrollingFrame", {
                    Name = "Scroll",
                    Parent = ListContainer,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarThickness = 3,
                    ScrollBarImageColor3 = Theme.Accent,
                    ScrollBarImageTransparency = 0.5,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    ZIndex = ZIndex.DropdownItems
                }, {
                    Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2 * Scale)}),
                    Create("UIPadding", {
                        PaddingTop = UDim.new(0, 6 * Scale), 
                        PaddingBottom = UDim.new(0, 6 * Scale), 
                        PaddingLeft = UDim.new(0, 6 * Scale), 
                        PaddingRight = UDim.new(0, 6 * Scale)
                    })
                })
                
                local Value = Default
                local Open = false
                local Dropdown = {Type = "Dropdown", Value = Value, Frame = Frame}
                
                local function GetListHeight()
                    local itemCount = math.min(#Items, MaxVisible)
                    return itemCount * (ItemHeight + 2 * Scale) + ListPadding * 2
                end
                
                local function GetOpenHeight()
                    return ClosedHeight + GetListHeight() + 4 * Scale
                end
                
                local function CreateOption(item)
                    local Opt = Create("TextButton", {
                        Name = item, 
                        Parent = Scroll, 
                        BackgroundColor3 = Theme.DropdownItem or Theme.CardHover,
                        BackgroundTransparency = 1, 
                        Size = UDim2.new(1, 0, 0, ItemHeight - 4 * Scale),
                        Text = "", 
                        AutoButtonColor = false, 
                        ZIndex = ZIndex.DropdownItems
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                        Create("TextLabel", {
                            Name = "Label",
                            BackgroundTransparency = 1, 
                            Position = UDim2.new(0, 10 * Scale, 0, 0), 
                            Size = UDim2.new(1, -20 * Scale, 1, 0), 
                            Font = Enum.Font.Gotham, 
                            Text = item, 
                            TextColor3 = Theme.Text, 
                            TextSize = 12 * Scale, 
                            TextXAlignment = Enum.TextXAlignment.Left, 
                            ZIndex = ZIndex.DropdownItems + 1
                        })
                    })
                    
                    local Check = Create("TextLabel", {
                        Name = "Check",
                        Parent = Opt,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, -24 * Scale, 0.5, 0),
                        Size = UDim2.new(0, 14 * Scale, 0, 14 * Scale),
                        AnchorPoint = Vector2.new(0, 0.5),
                        Font = Enum.Font.GothamBold,
                        Text = "✓",
                        TextColor3 = Theme.Accent,
                        TextSize = 12 * Scale,
                        Visible = item == Value,
                        ZIndex = ZIndex.DropdownItems + 1
                    })
                    
                    Opt.MouseEnter:Connect(function() 
                        Tween(Opt, {BackgroundTransparency = 0.3}, TweenPresets.Quick)
                        Tween(Opt:FindFirstChild("Label"), {TextColor3 = Theme.Accent}, TweenPresets.Quick)
                    end)
                    Opt.MouseLeave:Connect(function() 
                        Tween(Opt, {BackgroundTransparency = 1}, TweenPresets.Quick)
                        Tween(Opt:FindFirstChild("Label"), {TextColor3 = Theme.Text}, TweenPresets.Quick)
                    end)
                    Opt.MouseButton1Click:Connect(function()
                        Dropdown:Set(item)
                        Dropdown:Close()
                    end)
                    
                    return Opt
                end
                
                function Dropdown:Close()
                    if not Open then return end
                    Open = false
                    if Window.OpenDropdown == Dropdown then Window.OpenDropdown = nil end
                    
                    Tween(Arrow, {Rotation = 0, TextColor3 = Theme.TextMuted}, TweenPresets.Normal)
                    Tween(Button:FindFirstChild("UIStroke"), {Color = Theme.InputBorder}, TweenPresets.Quick)
                    Tween(Button, {BackgroundTransparency = Theme.InputTransparency or 0.3}, TweenPresets.Quick)
                    Tween(ListContainer, {Size = UDim2.new(1, 0, 0, 0)}, TweenPresets.Dropdown)
                    Tween(Frame, {Size = UDim2.new(1, 0, 0, ClosedHeight)}, TweenPresets.Dropdown)
                    
                    task.delay(0.3, function()
                        if not Open then
                            ListContainer.Visible = false
                        end
                    end)
                end
                
                function Dropdown:OpenDropdown()
                    if Window.OpenDropdown and Window.OpenDropdown ~= Dropdown then
                        Window.OpenDropdown:Close()
                    end
                    Open = true
                    Window.OpenDropdown = Dropdown
                    ListContainer.Visible = true
                    
                    Tween(Arrow, {Rotation = 180, TextColor3 = Theme.Accent}, TweenPresets.Normal)
                    Tween(Button:FindFirstChild("UIStroke"), {Color = Theme.Accent}, TweenPresets.Quick)
                    Tween(Button, {BackgroundTransparency = 0.1}, TweenPresets.Quick)
                    
                    local listHeight = GetListHeight()
                    Tween(ListContainer, {Size = UDim2.new(1, 0, 0, listHeight)}, TweenPresets.Dropdown)
                    Tween(Frame, {Size = UDim2.new(1, 0, 0, GetOpenHeight())}, TweenPresets.Dropdown)
                end
                
                for _, item in ipairs(Items) do CreateOption(item) end
                
                function Dropdown:Set(v, skip)
                    Value = v
                    Dropdown.Value = v
                    Selected.Text = v
                    
                    for _, child in pairs(Scroll:GetChildren()) do
                        if child:IsA("TextButton") then
                            local check = child:FindFirstChild("Check")
                            if check then
                                check.Visible = child.Name == v
                            end
                        end
                    end
                    
                    if not skip then Callback(v) end
                end
                
                function Dropdown:Refresh(newItems)
                    for _, c in pairs(Scroll:GetChildren()) do 
                        if c:IsA("TextButton") then c:Destroy() end 
                    end
                    Items = newItems
                    for _, item in ipairs(Items) do CreateOption(item) end
                    
                    if Open then
                        local listHeight = GetListHeight()
                        ListContainer.Size = UDim2.new(1, 0, 0, listHeight)
                        Frame.Size = UDim2.new(1, 0, 0, GetOpenHeight())
                    end
                end
                
                Button.MouseEnter:Connect(function()
                    if not Open then
                        Tween(Button:FindFirstChild("UIStroke"), {Color = Theme.TextMuted}, TweenPresets.Quick)
                        Tween(Arrow, {TextColor3 = Theme.Text}, TweenPresets.Quick)
                        Tween(Button, {BackgroundTransparency = 0.15}, TweenPresets.Quick)
                    end
                end)
                Button.MouseLeave:Connect(function()
                    if not Open then
                        Tween(Button:FindFirstChild("UIStroke"), {Color = Theme.InputBorder}, TweenPresets.Quick)
                        Tween(Arrow, {TextColor3 = Theme.TextMuted}, TweenPresets.Quick)
                        Tween(Button, {BackgroundTransparency = Theme.InputTransparency or 0.3}, TweenPresets.Quick)
                    end
                end)
                
                Button.MouseButton1Click:Connect(function()
                    if Open then 
                        Dropdown:Close() 
                    else 
                        Dropdown:OpenDropdown() 
                    end
                end)
                
                local clickConnection
                clickConnection = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and Open then
                        local mousePos = UserInputService:GetMouseLocation()
                        local framePos = Frame.AbsolutePosition
                        local frameSize = Frame.AbsoluteSize
                        
                        local inFrame = mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X and
                                       mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y
                        
                        if not inFrame then
                            task.defer(function() Dropdown:Close() end)
                        end
                    end
                end)
                
                Frame.Destroying:Connect(function()
                    if clickConnection then clickConnection:Disconnect() end
                    if Window.OpenDropdown == Dropdown then Window.OpenDropdown = nil end
                end)
                
                if Flag then Window.Config:RegisterElement(Flag, Dropdown) end
                return Dropdown
            end
            
            -- BUTTON
            function Section:CreateButton(opt)
                opt = opt or {}
                local Name = opt.Name or "Button"
                local Callback = opt.Callback or function() end
                
                local Frame = Create("Frame", {Name = Name, Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 36 * Scale), ZIndex = ZIndex.Elements, ClipsDescendants = true})
                local Btn = Create("TextButton", {
                    Parent = Frame, 
                    BackgroundColor3 = Theme.Accent, 
                    BackgroundTransparency = 0.15,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.GothamMedium, 
                    Text = Name, 
                    TextColor3 = Color3.new(1, 1, 1),
                    TextSize = 13 * Scale, 
                    AutoButtonColor = false, 
                    ZIndex = ZIndex.Elements + 1, 
                    ClipsDescendants = true
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                    Create("UIStroke", {Color = Theme.AccentHover or Theme.Accent, Thickness = 1, Transparency = 0.6})
                })
                
                Btn.MouseEnter:Connect(function() 
                    Tween(Btn, {BackgroundTransparency = 0, BackgroundColor3 = Theme.AccentHover or Theme.Accent}, TweenPresets.Quick) 
                end)
                Btn.MouseLeave:Connect(function() 
                    Tween(Btn, {BackgroundTransparency = 0.15, BackgroundColor3 = Theme.Accent}, TweenPresets.Quick) 
                end)
                Btn.MouseButton1Click:Connect(function()
                    Ripple(Btn, Mouse.X, Mouse.Y)
                    Tween(Btn, {BackgroundColor3 = Theme.AccentDark}, TweenPresets.Quick)
                    task.wait(0.1)
                    Tween(Btn, {BackgroundColor3 = Theme.Accent}, TweenPresets.Quick)
                    Callback()
                end)
                return {Frame = Frame, Button = Btn}
            end
            
            -- INPUT
            function Section:CreateInput(opt)
                opt = opt or {}
                local Name = opt.Name or "Input"
                local Placeholder = opt.Placeholder or "Enter text..."
                local Default = opt.Default or ""
                local Callback = opt.Callback or function() end
                local Flag = opt.Flag
                
                local Frame = Create("Frame", {Name = Name, Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 56 * Scale), ZIndex = ZIndex.Elements})
                Create("TextLabel", {Parent = Frame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18 * Scale), Font = Enum.Font.GothamMedium, Text = Name, TextColor3 = Theme.Text, TextSize = 13 * Scale, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = ZIndex.Elements})
                
                local Box = Create("TextBox", {
                    Parent = Frame, 
                    BackgroundColor3 = Theme.Input,
                    BackgroundTransparency = Theme.InputTransparency or 0.3,
                    Position = UDim2.new(0, 0, 0, 22 * Scale), 
                    Size = UDim2.new(1, 0, 0, 32 * Scale),
                    Font = Enum.Font.Gotham, 
                    PlaceholderText = Placeholder, 
                    PlaceholderColor3 = Theme.TextMuted,
                    Text = Default, 
                    TextColor3 = Theme.Text, 
                    TextSize = 12 * Scale, 
                    ClearTextOnFocus = false, 
                    ZIndex = ZIndex.Elements + 1
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(0, 8)}), 
                    Create("UIStroke", {Color = Theme.InputBorder, Thickness = 1, Transparency = 0.5}), 
                    Create("UIPadding", {PaddingLeft = UDim.new(0, 12 * Scale), PaddingRight = UDim.new(0, 12 * Scale)})
                })
                
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
                    Tween(Box, {BackgroundTransparency = 0.1}, TweenPresets.Quick)
                end)
                Box.FocusLost:Connect(function()
                    Tween(Box:FindFirstChild("UIStroke"), {Color = Theme.InputBorder, Transparency = 0.5}, TweenPresets.Quick)
                    Tween(Box, {BackgroundTransparency = Theme.InputTransparency or 0.3}, TweenPresets.Quick)
                    Value = Box.Text
                    Input.Value = Value
                    Callback(Value)
                end)
                
                if Flag then Window.Config:RegisterElement(Flag, Input) end
                return Input
            end
            
            -- KEYBIND
            function Section:CreateKeybind(opt)
                opt = opt or {}
                local Name = opt.Name or "Keybind"
                local Default = opt.Default or Enum.KeyCode.Unknown
                local Callback = opt.Callback or function() end
                local Flag = opt.Flag
                
                local Frame = Create("Frame", {Name = Name, Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30 * Scale), ZIndex = ZIndex.Elements})
                Create("TextLabel", {Parent = Frame, BackgroundTransparency = 1, Size = UDim2.new(1, -75 * Scale, 1, 0), Font = Enum.Font.Gotham, Text = Name, TextColor3 = Theme.Text, TextSize = 13 * Scale, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = ZIndex.Elements})
                
                local Btn = Create("TextButton", {
                    Parent = Frame, 
                    BackgroundColor3 = Theme.Input,
                    BackgroundTransparency = Theme.InputTransparency or 0.3,
                    Position = UDim2.new(1, -70 * Scale, 0.5, 0), 
                    Size = UDim2.new(0, 70 * Scale, 0, 26 * Scale),
                    AnchorPoint = Vector2.new(0, 0.5), 
                    Font = Enum.Font.GothamMedium, 
                    Text = Default.Name or "None",
                    TextColor3 = Theme.Text, 
                    TextSize = 11 * Scale, 
                    AutoButtonColor = false, 
                    ZIndex = ZIndex.Elements + 1
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(0, 6)}), 
                    Create("UIStroke", {Color = Theme.InputBorder, Thickness = 1, Transparency = 0.5})
                })
                
                local Value = Default
                local Listening = false
                local Keybind = {Type = "Keybind", Value = Value, Frame = Frame}
                
                function Keybind:Set(k)
                    Value = k
                    Keybind.Value = k
                    Btn.Text = k.Name or "None"
                end
                
                Btn.MouseButton1Click:Connect(function()
                    Listening = true
                    Btn.Text = "..."
                    Tween(Btn:FindFirstChild("UIStroke"), {Color = Theme.Accent, Transparency = 0}, TweenPresets.Quick)
                end)
                
                UserInputService.InputBegan:Connect(function(input, processed)
                    if Listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        Listening = false
                        Keybind:Set(input.KeyCode)
                        Tween(Btn:FindFirstChild("UIStroke"), {Color = Theme.InputBorder, Transparency = 0.5}, TweenPresets.Quick)
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
            TabButton.BackgroundTransparency = 0.7
            TabLabel.TextColor3 = Theme.Text
            TabIconImg.ImageColor3 = Theme.Accent
            ActiveIndicator.BackgroundTransparency = 0
            TabPage.Visible = true
            TabTitle.Text = TabName
            Window.ActiveTab = Tab
        end
        return Tab
    end
    
    -- CONFIG TAB
    function Window:CreateConfigTab()
        local ConfigTab = Window:CreateTab({Name = "Configs", Icon = "rbxassetid://7072719587"})
        local ConfigSection = ConfigTab:CreateSection({Name = "Configuration", Side = "Left"})
        local InfoSection = ConfigTab:CreateSection({Name = "Info", Side = "Right"})
        
        local CurrentConfigs = Window.Config:GetConfigs()
        local SubFolders = Window.Config:GetAllSubFolders()
        
        local ConfigNameInput = ConfigSection:CreateInput({
            Name = "Config Name", 
            Placeholder = "Enter config name...", 
            Callback = function() end
        })
        
        local SubFolderDropdown
        if #SubFolders > 0 then
            local folderItems = {"Main Folder"}
            for _, folder in ipairs(SubFolders) do
                table.insert(folderItems, folder)
            end
            
            SubFolderDropdown = ConfigSection:CreateDropdown({
                Name = "Game/Category",
                Items = folderItems,
                Default = Window.Config.SubFolder or "Main Folder",
                Callback = function(value)
                    if value == "Main Folder" then
                        Window.Config:SetSubFolder(nil)
                    else
                        Window.Config:SetSubFolder(value)
                    end
                    local newConfigs = Window.Config:GetConfigs()
                    ConfigDropdown:Refresh(newConfigs)
                end
            })
        end
        
        local ConfigDropdown = ConfigSection:CreateDropdown({
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
        
        InfoSection:CreateLabel({Text = "Main Folder: " .. Window.Config.MainFolder})
        InfoSection:CreateLabel({Text = "SubFolder: " .. (Window.Config.SubFolder or "None")})
        InfoSection:CreateLabel({Text = "Total Configs: " .. #CurrentConfigs})
        
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

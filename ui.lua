local AstraLib = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
print("V23")
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


local Tweens = {
    Quick = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Normal = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
}

local function Create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do if k ~= "Parent" then inst[k] = v end end
    for _, c in pairs(children or {}) do c.Parent = inst end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Tween(inst, props, info)
    local t = TweenService:Create(inst, info or Tweens.Normal, props)
    t:Play()
    return t
end

local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function GetScale()
    return IsMobile() and math.clamp(workspace.CurrentCamera.ViewportSize.X / 1200, 0.5, 1) or 1
end

local function HSVToRGB(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p, q, t = v * (1 - s), v * (1 - f * s), v * (1 - (1 - f) * s)
    i = i % 6
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    else r, g, b = v, p, q end
    return Color3.new(r, g, b)
end

local function RGBToHSV(c)
    local r, g, b = c.R, c.G, c.B
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local h, s, v = 0, 0, max
    local d = max - min
    s = max == 0 and 0 or d / max
    if max ~= min then
        if max == r then h = (g - b) / d + (g < b and 6 or 0)
        elseif max == g then h = (b - r) / d + 2
        else h = (r - g) / d + 4 end
        h = h / 6
    end
    return h, s, v
end

local Themes = {
    Dark = {
        Background = Color3.fromRGB(15, 12, 20), Sidebar = Color3.fromRGB(18, 15, 25),
        Card = Color3.fromRGB(22, 18, 32), CardTransparency = 0.25,
        CardBorder = Color3.fromRGB(55, 45, 75), CardHover = Color3.fromRGB(32, 26, 45),
        Text = Color3.fromRGB(255, 255, 255), TextMuted = Color3.fromRGB(145, 135, 165),
        Accent = Color3.fromRGB(138, 92, 220), AccentHover = Color3.fromRGB(155, 110, 235),
        AccentDark = Color3.fromRGB(110, 70, 180), Toggle = Color3.fromRGB(138, 92, 220),
        ToggleOff = Color3.fromRGB(45, 40, 58), SliderFill = Color3.fromRGB(138, 92, 220),
        SliderBg = Color3.fromRGB(35, 30, 48), Input = Color3.fromRGB(25, 20, 35),
        InputTransparency = 0.4, InputBorder = Color3.fromRGB(60, 50, 80),
        InputFocus = Color3.fromRGB(138, 92, 220), Shadow = Color3.fromRGB(0, 0, 0),
        Success = Color3.fromRGB(34, 197, 94), Error = Color3.fromRGB(239, 68, 68),
    },
    Midnight = {
        Background = Color3.fromRGB(8, 8, 18), Sidebar = Color3.fromRGB(12, 12, 25),
        Card = Color3.fromRGB(18, 18, 35), CardTransparency = 0.3,
        CardBorder = Color3.fromRGB(40, 40, 70), CardHover = Color3.fromRGB(28, 28, 50),
        Text = Color3.fromRGB(220, 220, 255), TextMuted = Color3.fromRGB(110, 110, 150),
        Accent = Color3.fromRGB(130, 85, 210), AccentHover = Color3.fromRGB(150, 105, 230),
        AccentDark = Color3.fromRGB(100, 65, 170), Toggle = Color3.fromRGB(130, 85, 210),
        ToggleOff = Color3.fromRGB(40, 40, 60), SliderFill = Color3.fromRGB(130, 85, 210),
        SliderBg = Color3.fromRGB(30, 30, 50), Input = Color3.fromRGB(20, 20, 38),
        InputTransparency = 0.45, InputBorder = Color3.fromRGB(50, 50, 80),
        InputFocus = Color3.fromRGB(130, 85, 210), Shadow = Color3.fromRGB(0, 0, 0),
        Success = Color3.fromRGB(34, 197, 94), Error = Color3.fromRGB(239, 68, 68),
    },
    Ocean = {
        Background = Color3.fromRGB(8, 15, 28), Sidebar = Color3.fromRGB(10, 20, 35),
        Card = Color3.fromRGB(15, 28, 48), CardTransparency = 0.3,
        CardBorder = Color3.fromRGB(35, 60, 95), CardHover = Color3.fromRGB(22, 40, 65),
        Text = Color3.fromRGB(220, 240, 255), TextMuted = Color3.fromRGB(100, 145, 180),
        Accent = Color3.fromRGB(100, 140, 220), AccentHover = Color3.fromRGB(120, 160, 240),
        AccentDark = Color3.fromRGB(70, 110, 180), Toggle = Color3.fromRGB(100, 140, 220),
        ToggleOff = Color3.fromRGB(28, 50, 75), SliderFill = Color3.fromRGB(100, 140, 220),
        SliderBg = Color3.fromRGB(22, 42, 68), Input = Color3.fromRGB(12, 25, 45),
        InputTransparency = 0.45, InputBorder = Color3.fromRGB(40, 70, 105),
        InputFocus = Color3.fromRGB(100, 140, 220), Shadow = Color3.fromRGB(0, 0, 0),
        Success = Color3.fromRGB(34, 197, 94), Error = Color3.fromRGB(239, 68, 68),
    },
    Purple = {
        Background = Color3.fromRGB(12, 8, 22), Sidebar = Color3.fromRGB(18, 12, 32),
        Card = Color3.fromRGB(28, 20, 48), CardTransparency = 0.3,
        CardBorder = Color3.fromRGB(60, 45, 90), CardHover = Color3.fromRGB(40, 30, 65),
        Text = Color3.fromRGB(240, 230, 255), TextMuted = Color3.fromRGB(145, 130, 175),
        Accent = Color3.fromRGB(160, 100, 240), AccentHover = Color3.fromRGB(180, 120, 255),
        AccentDark = Color3.fromRGB(130, 75, 200), Toggle = Color3.fromRGB(160, 100, 240),
        ToggleOff = Color3.fromRGB(50, 38, 72), SliderFill = Color3.fromRGB(160, 100, 240),
        SliderBg = Color3.fromRGB(42, 32, 65), Input = Color3.fromRGB(25, 18, 42),
        InputTransparency = 0.45, InputBorder = Color3.fromRGB(70, 52, 100),
        InputFocus = Color3.fromRGB(160, 100, 240), Shadow = Color3.fromRGB(0, 0, 0),
        Success = Color3.fromRGB(34, 197, 94), Error = Color3.fromRGB(239, 68, 68),
    },
    Emerald = {
        Background = Color3.fromRGB(8, 15, 12), Sidebar = Color3.fromRGB(10, 22, 18),
        Card = Color3.fromRGB(15, 32, 26), CardTransparency = 0.3,
        CardBorder = Color3.fromRGB(35, 70, 58), CardHover = Color3.fromRGB(22, 45, 38),
        Text = Color3.fromRGB(220, 255, 245), TextMuted = Color3.fromRGB(105, 160, 145),
        Accent = Color3.fromRGB(52, 211, 153), AccentHover = Color3.fromRGB(72, 231, 173),
        AccentDark = Color3.fromRGB(32, 180, 130), Toggle = Color3.fromRGB(52, 211, 153),
        ToggleOff = Color3.fromRGB(30, 55, 48), SliderFill = Color3.fromRGB(52, 211, 153),
        SliderBg = Color3.fromRGB(25, 48, 40), Input = Color3.fromRGB(12, 28, 22),
        InputTransparency = 0.45, InputBorder = Color3.fromRGB(40, 80, 65),
        InputFocus = Color3.fromRGB(52, 211, 153), Shadow = Color3.fromRGB(0, 0, 0),
        Success = Color3.fromRGB(34, 197, 94), Error = Color3.fromRGB(239, 68, 68),
    },
    Rose = {
        Background = Color3.fromRGB(18, 10, 15), Sidebar = Color3.fromRGB(25, 15, 20),
        Card = Color3.fromRGB(38, 22, 30), CardTransparency = 0.3,
        CardBorder = Color3.fromRGB(75, 48, 60), CardHover = Color3.fromRGB(52, 32, 42),
        Text = Color3.fromRGB(255, 235, 245), TextMuted = Color3.fromRGB(170, 135, 150),
        Accent = Color3.fromRGB(244, 114, 182), AccentHover = Color3.fromRGB(255, 134, 202),
        AccentDark = Color3.fromRGB(220, 90, 160), Toggle = Color3.fromRGB(244, 114, 182),
        ToggleOff = Color3.fromRGB(62, 42, 52), SliderFill = Color3.fromRGB(244, 114, 182),
        SliderBg = Color3.fromRGB(55, 35, 45), Input = Color3.fromRGB(32, 18, 25),
        InputTransparency = 0.45, InputBorder = Color3.fromRGB(88, 55, 68),
        InputFocus = Color3.fromRGB(244, 114, 182), Shadow = Color3.fromRGB(0, 0, 0),
        Success = Color3.fromRGB(34, 197, 94), Error = Color3.fromRGB(239, 68, 68),
    },
}

local ConfigSystem = {}
ConfigSystem.__index = ConfigSystem

function ConfigSystem.new(folder)
    local self = setmetatable({}, ConfigSystem)
    self.Folder = folder or "AstraLib"
    self.Elements = {}
    pcall(function() if not isfolder(self.Folder) then makefolder(self.Folder) end end)
    return self
end

function ConfigSystem:Register(id, elem) self.Elements[id] = elem end

function ConfigSystem:GetConfigs()
    local list = {}
    pcall(function()
        if isfolder(self.Folder) then
            for _, f in pairs(listfiles(self.Folder)) do
                local n = f:match("([^/\\]+)%.json$")
                if n then table.insert(list, n) end
            end
        end
    end)
    return list
end

function ConfigSystem:Save(name)
    local data = {}
    for id, e in pairs(self.Elements) do
        if e.Type == "Toggle" or e.Type == "Slider" or e.Type == "Dropdown" or e.Type == "Input" or e.Type == "TextInput" then
            data[id] = e.Value
        elseif e.Type == "Keybind" then
            data[id] = e.Value.Name
        elseif e.Type == "ColorPicker" then
            data[id] = {R = math.floor(e.Value.R * 255), G = math.floor(e.Value.G * 255), B = math.floor(e.Value.B * 255)}
        end
    end
    pcall(function() writefile(self.Folder .. "/" .. name .. ".json", HttpService:JSONEncode(data)) end)
end

function ConfigSystem:Load(name)
    pcall(function()
        local path = self.Folder .. "/" .. name .. ".json"
        if isfile(path) then
            local data = HttpService:JSONDecode(readfile(path))
            for id, v in pairs(data) do
                local e = self.Elements[id]
                if e then
                    if e.Type == "ColorPicker" then e:Set(Color3.fromRGB(v.R, v.G, v.B))
                    elseif e.Type == "Keybind" then e:Set(Enum.KeyCode[v])
                    else e:Set(v) end
                end
            end
        end
    end)
end

function ConfigSystem:Delete(name)
    pcall(function()
        local path = self.Folder .. "/" .. name .. ".json"
        if isfile(path) then delfile(path) end
    end)
end

function AstraLib:CreateWindow(opts)
    opts = opts or {}
    local Title = opts.Title or "Nova Hub"
    local Version = opts.Version or "v1.0"
    local ThemeName = opts.Theme or "Dark"
    local ConfigFolder = opts.ConfigFolder or "NovaHub"
    local DefaultTab = opts.DefaultTab
    local MinimizeKey = opts.MinimizeKey or Enum.KeyCode.LeftControl

    local Theme = Themes[ThemeName] or Themes.Dark
    local Window = {Tabs = {}, ActiveTab = nil, Theme = Theme, Open = true, Config = ConfigSystem.new(ConfigFolder)}
    local Scale = GetScale()

    if CoreGui:FindFirstChild("AstraLib") then CoreGui:FindFirstChild("AstraLib"):Destroy() end

    local Gui = Create("ScreenGui", {Name = "AstraLib", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Global, ResetOnSpawn = false, IgnoreGuiInset = true})

    local MobileBtn = Create("ImageButton", {
        Name = "Mobile", Parent = Gui, BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.15,
        Position = UDim2.new(0, 15, 0.5, -25), Size = UDim2.new(0, 50, 0, 50), Visible = IsMobile(),
        ZIndex = ZIndex.MobileButton, Image = "rbxassetid://7072718362", ImageColor3 = Color3.new(1,1,1), AutoButtonColor = false
    }, {Create("UICorner", {CornerRadius = UDim.new(0, 25)})})

    MobileBtn.MouseEnter:Connect(function() Tween(MobileBtn, {BackgroundColor3 = Theme.AccentHover}, Tweens.Quick) end)
    MobileBtn.MouseLeave:Connect(function() Tween(MobileBtn, {BackgroundColor3 = Theme.Accent}, Tweens.Quick) end)

    local Container = Create("Frame", {
        Name = "Container", Parent = Gui, BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 900 * Scale, 0, 600 * Scale),
        AnchorPoint = Vector2.new(0.5, 0.5), ZIndex = ZIndex.Background
    })

    local Main = Create("Frame", {
        Name = "Main", Parent = Container, BackgroundColor3 = Theme.Background, BackgroundTransparency = 0.08,
        Size = UDim2.new(1, 0, 1, 0), ClipsDescendants = true, ZIndex = ZIndex.Background
    }, {Create("UICorner", {CornerRadius = UDim.new(0, 12)}), Create("UIStroke", {Color = Theme.CardBorder, Thickness = 1, Transparency = 0.4})})

    Create("ImageLabel", {
        Name = "Shadow", Parent = Main, BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(1, 80, 1, 80),
        AnchorPoint = Vector2.new(0.5, 0.5), ZIndex = ZIndex.Shadow,
        Image = "rbxassetid://6014261993", ImageColor3 = Theme.Shadow, ImageTransparency = 0.55,
        ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450)
    })

    local Sidebar = Create("Frame", {
        Name = "Sidebar", Parent = Main, BackgroundColor3 = Theme.Sidebar, BackgroundTransparency = 0.15,
        Size = UDim2.new(0, 200 * Scale, 1, 0), ZIndex = ZIndex.Sidebar, ClipsDescendants = true
    }, {Create("UICorner", {CornerRadius = UDim.new(0, 12)})})

    Create("Frame", {Name = "Fix", Parent = Sidebar, BackgroundColor3 = Theme.Sidebar, BackgroundTransparency = 0.15, Position = UDim2.new(1, -12, 0, 0), Size = UDim2.new(0, 14, 1, 0), BorderSizePixel = 0, ZIndex = ZIndex.Sidebar + 1})
    Create("Frame", {Name = "Divider", Parent = Main, BackgroundColor3 = Color3.new(1,1,1), BackgroundTransparency = 0.88, Position = UDim2.new(0, 200 * Scale, 0, 0), Size = UDim2.new(0, 1, 1, 0), BorderSizePixel = 0, ZIndex = ZIndex.Sidebar + 2})

    Create("TextLabel", {Name = "Title", Parent = Sidebar, BackgroundTransparency = 1, Position = UDim2.new(0, 20 * Scale, 0, 18 * Scale), Size = UDim2.new(1, -40 * Scale, 0, 24 * Scale), Font = Enum.Font.GothamBold, Text = Title, TextColor3 = Theme.Text, TextSize = 18 * Scale, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = ZIndex.SidebarContent})
    Create("TextLabel", {Name = "Ver", Parent = Sidebar, BackgroundTransparency = 1, Position = UDim2.new(1, -55 * Scale, 0, 22 * Scale), Size = UDim2.new(0, 40 * Scale, 0, 16 * Scale), Font = Enum.Font.Gotham, Text = Version, TextColor3 = Theme.TextMuted, TextSize = 12 * Scale, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = ZIndex.SidebarContent})
    Create("TextLabel", {Name = "Nav", Parent = Sidebar, BackgroundTransparency = 1, Position = UDim2.new(0, 20 * Scale, 0, 60 * Scale), Size = UDim2.new(1, -40 * Scale, 0, 20 * Scale), Font = Enum.Font.Gotham, Text = "NAVIGATION", TextColor3 = Theme.TextMuted, TextSize = 10 * Scale, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = ZIndex.SidebarContent})

    local TabList = Create("ScrollingFrame", {
        Name = "Tabs", Parent = Sidebar, BackgroundTransparency = 1, Position = UDim2.new(0, 10 * Scale, 0, 85 * Scale),
        Size = UDim2.new(1, -20 * Scale, 1, -155 * Scale), CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent, AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = ZIndex.SidebarContent, BorderSizePixel = 0
    }, {Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4 * Scale)}), Create("UIPadding", {PaddingRight = UDim.new(0, 5)})})

    local UserFrame = Create("Frame", {Name = "User", Parent = Sidebar, BackgroundTransparency = 1, Position = UDim2.new(0, 10 * Scale, 1, -60 * Scale), Size = UDim2.new(1, -20 * Scale, 0, 50 * Scale), ZIndex = ZIndex.SidebarContent})
    Create("ImageLabel", {Name = "Avatar", Parent = UserFrame, BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.5, Position = UDim2.new(0, 5 * Scale, 0.5, 0), Size = UDim2.new(0, 40 * Scale, 0, 40 * Scale), AnchorPoint = Vector2.new(0, 0.5), Image = "rbxthumb://type=AvatarHeadShot&id=" .. Player.UserId .. "&w=150&h=150", ZIndex = ZIndex.SidebarContent + 1}, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
    Create("TextLabel", {Name = "Name", Parent = UserFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 55 * Scale, 0, 8 * Scale), Size = UDim2.new(1, -65 * Scale, 0, 16 * Scale), Font = Enum.Font.GothamMedium, Text = Player.Name, TextColor3 = Theme.Text, TextSize = 13 * Scale, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = ZIndex.SidebarContent})
    Create("TextLabel", {Name = "Display", Parent = UserFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 55 * Scale, 0, 26 * Scale), Size = UDim2.new(1, -65 * Scale, 0, 14 * Scale), Font = Enum.Font.Gotham, Text = Player.DisplayName, TextColor3 = Theme.TextMuted, TextSize = 11 * Scale, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = ZIndex.SidebarContent})

    local ContentArea = Create("Frame", {Name = "Content", Parent = Main, BackgroundTransparency = 1, Position = UDim2.new(0, 200 * Scale, 0, 0), Size = UDim2.new(1, -200 * Scale, 1, 0), ZIndex = ZIndex.Content})

    local TopBar = Create("Frame", {Name = "TopBar", Parent = ContentArea, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 50 * Scale), ZIndex = ZIndex.TopBar})
    Create("TextLabel", {Name = "Ver", Parent = TopBar, BackgroundTransparency = 1, Position = UDim2.new(0, 20 * Scale, 0.5, 0), Size = UDim2.new(0, 100 * Scale, 0, 20 * Scale), AnchorPoint = Vector2.new(0, 0.5), Font = Enum.Font.Gotham, Text = Version, TextColor3 = Theme.TextMuted, TextSize = 12 * Scale, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = ZIndex.TopBar})

    local TopIcons = Create("Frame", {Name = "Icons", Parent = TopBar, BackgroundTransparency = 1, Position = UDim2.new(1, -20 * Scale, 0.5, 0), Size = UDim2.new(0, 100 * Scale, 0, 30 * Scale), AnchorPoint = Vector2.new(1, 0.5), ZIndex = ZIndex.TopBar}, {Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 10 * Scale)})})

    local MinBtn = Create("TextButton", {Name = "Min", Parent = TopIcons, BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.25, Size = UDim2.new(0, 16 * Scale, 0, 16 * Scale), Text = "", AutoButtonColor = false, ZIndex = ZIndex.TopBar}, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
    local CloseBtn = Create("TextButton", {Name = "Close", Parent = TopIcons, BackgroundColor3 = Theme.Error, BackgroundTransparency = 0.5, Size = UDim2.new(0, 16 * Scale, 0, 16 * Scale), Text = "", AutoButtonColor = false, ZIndex = ZIndex.TopBar}, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})

    MinBtn.MouseEnter:Connect(function() Tween(MinBtn, {BackgroundTransparency = 0}, Tweens.Quick) end)
    MinBtn.MouseLeave:Connect(function() Tween(MinBtn, {BackgroundTransparency = 0.25}, Tweens.Quick) end)
    CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, {BackgroundTransparency = 0}, Tweens.Quick) end)
    CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, {BackgroundTransparency = 0.5}, Tweens.Quick) end)

    local TabContent = Create("Frame", {Name = "TabContent", Parent = ContentArea, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 50 * Scale), Size = UDim2.new(1, 0, 1, -50 * Scale), ZIndex = ZIndex.Content, ClipsDescendants = true})

    local Dragging, DragStart, StartPos = false, nil, nil
    TopBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = true; DragStart = i.Position; StartPos = Container.Position end end)
    UserInputService.InputChanged:Connect(function(i) if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - DragStart; Container.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + d.X, StartPos.Y.Scale, StartPos.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = false end end)

    local function ToggleWindow()
        Window.Open = not Window.Open
        if Window.Open then Container.Visible = true; Container.Size = UDim2.new(0, 0, 0, 0); Tween(Container, {Size = UDim2.new(0, 900 * Scale, 0, 600 * Scale)}, Tweens.Bounce)
        else Tween(Container, {Size = UDim2.new(0, 900 * Scale, 0, 0)}, Tweens.Smooth); task.wait(0.35); Container.Visible = false end
    end

    local function CloseWindow() Tween(Container, {Size = UDim2.new(0, 0, 0, 0)}, Tweens.Smooth); task.wait(0.35); Gui:Destroy() end

    CloseBtn.MouseButton1Click:Connect(CloseWindow)
    MinBtn.MouseButton1Click:Connect(ToggleWindow)
    MobileBtn.MouseButton1Click:Connect(ToggleWindow)
    UserInputService.InputBegan:Connect(function(i, p) if not p and i.KeyCode == MinimizeKey then ToggleWindow() end end)

    Container.Size = UDim2.new(0, 0, 0, 0)
    task.wait(0.05)
    Tween(Container, {Size = UDim2.new(0, 900 * Scale, 0, 600 * Scale)}, Tweens.Bounce)

    function Window:CreateTab(opts)
        opts = opts or {}
        local TabName = opts.Name or "Tab"
        local TabIcon = opts.Icon or "rbxassetid://7072706796"
        local Tab = {Name = TabName, Sections = {}}

        local TabBtn = Create("TextButton", {Name = TabName, Parent = TabList, BackgroundColor3 = Theme.Accent, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34 * Scale), Text = "", AutoButtonColor = false, ZIndex = ZIndex.SidebarContent + 1}, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
        local Icon = Create("ImageLabel", {Name = "Icon", Parent = TabBtn, BackgroundTransparency = 1, Position = UDim2.new(0, 12 * Scale, 0.5, 0), Size = UDim2.new(0, 16 * Scale, 0, 16 * Scale), AnchorPoint = Vector2.new(0, 0.5), Image = TabIcon, ImageColor3 = Theme.TextMuted, ZIndex = ZIndex.SidebarContent + 2})
        local Label = Create("TextLabel", {Name = "Label", Parent = TabBtn, BackgroundTransparency = 1, Position = UDim2.new(0, 36 * Scale, 0, 0), Size = UDim2.new(1, -46 * Scale, 1, 0), Font = Enum.Font.GothamMedium, Text = TabName, TextColor3 = Theme.TextMuted, TextSize = 12 * Scale, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = ZIndex.SidebarContent + 2})

        local Page = Create("Frame", {Name = TabName, Parent = TabContent, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Visible = false, ZIndex = ZIndex.Content})
        local LeftCol = Create("ScrollingFrame", {Name = "Left", Parent = Page, BackgroundTransparency = 1, Position = UDim2.new(0, 15 * Scale, 0, 0), Size = UDim2.new(0.5, -22 * Scale, 1, -15 * Scale), CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.Accent, AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = ZIndex.Content, BorderSizePixel = 0}, {Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10 * Scale)}), Create("UIPadding", {PaddingRight = UDim.new(0, 5), PaddingBottom = UDim.new(0, 60 * Scale)})})
        local RightCol = Create("ScrollingFrame", {Name = "Right", Parent = Page, BackgroundTransparency = 1, Position = UDim2.new(0.5, 7 * Scale, 0, 0), Size = UDim2.new(0.5, -22 * Scale, 1, -15 * Scale), CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.Accent, AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = ZIndex.Content, BorderSizePixel = 0}, {Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10 * Scale)}), Create("UIPadding", {PaddingRight = UDim.new(0, 5), PaddingBottom = UDim.new(0, 60 * Scale)})})
        local FullCol = Create("ScrollingFrame", {Name = "Full", Parent = Page, BackgroundTransparency = 1, Position = UDim2.new(0, 15 * Scale, 0, 0), Size = UDim2.new(1, -30 * Scale, 1, -15 * Scale), CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.Accent, AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = ZIndex.Content, BorderSizePixel = 0, Visible = false}, {Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10 * Scale)}), Create("UIPadding", {PaddingRight = UDim.new(0, 5), PaddingBottom = UDim.new(0, 60 * Scale)})})

        Tab.Button, Tab.Label, Tab.Icon, Tab.Page = TabBtn, Label, Icon, Page
        Tab.LeftColumn, Tab.RightColumn, Tab.FullColumn = LeftCol, RightCol, FullCol

        TabBtn.MouseEnter:Connect(function() if Window.ActiveTab ~= Tab then Tween(TabBtn, {BackgroundTransparency = 0.8}, Tweens.Quick); Tween(Label, {TextColor3 = Theme.Text}, Tweens.Quick) end end)
        TabBtn.MouseLeave:Connect(function() if Window.ActiveTab ~= Tab then Tween(TabBtn, {BackgroundTransparency = 1}, Tweens.Quick); Tween(Label, {TextColor3 = Theme.TextMuted}, Tweens.Quick) end end)

        local function SelectTab()
            for _, t in pairs(Window.Tabs) do
                Tween(t.Button, {BackgroundTransparency = 1}, Tweens.Normal)
                Tween(t.Label, {TextColor3 = Theme.TextMuted}, Tweens.Normal)
                Tween(t.Icon, {ImageColor3 = Theme.TextMuted}, Tweens.Normal)
                t.Page.Visible = false
            end
            Tween(TabBtn, {BackgroundTransparency = 0.35}, Tweens.Normal)
            Tween(Label, {TextColor3 = Theme.Text}, Tweens.Normal)
            Tween(Icon, {ImageColor3 = Theme.Accent}, Tweens.Normal)
            Page.Visible = true
            Window.ActiveTab = Tab
        end

        TabBtn.MouseButton1Click:Connect(SelectTab)

        function Tab:CreateSection(opts)
            opts = opts or {}
            local SectionName = opts.Name or "Section"
            local Side = opts.Side or "Left"
            local Section = {}
            local Col = Side == "Left" and LeftCol or (Side == "Right" and RightCol or FullCol)
            if Side == "Middle" or Side == "Full" then LeftCol.Visible = false; RightCol.Visible = false; FullCol.Visible = true; Col = FullCol end

            local SectionFrame = Create("Frame", {Name = SectionName, Parent = Col, BackgroundColor3 = Theme.Card, BackgroundTransparency = Theme.CardTransparency, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = ZIndex.Cards}, {Create("UICorner", {CornerRadius = UDim.new(0, 10)}), Create("UIStroke", {Color = Theme.CardBorder, Thickness = 1, Transparency = 0.6}), Create("UIPadding", {PaddingTop = UDim.new(0, 14 * Scale), PaddingBottom = UDim.new(0, 14 * Scale), PaddingLeft = UDim.new(0, 14 * Scale), PaddingRight = UDim.new(0, 14 * Scale)}), Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder})})
            Create("TextLabel", {Name = "Header", Parent = SectionFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20 * Scale), Font = Enum.Font.GothamBold, Text = SectionName, TextColor3 = Theme.Text, TextSize = 13 * Scale, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 0, ZIndex = ZIndex.Cards + 1})
            Create("Frame", {Name = "Spacer", Parent = SectionFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 10 * Scale), LayoutOrder = 1})
            local Content = Create("Frame", {Name = "Content", Parent = SectionFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2, ZIndex = ZIndex.Cards + 1}, {Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8 * Scale)})})

            Section.Frame, Section.Content = SectionFrame, Content

            function Section:CreateTitle(o) o = o or {}; local f = Create("Frame", {Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 28 * Scale)}); local l = Create("TextLabel", {Parent = f, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.GothamBold, Text = o.Text or "Title", TextColor3 = Theme.Text, TextSize = 16 * Scale, TextXAlignment = Enum.TextXAlignment.Left}); return {Frame = f, Label = l, Set = function(_, t) l.Text = t end} end
            function Section:CreateLabel(o) o = o or {}; local f = Create("Frame", {Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16 * Scale)}); local l = Create("TextLabel", {Parent = f, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.Gotham, Text = o.Text or "Label", TextColor3 = Theme.TextMuted, TextSize = 11 * Scale, TextXAlignment = Enum.TextXAlignment.Left}); return {Frame = f, Label = l, Set = function(_, t) l.Text = t end} end

            function Section:CreateImage(o)
                o = o or {}
                local h = o.Height or 150 * Scale
                local f = Create("Frame", {Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, h)})
                local img = Create("ImageLabel", {Parent = f, BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.5, Size = UDim2.new(1, 0, 1, 0), Image = o.Image or "", ScaleType = Enum.ScaleType.Fit}, {Create("UICorner", {CornerRadius = UDim.new(0, (o.CornerRadius or 8) * Scale)})})
                return {Frame = f, Image = img, Set = function(_, id) img.Image = id end}
            end

            function Section:CreateToggle(o)
                o = o or {}
                local f = Create("Frame", {Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 28 * Scale)})
                Create("TextLabel", {Parent = f, BackgroundTransparency = 1, Size = UDim2.new(1, -55 * Scale, 1, 0), Font = Enum.Font.Gotham, Text = o.Name or "Toggle", TextColor3 = Theme.Text, TextSize = 12 * Scale, TextXAlignment = Enum.TextXAlignment.Left})
                local btn = Create("TextButton", {Parent = f, BackgroundColor3 = o.Default and Theme.Toggle or Theme.ToggleOff, BackgroundTransparency = 0.15, Position = UDim2.new(1, -46 * Scale, 0.5, 0), Size = UDim2.new(0, 46 * Scale, 0, 22 * Scale), AnchorPoint = Vector2.new(0, 0.5), Text = "", AutoButtonColor = false}, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                local circle = Create("Frame", {Parent = btn, BackgroundColor3 = Color3.new(1,1,1), BackgroundTransparency = 0.1, Position = o.Default and UDim2.new(1, -20 * Scale, 0.5, 0) or UDim2.new(0, 4 * Scale, 0.5, 0), Size = UDim2.new(0, 16 * Scale, 0, 16 * Scale), AnchorPoint = Vector2.new(0, 0.5)}, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                local val = o.Default or false
                local tog = {Type = "Toggle", Value = val, Frame = f}
                function tog:Set(v, skip) val = v; tog.Value = v; Tween(btn, {BackgroundColor3 = v and Theme.Toggle or Theme.ToggleOff}, Tweens.Normal); Tween(circle, {Position = v and UDim2.new(1, -20 * Scale, 0.5, 0) or UDim2.new(0, 4 * Scale, 0.5, 0)}, Tweens.Bounce); if not skip and o.Callback then o.Callback(v) end end
                btn.MouseEnter:Connect(function() Tween(circle, {Size = UDim2.new(0, 18 * Scale, 0, 18 * Scale)}, Tweens.Quick) end)
                btn.MouseLeave:Connect(function() Tween(circle, {Size = UDim2.new(0, 16 * Scale, 0, 16 * Scale)}, Tweens.Quick) end)
                btn.MouseButton1Click:Connect(function() tog:Set(not val) end)
                if o.Flag then Window.Config:Register(o.Flag, tog) end
                return tog
            end

            function Section:CreateSlider(o)
                o = o or {}
                local min, max, inc = o.Min or 0, o.Max or 100, o.Increment or 1
                local def = o.Default or min
                local f = Create("Frame", {Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 42 * Scale)})
                Create("TextLabel", {Parent = f, BackgroundTransparency = 1, Size = UDim2.new(1, -60 * Scale, 0, 18 * Scale), Font = Enum.Font.Gotham, Text = o.Name or "Slider", TextColor3 = Theme.Text, TextSize = 12 * Scale, TextXAlignment = Enum.TextXAlignment.Left})
                local valLabel = Create("TextLabel", {Parent = f, BackgroundTransparency = 1, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 55 * Scale, 0, 18 * Scale), AnchorPoint = Vector2.new(1, 0), Font = Enum.Font.GothamMedium, Text = tostring(def), TextColor3 = Theme.Accent, TextSize = 12 * Scale, TextXAlignment = Enum.TextXAlignment.Right})
                local bg = Create("Frame", {Parent = f, BackgroundColor3 = Theme.SliderBg, BackgroundTransparency = 0.4, Position = UDim2.new(0, 0, 0, 26 * Scale), Size = UDim2.new(1, 0, 0, 6 * Scale)}, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                local fill = Create("Frame", {Parent = bg, BackgroundColor3 = Theme.SliderFill, BackgroundTransparency = 0.15, Size = UDim2.new((def - min) / (max - min), 0, 1, 0)}, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                local knob = Create("Frame", {Parent = bg, BackgroundColor3 = Color3.new(1,1,1), BackgroundTransparency = 0.1, Position = UDim2.new((def - min) / (max - min), 0, 0.5, 0), Size = UDim2.new(0, 14 * Scale, 0, 14 * Scale), AnchorPoint = Vector2.new(0.5, 0.5)}, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                local sliding, val = false, def
                local slider = {Type = "Slider", Value = val, Frame = f}
                function slider:Set(v, skip) v = math.clamp(math.floor(v / inc + 0.5) * inc, min, max); val = v; slider.Value = v; local p = (v - min) / (max - min); fill.Size = UDim2.new(p, 0, 1, 0); knob.Position = UDim2.new(p, 0, 0.5, 0); valLabel.Text = tostring(v); if not skip and o.Callback then o.Callback(v) end end
                bg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliding = true; Tween(knob, {Size = UDim2.new(0, 18 * Scale, 0, 18 * Scale)}, Tweens.Quick) end end)
                UserInputService.InputEnded:Connect(function(i) if sliding and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then sliding = false; Tween(knob, {Size = UDim2.new(0, 14 * Scale, 0, 14 * Scale)}, Tweens.Quick) end end)
                UserInputService.InputChanged:Connect(function(i) if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then slider:Set(min + (max - min) * math.clamp((i.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)) end end)
                if o.Flag then Window.Config:Register(o.Flag, slider) end
                return slider
            end

            function Section:CreateDropdown(o)
                o = o or {}
                local items = o.Items or {}
                local def = o.Default or items[1] or ""
                local open = false
                local itemH = 28 * Scale
                local listH = #items * itemH
                local f = Create("Frame", {Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 52 * Scale), ClipsDescendants = true})
                Create("TextLabel", {Parent = f, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16 * Scale), Font = Enum.Font.GothamMedium, Text = o.Name or "Dropdown", TextColor3 = Theme.Text, TextSize = 12 * Scale, TextXAlignment = Enum.TextXAlignment.Left})
                local btn = Create("TextButton", {Parent = f, BackgroundColor3 = Theme.Input, BackgroundTransparency = Theme.InputTransparency, Position = UDim2.new(0, 0, 0, 20 * Scale), Size = UDim2.new(1, 0, 0, 30 * Scale), Text = "", AutoButtonColor = false}, {Create("UICorner", {CornerRadius = UDim.new(0, 6)}), Create("UIStroke", {Color = Theme.InputBorder, Thickness = 1, Transparency = 0.6})})
                local sel = Create("TextLabel", {Parent = btn, BackgroundTransparency = 1, Position = UDim2.new(0, 10 * Scale, 0, 0), Size = UDim2.new(1, -35 * Scale, 1, 0), Font = Enum.Font.Gotham, Text = def, TextColor3 = Theme.Text, TextSize = 11 * Scale, TextXAlignment = Enum.TextXAlignment.Left})
                local arrow = Create("TextLabel", {Parent = btn, BackgroundTransparency = 1, Position = UDim2.new(1, -22 * Scale, 0.5, 0), Size = UDim2.new(0, 12 * Scale, 0, 12 * Scale), AnchorPoint = Vector2.new(0, 0.5), Font = Enum.Font.GothamBold, Text = "▼", TextColor3 = Theme.TextMuted, TextSize = 8 * Scale})
                local listFrame = Create("Frame", {Parent = f, BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.05, Position = UDim2.new(0, 0, 0, 52 * Scale), Size = UDim2.new(1, 0, 0, listH), ClipsDescendants = true}, {Create("UICorner", {CornerRadius = UDim.new(0, 6)}), Create("UIStroke", {Color = Theme.CardBorder, Thickness = 1, Transparency = 0.4})})
                local listContent = Create("Frame", {Parent = listFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0)}, {Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}), Create("UIPadding", {PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4)})})
                local val = def
                local dd = {Type = "Dropdown", Value = val, Frame = f}
                local function createOpt(item)
                    local opt = Create("TextButton", {Parent = listContent, BackgroundColor3 = Theme.CardHover, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, itemH - 4), Text = "", AutoButtonColor = false}, {Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
                    Create("TextLabel", {Parent = opt, BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 0), Size = UDim2.new(1, -16, 1, 0), Font = Enum.Font.Gotham, Text = item, TextColor3 = Theme.Text, TextSize = 11 * Scale, TextXAlignment = Enum.TextXAlignment.Left})
                    opt.MouseEnter:Connect(function() Tween(opt, {BackgroundTransparency = 0.3}, Tweens.Quick) end)
                    opt.MouseLeave:Connect(function() Tween(opt, {BackgroundTransparency = 1}, Tweens.Quick) end)
                    opt.MouseButton1Click:Connect(function() dd:Set(item); dd:Close() end)
                end
                for _, item in ipairs(items) do createOpt(item) end
                function dd:Close() if not open then return end; open = false; Tween(f, {Size = UDim2.new(1, 0, 0, 52 * Scale)}, Tweens.Quick); Tween(arrow, {Rotation = 0}, Tweens.Quick); Tween(btn:FindFirstChild("UIStroke"), {Color = Theme.InputBorder}, Tweens.Quick) end
                function dd:Open() open = true; Tween(f, {Size = UDim2.new(1, 0, 0, 52 * Scale + listH + 4)}, Tweens.Quick); Tween(arrow, {Rotation = 180}, Tweens.Quick); Tween(btn:FindFirstChild("UIStroke"), {Color = Theme.Accent}, Tweens.Quick) end
                function dd:Set(v, skip) val = v; dd.Value = v; sel.Text = v; if not skip and o.Callback then o.Callback(v) end end
                function dd:Refresh(newItems) for _, c in pairs(listContent:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end; items = newItems; listH = #items * itemH; listFrame.Size = UDim2.new(1, 0, 0, listH); for _, item in ipairs(items) do createOpt(item) end; if open then f.Size = UDim2.new(1, 0, 0, 52 * Scale + listH + 4) end end
                btn.MouseEnter:Connect(function() if not open then Tween(btn:FindFirstChild("UIStroke"), {Color = Theme.TextMuted}, Tweens.Quick) end end)
                btn.MouseLeave:Connect(function() if not open then Tween(btn:FindFirstChild("UIStroke"), {Color = Theme.InputBorder}, Tweens.Quick) end end)
                btn.MouseButton1Click:Connect(function() if open then dd:Close() else dd:Open() end end)
                if o.Flag then Window.Config:Register(o.Flag, dd) end
                return dd
            end

            function Section:CreateButton(o)
                o = o or {}
                local f = Create("Frame", {Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32 * Scale), ClipsDescendants = true})
                local btn = Create("TextButton", {Parent = f, BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.GothamMedium, Text = o.Name or "Button", TextColor3 = Color3.new(1,1,1), TextSize = 12 * Scale, AutoButtonColor = false}, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
                btn.MouseEnter:Connect(function() Tween(btn, {BackgroundTransparency = 0}, Tweens.Quick) end)
                btn.MouseLeave:Connect(function() Tween(btn, {BackgroundTransparency = 0.2}, Tweens.Quick) end)
                btn.MouseButton1Click:Connect(function() Tween(btn, {BackgroundColor3 = Theme.AccentDark}, Tweens.Quick); task.wait(0.1); Tween(btn, {BackgroundColor3 = Theme.Accent}, Tweens.Quick); if o.Callback then o.Callback() end end)
                return {Frame = f, Button = btn}
            end

            function Section:CreateInput(o)
                o = o or {}
                local f = Create("Frame", {Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 52 * Scale)})
                Create("TextLabel", {Parent = f, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16 * Scale), Font = Enum.Font.GothamMedium, Text = o.Name or "Input", TextColor3 = Theme.Text, TextSize = 12 * Scale, TextXAlignment = Enum.TextXAlignment.Left})
                local box = Create("TextBox", {Parent = f, BackgroundColor3 = Theme.Input, BackgroundTransparency = Theme.InputTransparency, Position = UDim2.new(0, 0, 0, 20 * Scale), Size = UDim2.new(1, 0, 0, 30 * Scale), Font = Enum.Font.Gotham, PlaceholderText = o.Placeholder or "Enter text...", PlaceholderColor3 = Theme.TextMuted, Text = o.Default or "", TextColor3 = Theme.Text, TextSize = 11 * Scale, ClearTextOnFocus = false}, {Create("UICorner", {CornerRadius = UDim.new(0, 6)}), Create("UIStroke", {Color = Theme.InputBorder, Thickness = 1, Transparency = 0.6}), Create("UIPadding", {PaddingLeft = UDim.new(0, 10 * Scale), PaddingRight = UDim.new(0, 10 * Scale)})})
                local val = o.Default or ""
                local inp = {Type = "Input", Value = val, Frame = f}
                function inp:Set(v, skip) val = v; inp.Value = v; box.Text = v; if not skip and o.Callback then o.Callback(v) end end
                box.Focused:Connect(function() Tween(box:FindFirstChild("UIStroke"), {Color = Theme.InputFocus, Transparency = 0}, Tweens.Quick) end)
                box.FocusLost:Connect(function() Tween(box:FindFirstChild("UIStroke"), {Color = Theme.InputBorder, Transparency = 0.6}, Tweens.Quick); val = box.Text; inp.Value = val; if o.Callback then o.Callback(val) end end)
                box.MouseEnter:Connect(function() if not box:IsFocused() then Tween(box:FindFirstChild("UIStroke"), {Color = Theme.TextMuted}, Tweens.Quick) end end)
                box.MouseLeave:Connect(function() if not box:IsFocused() then Tween(box:FindFirstChild("UIStroke"), {Color = Theme.InputBorder}, Tweens.Quick) end end)
                if o.Flag then Window.Config:Register(o.Flag, inp) end
                return inp
            end

            function Section:CreateTextInput(o) return Section:CreateInput(o) end

            function Section:CreateKeybind(o)
                o = o or {}
                local def = o.Default or Enum.KeyCode.Unknown
                local f = Create("Frame", {Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 28 * Scale)})
                Create("TextLabel", {Parent = f, BackgroundTransparency = 1, Size = UDim2.new(1, -70 * Scale, 1, 0), Font = Enum.Font.Gotham, Text = o.Name or "Keybind", TextColor3 = Theme.Text, TextSize = 12 * Scale, TextXAlignment = Enum.TextXAlignment.Left})
                local btn = Create("TextButton", {Parent = f, BackgroundColor3 = Theme.Input, BackgroundTransparency = Theme.InputTransparency, Position = UDim2.new(1, -65 * Scale, 0.5, 0), Size = UDim2.new(0, 65 * Scale, 0, 24 * Scale), AnchorPoint = Vector2.new(0, 0.5), Font = Enum.Font.GothamMedium, Text = def.Name or "None", TextColor3 = Theme.Text, TextSize = 10 * Scale, AutoButtonColor = false}, {Create("UICorner", {CornerRadius = UDim.new(0, 6)}), Create("UIStroke", {Color = Theme.InputBorder, Thickness = 1, Transparency = 0.6})})
                local val, listening = def, false
                local kb = {Type = "Keybind", Value = val, Frame = f}
                function kb:Set(k) val = k; kb.Value = k; btn.Text = k.Name or "None" end
                btn.MouseEnter:Connect(function() Tween(btn:FindFirstChild("UIStroke"), {Color = Theme.TextMuted}, Tweens.Quick) end)
                btn.MouseLeave:Connect(function() if not listening then Tween(btn:FindFirstChild("UIStroke"), {Color = Theme.InputBorder}, Tweens.Quick) end end)
                btn.MouseButton1Click:Connect(function() listening = true; btn.Text = "..."; Tween(btn:FindFirstChild("UIStroke"), {Color = Theme.Accent, Transparency = 0}, Tweens.Quick) end)
                UserInputService.InputBegan:Connect(function(i, p) if listening and i.UserInputType == Enum.UserInputType.Keyboard then listening = false; kb:Set(i.KeyCode); Tween(btn:FindFirstChild("UIStroke"), {Color = Theme.InputBorder, Transparency = 0.6}, Tweens.Quick) elseif i.KeyCode == val and not p and o.Callback then o.Callback(val) end end)
                if o.Flag then Window.Config:Register(o.Flag, kb) end
                return kb
            end

            function Section:CreateColorPicker(o)
                o = o or {}
                local def = o.Default or Color3.fromRGB(138, 92, 220)
                local open = false
                local h, s, v = RGBToHSV(def)
                local pickerH = 120 * Scale
                local f = Create("Frame", {Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 28 * Scale), ClipsDescendants = true})
                Create("TextLabel", {Parent = f, BackgroundTransparency = 1, Size = UDim2.new(1, -45 * Scale, 0, 28 * Scale), Font = Enum.Font.Gotham, Text = o.Name or "Color", TextColor3 = Theme.Text, TextSize = 12 * Scale, TextXAlignment = Enum.TextXAlignment.Left})
                local preview = Create("TextButton", {Parent = f, BackgroundColor3 = def, Position = UDim2.new(1, -40 * Scale, 0, 2 * Scale), Size = UDim2.new(0, 40 * Scale, 0, 24 * Scale), Text = "", AutoButtonColor = false}, {Create("UICorner", {CornerRadius = UDim.new(0, 6)}), Create("UIStroke", {Color = Theme.CardBorder, Thickness = 1, Transparency = 0.5})})
                local pickerFrame = Create("Frame", {Parent = f, BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.05, Position = UDim2.new(0, 0, 0, 32 * Scale), Size = UDim2.new(1, 0, 0, pickerH)}, {Create("UICorner", {CornerRadius = UDim.new(0, 6)}), Create("UIStroke", {Color = Theme.CardBorder, Thickness = 1, Transparency = 0.4}), Create("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)})})
                local svFrame = Create("Frame", {Parent = pickerFrame, BackgroundColor3 = HSVToRGB(h, 1, 1), Size = UDim2.new(1, -25 * Scale, 1, 0)}, {Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
                Create("UIGradient", {Parent = svFrame, Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1)), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})})
                local darkOverlay = Create("Frame", {Parent = svFrame, BackgroundColor3 = Color3.new(0,0,0), Size = UDim2.new(1, 0, 1, 0)}, {Create("UICorner", {CornerRadius = UDim.new(0, 4)}), Create("UIGradient", {Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}), Rotation = 90})})
                local svCursor = Create("Frame", {Parent = svFrame, BackgroundColor3 = Color3.new(1,1,1), Position = UDim2.new(s, 0, 1 - v, 0), Size = UDim2.new(0, 10 * Scale, 0, 10 * Scale), AnchorPoint = Vector2.new(0.5, 0.5)}, {Create("UICorner", {CornerRadius = UDim.new(1, 0)}), Create("UIStroke", {Color = Color3.new(0,0,0), Thickness = 1})})
                local hueFrame = Create("Frame", {Parent = pickerFrame, BackgroundColor3 = Color3.new(1,1,1), Position = UDim2.new(1, -15 * Scale, 0, 0), Size = UDim2.new(0, 15 * Scale, 1, 0)}, {Create("UICorner", {CornerRadius = UDim.new(0, 4)}), Create("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)), ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255,255,0)), ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0,255,0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)), ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0,0,255)), ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255,0,255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))}), Rotation = 90})})
                local hueCursor = Create("Frame", {Parent = hueFrame, BackgroundColor3 = Color3.new(1,1,1), Position = UDim2.new(0.5, 0, h, 0), Size = UDim2.new(1, 4, 0, 6 * Scale), AnchorPoint = Vector2.new(0.5, 0.5)}, {Create("UICorner", {CornerRadius = UDim.new(0, 2)}), Create("UIStroke", {Color = Color3.new(0,0,0), Thickness = 1})})
                local val = def
                local cp = {Type = "ColorPicker", Value = val, Frame = f}
                local function updateColor() local c = HSVToRGB(h, s, v); val = c; cp.Value = c; preview.BackgroundColor3 = c; svFrame.BackgroundColor3 = HSVToRGB(h, 1, 1); svCursor.Position = UDim2.new(s, 0, 1 - v, 0); hueCursor.Position = UDim2.new(0.5, 0, h, 0); if o.Callback then o.Callback(c) end end
                function cp:Set(c) h, s, v = RGBToHSV(c); updateColor() end
                function cp:Close() if not open then return end; open = false; Tween(f, {Size = UDim2.new(1, 0, 0, 28 * Scale)}, Tweens.Quick) end
                function cp:Open() open = true; Tween(f, {Size = UDim2.new(1, 0, 0, 28 * Scale + pickerH + 8)}, Tweens.Quick) end
                preview.MouseButton1Click:Connect(function() if open then cp:Close() else cp:Open() end end)
                local draggingSV, draggingH = false, false
                svFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSV = true end end)
                hueFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingH = true end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSV = false; draggingH = false end end)
                UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then if draggingSV then s = math.clamp((i.Position.X - svFrame.AbsolutePosition.X) / svFrame.AbsoluteSize.X, 0, 1); v = 1 - math.clamp((i.Position.Y - svFrame.AbsolutePosition.Y) / svFrame.AbsoluteSize.Y, 0, 1); updateColor() elseif draggingH then h = math.clamp((i.Position.Y - hueFrame.AbsolutePosition.Y) / hueFrame.AbsoluteSize.Y, 0, 1); updateColor() end end end)
                if o.Flag then Window.Config:Register(o.Flag, cp) end
                return cp
            end

            table.insert(Tab.Sections, Section)
            return Section
        end

        function Tab:BuildConfigSection(section)
            local ConfigSection = section or Tab:CreateSection({Name = "Configuration", Side = "Left"})
            local configs = Window.Config:GetConfigs()
            local nameInput = ConfigSection:CreateInput({Name = "Config Name", Placeholder = "Enter config name..."})
            local configDropdown = ConfigSection:CreateDropdown({Name = "Config List", Items = configs, Default = configs[1] or ""})
            ConfigSection:CreateButton({Name = "Save Config", Callback = function() if nameInput.Value ~= "" then Window.Config:Save(nameInput.Value); configDropdown:Refresh(Window.Config:GetConfigs()) end end})
            ConfigSection:CreateButton({Name = "Load Config", Callback = function() if configDropdown.Value ~= "" then Window.Config:Load(configDropdown.Value) end end})
            ConfigSection:CreateButton({Name = "Delete Config", Callback = function() if configDropdown.Value ~= "" then Window.Config:Delete(configDropdown.Value); configDropdown:Refresh(Window.Config:GetConfigs()) end end})
            ConfigSection:CreateButton({Name = "Refresh", Callback = function() configDropdown:Refresh(Window.Config:GetConfigs()) end})
            return ConfigSection
        end

        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 or (DefaultTab and TabName == DefaultTab) then
            task.wait(0.1)
            TabBtn.BackgroundTransparency = 0.35
            Label.TextColor3 = Theme.Text
            Icon.ImageColor3 = Theme.Accent
            Page.Visible = true
            Window.ActiveTab = Tab
        end
        return Tab
    end

    function Window:SetTheme(n) if Themes[n] then Theme = Themes[n]; Window.Theme = Theme end end
    function Window:GetThemes() local t = {}; for n in pairs(Themes) do table.insert(t, n) end; return t end
    function Window:Toggle() ToggleWindow() end
    function Window:Destroy() CloseWindow() end

    return Window
end

return AstraLib

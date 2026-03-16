


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")


local Settings = {
    Aimbot = {
        Enabled = false,
        FOV = 0.5,
        Hitbox = "Head, Neck",
        VisibleCheck = false,
        EnemiesOnly = false,
        DrawFOV = false,
        AimKey = "MouseButton1",
        AutoAim = false,
        AutoAimKey = "V",  
        AutoShoot = false,
        Smoothness = 50,
        Prediction = false,
        IgnoreKnocked = true,
        TargetSwitchDelay = 0.2,
        StickyAim = false
    },
    Visuals = {
        Enabled = false,
        ChamsColor = Color3.fromRGB(255, 100, 100),
        BoxESP = false,
        BoxColor = Color3.fromRGB(255, 255, 255),
        Tracers = false,
        TracersColor = Color3.fromRGB(255, 255, 255),
        Names = false,
        Distance = false,
        Health = false,
        Crosshair = false,
        CrosshairColor = Color3.fromRGB(0, 255, 0),
        CrosshairSize = 10,
        Fullbright = false
    },
    Misc = {
        SpeedHack = false,
        SpeedValue = 16,
        JumpPower = false,
        JumpValue = 50,
        FlyMode = false,
        FlySpeed = 50,
        AntiAFK = false
    },
    UI = {
        Watermark = true,
        KeybindList = false,
        PanicKey = "Delete"
    }
}

-- local Holding = false
local CurrentTarget = nil
local aimAccumX = 0
local aimAccumY = 0
local lastFrameTime = nil
local aimHistory = {}
local FOVCircle = nil
local ESPObjects = {}


local function CreateMenu()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FaerMenu"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 700, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    
    local TabPanel = Instance.new("Frame")
    TabPanel.Name = "TabPanel"
    TabPanel.Size = UDim2.new(0, 200, 1, 0)
    TabPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    TabPanel.BorderSizePixel = 0
    TabPanel.Parent = MainFrame
    
    local TabPanelCorner = Instance.new("UICorner")
    TabPanelCorner.CornerRadius = UDim.new(0, 12)
    TabPanelCorner.Parent = TabPanel
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = TabPanel
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.PaddingTop = UDim.new(0, 15)
    TabPadding.Parent = TabPanel
    
    
    local PagesContainer = Instance.new("Frame")
    PagesContainer.Name = "PagesContainer"
    PagesContainer.Size = UDim2.new(1, -220, 1, -20)
    PagesContainer.Position = UDim2.new(0, 210, 0, 10)
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.Parent = MainFrame
    
    
    local function CreateTab(name, icon, order)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.Size = UDim2.new(1, 0, 0, 45)
        TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        TabButton.BorderSizePixel = 0
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 14
        TabButton.Text = "  " .. icon .. "  " .. name
        TabButton.TextColor3 = Color3.fromRGB(140, 140, 160)
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.LayoutOrder = order
        TabButton.Parent = TabPanel
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabButton
        
        local TabPad = Instance.new("UIPadding")
        TabPad.PaddingLeft = UDim.new(0, 15)
        TabPad.Parent = TabButton

        
        
        local Page = Instance.new("Frame")
        Page.Name = name .. "Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.Parent = PagesContainer
        
        
        local LeftColumn = Instance.new("Frame")
        LeftColumn.Name = "LeftColumn"
        LeftColumn.Size = UDim2.new(0.48, 0, 1, 0)
        LeftColumn.Position = UDim2.new(0, 0, 0, 0)
        LeftColumn.BackgroundTransparency = 1
        LeftColumn.Parent = Page
        
        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LeftLayout.Padding = UDim.new(0, 12)
        LeftLayout.Parent = LeftColumn
        
        
        local RightColumn = Instance.new("Frame")
        RightColumn.Name = "RightColumn"
        RightColumn.Size = UDim2.new(0.48, 0, 1, 0)
        RightColumn.Position = UDim2.new(0.52, 0, 0, 0)
        RightColumn.BackgroundTransparency = 1
        RightColumn.Parent = Page
        
        local RightLayout = Instance.new("UIListLayout")
        RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RightLayout.Padding = UDim.new(0, 12)
        RightLayout.Parent = RightColumn
        
        TabButton.MouseButton1Click:Connect(function()
            for _, child in pairs(PagesContainer:GetChildren()) do
                if child:IsA("Frame") then
                    child.Visible = false
                end
            end
            for _, tab in pairs(TabPanel:GetChildren()) do
                if tab:IsA("TextButton") then
                    tab.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
                    tab.TextColor3 = Color3.fromRGB(140, 140, 160)
                end
            end
            Page.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(70, 80, 220)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        
        return Page, LeftColumn, RightColumn
    end

    
    
    local function CreateSection(parent, title)
        local Section = Instance.new("Frame")
        Section.Name = title
        Section.Size = UDim2.new(1, 0, 0, 0)
        Section.AutomaticSize = Enum.AutomaticSize.Y
        Section.BackgroundTransparency = 1
        Section.Parent = parent
        
        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Name = "Title"
        SectionTitle.Size = UDim2.new(1, 0, 0, 30)
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.Font = Enum.Font.GothamBold
        SectionTitle.TextSize = 13
        SectionTitle.Text = "" .. title
        SectionTitle.TextColor3 = Color3.fromRGB(160, 160, 180)
        SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        SectionTitle.Parent = Section
        
        local SectionLayout = Instance.new("UIListLayout")
        SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
        SectionLayout.Padding = UDim.new(0, 12)
        SectionLayout.Parent = Section
        
        local SectionPadding = Instance.new("UIPadding")
        SectionPadding.PaddingTop = UDim.new(0, 35)
        SectionPadding.Parent = Section
        
        return Section
    end
    
    
    local function CreateToggle(parent, text, default, callback)
        local Toggle = Instance.new("Frame")
        Toggle.Name = text
        Toggle.Size = UDim2.new(1, 0, 0, 32)
        Toggle.BackgroundTransparency = 1
        Toggle.Parent = parent
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.65, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(180, 180, 200)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Toggle
        
        local Switch = Instance.new("TextButton")
        Switch.Size = UDim2.new(0, 45, 0, 24)
        Switch.Position = UDim2.new(1, -45, 0.5, -12)
        Switch.BackgroundColor3 = default and Color3.fromRGB(90, 100, 230) or Color3.fromRGB(45, 45, 55)
        Switch.BorderSizePixel = 0
        Switch.Text = ""
        Switch.Parent = Toggle
        
        local SwitchCorner = Instance.new("UICorner")
        SwitchCorner.CornerRadius = UDim.new(1, 0)
        SwitchCorner.Parent = Switch
        
        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.new(0, 18, 0, 18)
        Knob.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Knob.BorderSizePixel = 0
        Knob.Parent = Switch
        
        local KnobCorner = Instance.new("UICorner")
        KnobCorner.CornerRadius = UDim.new(1, 0)
        KnobCorner.Parent = Knob
        
        local state = default
        Switch.MouseButton1Click:Connect(function()
            state = not state
            Switch.BackgroundColor3 = state and Color3.fromRGB(90, 100, 230) or Color3.fromRGB(45, 45, 55)
            Knob:TweenPosition(state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            callback(state)
        end)
        
        return Toggle
    end

    
    
    local function CreateSlider(parent, text, min, max, default, callback)
        local Slider = Instance.new("Frame")
        Slider.Name = text
        Slider.Size = UDim2.new(1, 0, 0, 55)
        Slider.BackgroundTransparency = 1
        Slider.Parent = parent
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.6, 0, 0, 20)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(180, 180, 200)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Slider
        
        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(0, 60, 0, 20)
        ValueLabel.Position = UDim2.new(1, -60, 0, 0)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Font = Enum.Font.GothamBold
        ValueLabel.TextSize = 14
        ValueLabel.Text = tostring(default) .. "В°"
        ValueLabel.TextColor3 = Color3.fromRGB(90, 100, 230)
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = Slider
        
        local Track = Instance.new("Frame")
        Track.Size = UDim2.new(1, 0, 0, 6)
        Track.Position = UDim2.new(0, 0, 1, -12)
        Track.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        Track.BorderSizePixel = 0
        Track.Parent = Slider
        
        local TrackCorner = Instance.new("UICorner")
        TrackCorner.CornerRadius = UDim.new(1, 0)
        TrackCorner.Parent = Track
        
        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(90, 100, 230)
        Fill.BorderSizePixel = 0
        Fill.Parent = Track
        
        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(1, 0)
        FillCorner.Parent = Fill
        
        local Dragging = false
        Track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = false
            end
        end)
        
        Track.InputChanged:Connect(function(input)
            if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * pos * 10) / 10
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                ValueLabel.Text = tostring(value) .. "В°"
                callback(value)
            end
        end)
        
        return Slider
    end

    
    
    local function CreateHitboxSelector(parent, text, default, callback)
        local Selector = Instance.new("Frame")
        Selector.Name = text
        Selector.Size = UDim2.new(1, 0, 0, 32)
        Selector.BackgroundTransparency = 1
        Selector.Parent = parent
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0, 80, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(180, 180, 200)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Selector
        
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0, 160, 0, 28)
        Button.Position = UDim2.new(1, -160, 0.5, -14)
        Button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        Button.BorderSizePixel = 0
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 13
        Button.Text = default
        Button.TextColor3 = Color3.fromRGB(180, 180, 200)
        Button.Parent = Selector
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = Button
        
        local options = {"Head", "Head, Neck", "Torso", "Random"}
        
        local currentIndex = 1
        for i, opt in ipairs(options) do
            if opt == default then
                currentIndex = i
                break
            end
        end
        
        Button.MouseButton1Click:Connect(function()
            currentIndex = currentIndex % #options + 1
            Button.Text = options[currentIndex]
            callback(options[currentIndex])
        end)
        
        return Selector
    end

    
    
    local function CreateKeybind(parent, text, default, callback)
        local Keybind = Instance.new("Frame")
        Keybind.Name = text
        Keybind.Size = UDim2.new(1, 0, 0, 32)
        Keybind.BackgroundTransparency = 1
        Keybind.Parent = parent
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0, 100, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(180, 180, 200)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Keybind
        
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0, 140, 0, 28)
        Button.Position = UDim2.new(1, -140, 0.5, -14)
        Button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        Button.BorderSizePixel = 0
        Button.Font = Enum.Font.GothamBold
        Button.TextSize = 12
        Button.Text = default
        Button.TextColor3 = Color3.fromRGB(90, 100, 230)
        Button.Parent = Keybind
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = Button
        
        local listening = false
        Button.MouseButton1Click:Connect(function()
            if listening then return end
            listening = true
            Button.Text = "..."
            
            local connection
            connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                
                if input.KeyCode == Enum.KeyCode.Escape then
                    Button.Text = default
                    listening = false
                    connection:Disconnect()
                    return
                end
                
                local keyName = ""
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    keyName = "MouseButton1"
                elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                    keyName = "MouseButton2"
                elseif input.KeyCode ~= Enum.KeyCode.Unknown then
                    keyName = input.KeyCode.Name
                end
                
                if keyName ~= "" then
                    Button.Text = keyName
                    callback(keyName)
                    listening = false
                    connection:Disconnect()
                end
            end)
        end)
        
        return Keybind
    end

    
    
    local function CreateTextBlock(parent, title, text)
        local Block = Instance.new("Frame")
        Block.Name = title
        Block.Size = UDim2.new(1, 0, 0, 0)
        Block.AutomaticSize = Enum.AutomaticSize.Y
        Block.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
        Block.BorderSizePixel = 0
        Block.Parent = parent
        
        local BlockCorner = Instance.new("UICorner")
        BlockCorner.CornerRadius = UDim.new(0, 8)
        BlockCorner.Parent = Block
        
        local BlockTitle = Instance.new("TextLabel")
        BlockTitle.Name = "Title"
        BlockTitle.Size = UDim2.new(1, -20, 0, 25)
        BlockTitle.Position = UDim2.new(0, 10, 0, 8)
        BlockTitle.BackgroundTransparency = 1
        BlockTitle.Font = Enum.Font.GothamBold
        BlockTitle.TextSize = 14
        BlockTitle.Text = title
        BlockTitle.TextColor3 = Color3.fromRGB(90, 100, 230)
        BlockTitle.TextXAlignment = Enum.TextXAlignment.Left
        BlockTitle.Parent = Block
        
        local BlockText = Instance.new("TextLabel")
        BlockText.Name = "Text"
        BlockText.Size = UDim2.new(1, -20, 0, 0)
        BlockText.Position = UDim2.new(0, 10, 0, 35)
        BlockText.AutomaticSize = Enum.AutomaticSize.Y
        BlockText.BackgroundTransparency = 1
        BlockText.Font = Enum.Font.Gotham
        BlockText.TextSize = 12
        BlockText.Text = text
        BlockText.TextColor3 = Color3.fromRGB(180, 180, 200)
        BlockText.TextXAlignment = Enum.TextXAlignment.Left
        BlockText.TextYAlignment = Enum.TextYAlignment.Top
        BlockText.TextWrapped = true
        BlockText.Parent = Block
        
        local BlockPadding = Instance.new("UIPadding")
        BlockPadding.PaddingBottom = UDim.new(0, 12)
        BlockPadding.Parent = Block
        
        return Block
    end
    
    
    local function CreateHeader(parent, text)
        local Header = Instance.new("TextLabel")
        Header.Name = "Header"
        Header.Size = UDim2.new(1, 0, 0, 35)
        Header.BackgroundTransparency = 1
        Header.Font = Enum.Font.GothamBold
        Header.TextSize = 18
        Header.Text = text
        Header.TextColor3 = Color3.fromRGB(255, 255, 255)
        Header.TextXAlignment = Enum.TextXAlignment.Center
        Header.Parent = parent
        
        return Header
    end
    
    
    local AimbotPage, AimbotLeft, AimbotRight = CreateTab("Aimbot", "", 1)
    local VisualsPage, VisualsLeft, VisualsRight = CreateTab("Visuals", "", 2)
    local MiscPage, MiscLeft, MiscRight = CreateTab("Misc", "", 3)
    local InfoPage, InfoLeft, InfoRight = CreateTab("Info", "i", 4)
    
    
    local AimbotGeneral = CreateSection(AimbotLeft, "General")
    CreateToggle(AimbotGeneral, "Enable", Settings.Aimbot.Enabled, function(v) Settings.Aimbot.Enabled = v end)
    CreateToggle(AimbotGeneral, "Auto Aim", Settings.Aimbot.AutoAim, function(v) Settings.Aimbot.AutoAim = v end)
    CreateToggle(AimbotGeneral, "Auto Shoot", Settings.Aimbot.AutoShoot, function(v) Settings.Aimbot.AutoShoot = v end)
    CreateSlider(AimbotGeneral, "Field Of View", 0.1, 5.0, Settings.Aimbot.FOV, function(v) Settings.Aimbot.FOV = v end)
    CreateSlider(AimbotGeneral, "Smoothness", 1, 100, Settings.Aimbot.Smoothness, function(v) Settings.Aimbot.Smoothness = v end)
    CreateHitboxSelector(AimbotGeneral, "Hitbox", Settings.Aimbot.Hitbox, function(v) Settings.Aimbot.Hitbox = v end)
    CreateKeybind(AimbotGeneral, "Auto Aim Key", Settings.Aimbot.AutoAimKey, function(v) Settings.Aimbot.AutoAimKey = v end)
    
    
    local AimbotAdditional = CreateSection(AimbotRight, "Additional")
    CreateToggle(AimbotAdditional, "Visible Check", Settings.Aimbot.VisibleCheck, function(v) Settings.Aimbot.VisibleCheck = v end)
    CreateToggle(AimbotAdditional, "Enemies Only", Settings.Aimbot.EnemiesOnly, function(v) Settings.Aimbot.EnemiesOnly = v end)
    CreateToggle(AimbotAdditional, "Draw FOV", Settings.Aimbot.DrawFOV, function(v) Settings.Aimbot.DrawFOV = v end)
    CreateToggle(AimbotAdditional, "Prediction", Settings.Aimbot.Prediction, function(v) Settings.Aimbot.Prediction = v end)
    CreateToggle(AimbotAdditional, "Ignore Knocked", Settings.Aimbot.IgnoreKnocked, function(v) Settings.Aimbot.IgnoreKnocked = v end)
    CreateToggle(AimbotAdditional, "Sticky Aim", Settings.Aimbot.StickyAim, function(v) Settings.Aimbot.StickyAim = v end)
    CreateKeybind(AimbotAdditional, "Aim Key", Settings.Aimbot.AimKey, function(v) Settings.Aimbot.AimKey = v end)
    
    
    local VisualsGeneral = CreateSection(VisualsLeft, "General")
    CreateToggle(VisualsGeneral, "Enable", Settings.Visuals.Enabled, function(v) Settings.Visuals.Enabled = v end)
    CreateToggle(VisualsGeneral, "Box ESP", Settings.Visuals.BoxESP, function(v) Settings.Visuals.BoxESP = v end)
    CreateToggle(VisualsGeneral, "Tracers", Settings.Visuals.Tracers, function(v) Settings.Visuals.Tracers = v end)
    CreateToggle(VisualsGeneral, "Crosshair", Settings.Visuals.Crosshair, function(v) Settings.Visuals.Crosshair = v end)
    CreateToggle(VisualsGeneral, "Fullbright", Settings.Visuals.Fullbright, function(v) Settings.Visuals.Fullbright = v end)
    
    
    local VisualsAdditional = CreateSection(VisualsRight, "Additional")
    CreateToggle(VisualsAdditional, "Names", Settings.Visuals.Names, function(v) Settings.Visuals.Names = v end)
    CreateToggle(VisualsAdditional, "Distance", Settings.Visuals.Distance, function(v) Settings.Visuals.Distance = v end)
    CreateToggle(VisualsAdditional, "Health", Settings.Visuals.Health, function(v) Settings.Visuals.Health = v end)
    CreateSlider(VisualsAdditional, "Crosshair Size", 5, 30, Settings.Visuals.CrosshairSize, function(v) Settings.Visuals.CrosshairSize = v end)
    
    
    local MiscGeneral = CreateSection(MiscLeft, "Movement")
    CreateToggle(MiscGeneral, "Speed Hack", Settings.Misc.SpeedHack, function(v) Settings.Misc.SpeedHack = v end)
    CreateSlider(MiscGeneral, "Speed Value", 16, 100, Settings.Misc.SpeedValue, function(v) Settings.Misc.SpeedValue = v end)
    CreateToggle(MiscGeneral, "Jump Power", Settings.Misc.JumpPower, function(v) Settings.Misc.JumpPower = v end)
    CreateSlider(MiscGeneral, "Jump Value", 50, 200, Settings.Misc.JumpValue, function(v) Settings.Misc.JumpValue = v end)
    CreateToggle(MiscGeneral, "Fly Mode", Settings.Misc.FlyMode, function(v) Settings.Misc.FlyMode = v end)
    CreateSlider(MiscGeneral, "Fly Speed", 10, 200, Settings.Misc.FlySpeed, function(v) Settings.Misc.FlySpeed = v end)
    
    
    local MiscAdditional = CreateSection(MiscRight, "Other")
    CreateToggle(MiscAdditional, "Anti AFK", Settings.Misc.AntiAFK, function(v) Settings.Misc.AntiAFK = v end)
    
    
    CreateHeader(InfoLeft, "DISCORD: .utsy")
    
    
    local DiscordButton = Instance.new("TextButton")
    DiscordButton.Name = "DiscordButton"
    DiscordButton.Size = UDim2.new(1, -20, 0, 35)
    DiscordButton.Position = UDim2.new(0, 10, 0, 0)
    DiscordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    DiscordButton.BorderSizePixel = 0
    DiscordButton.Font = Enum.Font.GothamBold
    DiscordButton.TextSize = 13
    DiscordButton.Text = "Copy Discord Link"
    DiscordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DiscordButton.Parent = InfoLeft
    
    local DiscordCorner = Instance.new("UICorner")
    DiscordCorner.CornerRadius = UDim.new(0, 8)
    DiscordCorner.Parent = DiscordButton
    
    DiscordButton.MouseButton1Click:Connect(function()
        setclipboard("https://discord.gg/XBJyM3SadJ")
        DiscordButton.Text = "Copied!"
        wait(2)
        DiscordButton.Text = "Copy Discord Link"
    end)
    
    DiscordButton.MouseEnter:Connect(function()
        DiscordButton.BackgroundColor3 = Color3.fromRGB(108, 121, 255)
    end)
    
    DiscordButton.MouseLeave:Connect(function()
        DiscordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    end)
    
    CreateTextBlock(InfoLeft, "Aimbot", 
        "Enable - Turn aimbot on/off\n" ..
        "Auto Aim - Automatic aiming without key press\n" ..
        "Auto Shoot - Automatic shooting when aimed\n" ..
        "Field Of View - Target search radius\n" ..
        "Hitbox - Body part to aim at\n" ..
        "Auto Aim Key - Quick toggle key for Auto Aim"
    )
    
    CreateTextBlock(InfoLeft, "Additional", 
        "Visible Check - Only aim at visible enemies\n" ..
        "Enemies Only - Don't aim at teammates\n" ..
        "Draw FOV - Show aiming radius circle\n" ..
        "Aim Key - Key to activate aiming"
    )
    
    CreateTextBlock(InfoRight, "Visuals", 
        "Enable - Highlight players through walls (Chams)\n" ..
        "Box ESP - Boxes around players\n" ..
        "Tracers - Lines from bottom screen to players\n" ..
        "Names - Player names above head\n" ..
        "Distance - Distance to players in meters\n" ..
        "Health - Health bar on the left of box"
    )
    
    CreateTextBlock(InfoRight, "Controls", 
        "INSERT - Open/close menu\n" ..
        "V (default) - Toggle Auto Aim\n" ..
        "LMB (default) - Activate aiming\n" ..
        "ESC - Cancel key selection"
    )
    
    
    AimbotPage.Visible = true
    TabPanel:FindFirstChild("AimbotTab").BackgroundColor3 = Color3.fromRGB(70, 80, 220)
    TabPanel:FindFirstChild("AimbotTab").TextColor3 = Color3.fromRGB(255, 255, 255)
    
    ScreenGui.Parent = game:GetService("CoreGui")
    return ScreenGui
end

-- Crosshair
local CrosshairLines = {}
local function CreateCrosshair()
    for i = 1, 4 do
        local line = Drawing.new("Line")
        line.Thickness = 2
        line.Color = Settings.Visuals.CrosshairColor
        line.Transparency = 1
        line.Visible = false
        CrosshairLines[i] = line
    end
end

local function UpdateCrosshair()
    if Settings.Visuals.Crosshair then
        local center = Camera.ViewportSize / 2
        local size = Settings.Visuals.CrosshairSize
        
        -- Top
        CrosshairLines[1].From = Vector2.new(center.X, center.Y - size)
        CrosshairLines[1].To = Vector2.new(center.X, center.Y - size/2)
        CrosshairLines[1].Color = Settings.Visuals.CrosshairColor
        CrosshairLines[1].Visible = true
        
        -- Bottom
        CrosshairLines[2].From = Vector2.new(center.X, center.Y + size/2)
        CrosshairLines[2].To = Vector2.new(center.X, center.Y + size)
        CrosshairLines[2].Color = Settings.Visuals.CrosshairColor
        CrosshairLines[2].Visible = true
        
        -- Left
        CrosshairLines[3].From = Vector2.new(center.X - size, center.Y)
        CrosshairLines[3].To = Vector2.new(center.X - size/2, center.Y)
        CrosshairLines[3].Color = Settings.Visuals.CrosshairColor
        CrosshairLines[3].Visible = true
        
        -- Right
        CrosshairLines[4].From = Vector2.new(center.X + size/2, center.Y)
        CrosshairLines[4].To = Vector2.new(center.X + size, center.Y)
        CrosshairLines[4].Color = Settings.Visuals.CrosshairColor
        CrosshairLines[4].Visible = true
    else
        for _, line in pairs(CrosshairLines) do
            line.Visible = false
        end
    end
end

-- Fullbright
local function UpdateFullbright()
    if Settings.Visuals.Fullbright then
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").ClockTime = 14
        game:GetService("Lighting").FogEnd = 100000
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end

-- Speed Hack
local function UpdateSpeed()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if Settings.Misc.SpeedHack then
                humanoid.WalkSpeed = Settings.Misc.SpeedValue
            else
                humanoid.WalkSpeed = 16
            end
        end
    end
end

-- Jump Power
local function UpdateJumpPower()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if Settings.Misc.JumpPower then
                humanoid.JumpPower = Settings.Misc.JumpValue
            else
                humanoid.JumpPower = 50
            end
        end
    end
end

-- Fly Mode
local Flying = false
local FlyConnection = nil
local function ToggleFly()
    Flying = Settings.Misc.FlyMode
    local char = LocalPlayer.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if Flying then
        local bg = Instance.new("BodyGyro")
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = root.CFrame
        bg.Parent = root
        
        local bv = Instance.new("BodyVelocity")
        bv.velocity = Vector3.new(0, 0, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = root
        
        FlyConnection = RunService.Heartbeat:Connect(function()
            if not Flying or not Settings.Misc.FlyMode then
                if bg then bg:Destroy() end
                if bv then bv:Destroy() end
                if FlyConnection then FlyConnection:Disconnect() end
                return
            end
            
            local speed = Settings.Misc.FlySpeed
            bg.cframe = Camera.CFrame
            bv.velocity = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                bv.velocity = bv.velocity + Camera.CFrame.LookVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                bv.velocity = bv.velocity - Camera.CFrame.LookVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                bv.velocity = bv.velocity - Camera.CFrame.RightVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                bv.velocity = bv.velocity + Camera.CFrame.RightVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                bv.velocity = bv.velocity + Vector3.new(0, speed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                bv.velocity = bv.velocity - Vector3.new(0, speed, 0)
            end
        end)
    else
        if FlyConnection then
            FlyConnection:Disconnect()
        end
        local bg = root:FindFirstChildOfClass("BodyGyro")
        local bv = root:FindFirstChildOfClass("BodyVelocity")
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
    end
end

-- Anti AFK
local AntiAFKConnection = nil
local function UpdateAntiAFK()
    if Settings.Misc.AntiAFK then
        if not AntiAFKConnection then
            AntiAFKConnection = game:GetService("VirtualUser").Button1Down:Connect(function()
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):ClickButton2(Vector2.new())
            end)
        end
    else
        if AntiAFKConnection then
            AntiAFKConnection:Disconnect()
            AntiAFKConnection = nil
        end
    end
end

CreateCrosshair()

-- FOV Circle
local function CreateFOVCircle()
    local circle = Drawing.new("Circle")
    circle.Thickness = 2
    circle.NumSides = 64
    circle.Radius = 100
    circle.Filled = false
    circle.Transparency = 1
    circle.Color = Color3.fromRGB(90, 100, 230)
    circle.Visible = false
    return circle
end

FOVCircle = CreateFOVCircle()



local ESPBoxes = {}
local ESPTracers = {}
local ESPNames = {}
local ESPDistance = {}
local ESPHealth = {}
local ESPConnections = {
    render = nil,
    playerAdded = nil,
    playerRemoving = nil,
    charConns = {}
}

-- Chams (Highlight)
local function CreateChams(player)
    if ESPObjects[player] then return end
    if player == LocalPlayer then return end
    
    local esp = {
        highlight = nil,
        charConn = nil
    }
    
    local function createHighlight(char)
        if not char then return nil end
        local highlight = Instance.new("Highlight")
        highlight.Name = "FaerChams"
        highlight.Adornee = char
        highlight.FillColor = Settings.Visuals.ChamsColor
        highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = game:GetService("CoreGui")
        return highlight
    end
    
    local char = player.Character
    if char then
        esp.highlight = createHighlight(char)
    end
    
    esp.charConn = player.CharacterAdded:Connect(function(char)
        if esp.highlight then
            esp.highlight:Destroy()
        end
        esp.highlight = createHighlight(char)
    end)
    
    ESPObjects[player] = esp
end

local function RemoveChams(player)
    if not ESPObjects[player] then return end
    
    local esp = ESPObjects[player]
    
    if esp.charConn then
        esp.charConn:Disconnect()
    end
    
    if esp.highlight then
        esp.highlight:Destroy()
    end
    
    ESPObjects[player] = nil
end

-- ESP Boxes (Drawing API)
local function CreateBox(player)
    if ESPBoxes[player] then return ESPBoxes[player] end
    
    local box = Drawing.new("Square")
    box.Visible = false
    box.Filled = false
    box.Thickness = 2
    box.Color = Settings.Visuals.BoxColor
    box.Transparency = 1
    
    ESPBoxes[player] = box
    return box
end

local function RemoveBox(player)
    if ESPBoxes[player] then
        ESPBoxes[player]:Remove()
        ESPBoxes[player] = nil
    end
end

-- Tracers (Drawing API)
local function CreateTracer(player)
    if ESPTracers[player] then return ESPTracers[player] end
    
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Thickness = 1
    tracer.Color = Settings.Visuals.TracersColor
    tracer.Transparency = 1
    
    ESPTracers[player] = tracer
    return tracer
end

local function RemoveTracer(player)
    if ESPTracers[player] then
        ESPTracers[player]:Remove()
        ESPTracers[player] = nil
    end
end

-- Names (Drawing API)
local function CreateName(player)
    if ESPNames[player] then return ESPNames[player] end
    
    local name = Drawing.new("Text")
    name.Visible = false
    name.Text = player.Name
    name.Size = 14
    name.Color = Color3.fromRGB(255, 255, 255)
    name.Center = true
    name.Outline = true
    name.OutlineColor = Color3.fromRGB(0, 0, 0)
    name.Transparency = 1
    
    ESPNames[player] = name
    return name
end

local function RemoveName(player)
    if ESPNames[player] then
        ESPNames[player]:Remove()
        ESPNames[player] = nil
    end
end

-- Distance (Drawing API)
local function CreateDistance(player)
    if ESPDistance[player] then return ESPDistance[player] end
    
    local distance = Drawing.new("Text")
    distance.Visible = false
    distance.Text = "0m"
    distance.Size = 12
    distance.Color = Color3.fromRGB(200, 200, 200)
    distance.Center = true
    distance.Outline = true
    distance.OutlineColor = Color3.fromRGB(0, 0, 0)
    distance.Transparency = 1
    
    ESPDistance[player] = distance
    return distance
end

local function RemoveDistance(player)
    if ESPDistance[player] then
        ESPDistance[player]:Remove()
        ESPDistance[player] = nil
    end
end

-- Health (Drawing API)
local function CreateHealth(player)
    if ESPHealth[player] then return ESPHealth[player] end
    
    local health = {}
    
    -- Background bar
    health.bg = Drawing.new("Square")
    health.bg.Visible = false
    health.bg.Filled = true
    health.bg.Color = Color3.fromRGB(0, 0, 0)
    health.bg.Transparency = 0.5
    health.bg.Thickness = 1
    
    -- Health bar
    health.bar = Drawing.new("Square")
    health.bar.Visible = false
    health.bar.Filled = true
    health.bar.Color = Color3.fromRGB(0, 255, 0)
    health.bar.Transparency = 1
    health.bar.Thickness = 0
    
    ESPHealth[player] = health
    return health
end

local function RemoveHealth(player)
    if ESPHealth[player] then
        if ESPHealth[player].bg then
            ESPHealth[player].bg:Remove()
        end
        if ESPHealth[player].bar then
            ESPHealth[player].bar:Remove()
        end
        ESPHealth[player] = nil
    end
end

local function ProjectWorldPointsToScreen(cam, points)
    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge
    local anyOnScreen = false
    
    for _, worldPos in ipairs(points) do
        local ok, screenPos = pcall(function()
            return cam:WorldToViewportPoint(worldPos)
        end)
        
        if ok and screenPos.Z > 0 then
            anyOnScreen = true
            minX = math.min(minX, screenPos.X)
            maxX = math.max(maxX, screenPos.X)
            minY = math.min(minY, screenPos.Y)
            maxY = math.max(maxY, screenPos.Y)
        end
    end
    
    return anyOnScreen and minX or nil, anyOnScreen and minY or nil, anyOnScreen and maxX or nil, anyOnScreen and maxY or nil
end

local function UpdateBoxes()
    local cam = Camera
    if not cam then return end
    
    local camPos = cam.CFrame.Position
    local MAX_DISTANCE = 300
    local PAD = 2
    local viewportSize = cam.ViewportSize
    local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        local char = player.Character
        if not char or not char.Parent then
            RemoveBox(player)
            RemoveTracer(player)
            RemoveName(player)
            RemoveDistance(player)
            RemoveHealth(player)
        else
            local root = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            
            if not root then
                RemoveBox(player)
                RemoveTracer(player)
                RemoveName(player)
                RemoveDistance(player)
                RemoveHealth(player)
            else
                local dist = (root.Position - camPos).Magnitude
                if dist > MAX_DISTANCE then
                    RemoveBox(player)
                    RemoveTracer(player)
                    RemoveName(player)
                    RemoveDistance(player)
                    RemoveHealth(player)
                else
                    local minX, minY, maxX, maxY
                    local boxX, boxY, boxW, boxH
                    
                    
                    local ok, bboxCFrame, bboxSize = pcall(function()
                        return char:GetBoundingBox()
                    end)
                    
                    if ok and bboxCFrame and bboxSize then
                        local hx, hy, hz = bboxSize.X / 2 * 0.8, bboxSize.Y / 2 * 0.9, bboxSize.Z / 2 * 0.8
                        local corners = {
                            bboxCFrame * CFrame.new(-hx, -hy, -hz),
                            bboxCFrame * CFrame.new(-hx, -hy,  hz),
                            bboxCFrame * CFrame.new(-hx,  hy, -hz),
                            bboxCFrame * CFrame.new(-hx,  hy,  hz),
                            bboxCFrame * CFrame.new( hx, -hy, -hz),
                            bboxCFrame * CFrame.new( hx, -hy,  hz),
                            bboxCFrame * CFrame.new( hx,  hy, -hz),
                            bboxCFrame * CFrame.new( hx,  hy,  hz),
                        }
                        
                        local points = {}
                        for _, cf in ipairs(corners) do
                            table.insert(points, cf.Position)
                        end
                        
                        minX, minY, maxX, maxY = ProjectWorldPointsToScreen(cam, points)
                        
                        if minX then
                            boxX = minX - PAD
                            boxY = minY - PAD
                            boxW = math.max(4, maxX - minX + PAD * 2)
                            boxH = math.max(4, maxY - minY + PAD * 2)
                        end
                    end
                    
                    -- If player not on screen, hide all ESP
                    if not minX then
                        if ESPBoxes[player] then ESPBoxes[player].Visible = false end
                        if ESPHealth[player] then 
                            ESPHealth[player].bg.Visible = false
                            ESPHealth[player].bar.Visible = false
                        end
                        if ESPNames[player] then ESPNames[player].Visible = false end
                        if ESPDistance[player] then ESPDistance[player].Visible = false end
                        if ESPTracers[player] then ESPTracers[player].Visible = false end
                    else
                        -- Player is on screen, show ESP
                        
                        if Settings.Visuals.BoxESP then
                            local box = ESPBoxes[player] or CreateBox(player)
                            if box then
                                box.Position = Vector2.new(boxX, boxY)
                                box.Size = Vector2.new(boxW, boxH)
                                box.Color = Settings.Visuals.BoxColor
                                box.Visible = true
                            end
                        else
                            if ESPBoxes[player] then
                                ESPBoxes[player].Visible = false
                            end
                        end
                        
                        
                        if Settings.Visuals.Health and humanoid then
                            local health = ESPHealth[player] or CreateHealth(player)
                            if health then
                                local healthPercent = humanoid.Health / humanoid.MaxHealth
                                local barHeight = boxH
                                local barWidth = 3
                                
                                health.bg.Position = Vector2.new(boxX - barWidth - 2, boxY)
                                health.bg.Size = Vector2.new(barWidth, barHeight)
                                health.bg.Visible = true
                                
                                health.bar.Position = Vector2.new(boxX - barWidth - 2, boxY + barHeight * (1 - healthPercent))
                                health.bar.Size = Vector2.new(barWidth, barHeight * healthPercent)
                                health.bar.Color = Color3.fromRGB(
                                    255 * (1 - healthPercent),
                                    255 * healthPercent,
                                    0
                                )
                                health.bar.Visible = true
                            end
                        else
                            if ESPHealth[player] then
                                ESPHealth[player].bg.Visible = false
                                ESPHealth[player].bar.Visible = false
                            end
                        end
                        
                        
                        if Settings.Visuals.Names then
                            local name = ESPNames[player] or CreateName(player)
                            if name then
                                name.Position = Vector2.new(boxX + boxW / 2, boxY - 18)
                                name.Visible = true
                            end
                        else
                            if ESPNames[player] then
                                ESPNames[player].Visible = false
                            end
                        end
                        
                        
                        if Settings.Visuals.Distance then
                            local distance = ESPDistance[player] or CreateDistance(player)
                            if distance then
                                distance.Text = math.floor(dist) .. "m"
                                distance.Position = Vector2.new(boxX + boxW / 2, boxY + boxH + 2)
                                distance.Visible = true
                            end
                        else
                            if ESPDistance[player] then
                                ESPDistance[player].Visible = false
                            end
                        end
                        
                        
                        if Settings.Visuals.Tracers and root then
                            local tracer = ESPTracers[player] or CreateTracer(player)
                            if tracer then
                                local screenPos, onScreen = cam:WorldToViewportPoint(root.Position)
                                if onScreen and screenPos.Z > 0 then
                                    tracer.From = screenCenter
                                    tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                                    tracer.Color = Settings.Visuals.TracersColor
                                    tracer.Visible = true
                                else
                                    tracer.Visible = false
                                end
                            end
                        else
                            if ESPTracers[player] then
                                ESPTracers[player].Visible = false
                            end
                        end
                    end
                end
            end
        end
    end
end

local function EnableESP()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateChams(player)
        end
    end
    
    -- Boxes render loop
    if not ESPConnections.render then
        ESPConnections.render = RunService.RenderStepped:Connect(UpdateBoxes)
    end
    
    ESPConnections.playerAdded = Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            CreateChams(player)
        end
    end)
    
    ESPConnections.playerRemoving = Players.PlayerRemoving:Connect(function(player)
        RemoveChams(player)
        RemoveBox(player)
        RemoveTracer(player)
        RemoveName(player)
        RemoveDistance(player)
        RemoveHealth(player)
    end)
end

local function DisableESP()
    if ESPConnections.render then
        ESPConnections.render:Disconnect()
        ESPConnections.render = nil
    end
    
    if ESPConnections.playerAdded then
        ESPConnections.playerAdded:Disconnect()
        ESPConnections.playerAdded = nil
    end
    
    if ESPConnections.playerRemoving then
        ESPConnections.playerRemoving:Disconnect()
        ESPConnections.playerRemoving = nil
    end
    
    for player, _ in pairs(ESPObjects) do
        RemoveChams(player)
    end
    
    for player, _ in pairs(ESPBoxes) do
        RemoveBox(player)
    end
    
    for player, _ in pairs(ESPTracers) do
        RemoveTracer(player)
    end
    
    for player, _ in pairs(ESPNames) do
        RemoveName(player)
    end
    
    for player, _ in pairs(ESPDistance) do
        RemoveDistance(player)
    end
    
    for player, _ in pairs(ESPHealth) do
        RemoveHealth(player)
    end
end

local function UpdateESP()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local esp = ESPObjects[player]
            
            if Settings.Visuals.Enabled then
                
                if not esp then
                    CreateChams(player)
                    esp = ESPObjects[player]
                end
                
                
                if esp and esp.highlight then
                    esp.highlight.Enabled = true
                    esp.highlight.FillColor = Settings.Visuals.ChamsColor
                end
            else
                
                if esp and esp.highlight then
                    esp.highlight.Enabled = false
                end
            end
        end
    end
end


local function GetCharacter(player)
    return player and player.Character
end

local function IsTeamMate(player)
    if not Settings.Aimbot.EnemiesOnly then return false end
    return player.Team == LocalPlayer.Team
end

local function IsAlive(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end

local function IsVisible(targetPart)
    if not Settings.Aimbot.VisibleCheck then return true end
    
    local localCharacter = GetCharacter(LocalPlayer)
    if not localCharacter then return false end
    
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {localCharacter}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true
    
    local result = workspace:Raycast(origin, direction, raycastParams)
    
    if result then
        return result.Instance:IsDescendantOf(targetPart.Parent)
    end
    
    return true
end

local function GetAimPart(character)
    local hitbox = Settings.Aimbot.Hitbox
    
    if hitbox == "Head" then
        return character:FindFirstChild("Head")
    elseif hitbox == "Head, Neck" then
        return character:FindFirstChild("Head") or character:FindFirstChild("UpperTorso")
    elseif hitbox == "Torso" then
        return character:FindFirstChild("UpperTorso") or character:FindFirstChild("HumanoidRootPart")
    elseif hitbox == "Random" then
        local parts = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}
        local randomPart = parts[math.random(1, #parts)]
        return character:FindFirstChild(randomPart)
    end
    
    return character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
end

local function GetClosestTarget()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()
    local viewportCenter = Camera.ViewportSize / 2
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not IsTeamMate(player) then
            local character = GetCharacter(player)
            
            if character and IsAlive(character) then
                local aimPart = GetAimPart(character)
                
                if aimPart then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
                    
                    if onScreen and screenPos.Z > 0 then
                        local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                        local distance = (viewportCenter - targetPos).Magnitude
                        local fovRadius = (Camera.ViewportSize.Y / 2) * Settings.Aimbot.FOV
                        
                        if distance < shortestDistance and distance <= fovRadius then
                            if IsVisible(aimPart) then
                                shortestDistance = distance
                                closestPlayer = player
                            end
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end



local function MoveMouseToTarget(targetPosition)
    local okP, p = pcall(function() return Camera:WorldToViewportPoint(targetPosition) end)
    if not okP or not p or p.Z <= 0 then return end
    
    local mousePos = UserInputService:GetMouseLocation()
    local dx = p.X - mousePos.X
    local dy = p.Y - mousePos.Y
    
    -- Apply smoothness
    local smoothFactor = Settings.Aimbot.Smoothness / 100
    dx = dx * smoothFactor
    dy = dy * smoothFactor
    
    local now = tick()
    local frameDt = 0
    if lastFrameTime then
        frameDt = now - lastFrameTime
    end
    lastFrameTime = now
    
    local dist = math.sqrt(dx*dx + dy*dy)
    if dist > 0.5 then
        local fpsScale = 1
        if frameDt and frameDt > 0 then
            local raw = 60 * frameDt
            local scale = math.sqrt(raw)
            if scale < 0.9 then scale = 0.9 end
            if scale > 2 then scale = 2 end
            fpsScale = scale
        end
        
        aimAccumX = aimAccumX + dx
        aimAccumY = aimAccumY + dy
        
        local toMoveX = 0
        local toMoveY = 0
        
        if aimAccumX >= 1 then
            toMoveX = math.floor(aimAccumX)
            aimAccumX = aimAccumX - toMoveX
        elseif aimAccumX <= -1 then
            toMoveX = math.ceil(aimAccumX)
            aimAccumX = aimAccumX - toMoveX
        end
        
        if aimAccumY >= 1 then
            toMoveY = math.floor(aimAccumY)
            aimAccumY = aimAccumY - toMoveY
        elseif aimAccumY <= -1 then
            toMoveY = math.ceil(aimAccumY)
            aimAccumY = aimAccumY - toMoveY
        end
        
        if toMoveX ~= 0 or toMoveY ~= 0 then
            toMoveX = math.clamp(toMoveX * fpsScale, -150, 150)
            toMoveY = math.clamp(toMoveY * fpsScale, -150, 150)
            mousemoverel(toMoveX, toMoveY)
        end
    end
end


local function AimLoop()
    -- Update Crosshair
    UpdateCrosshair()
    
    -- Update Speed
    UpdateSpeed()
    
    -- Update Jump Power
    UpdateJumpPower()
    
    -- Update Fullbright
    UpdateFullbright()
    
    -- Update Anti AFK
    UpdateAntiAFK()
    
    if Settings.Aimbot.DrawFOV then
        FOVCircle.Visible = true
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Radius = (Camera.ViewportSize.Y / 2) * Settings.Aimbot.FOV
    else
        FOVCircle.Visible = false
    end
    
    
    UpdateESP()
    
    if not Settings.Aimbot.Enabled then return end
    
    
    if Settings.Aimbot.AutoAim then
        if CurrentTarget then
            local character = GetCharacter(CurrentTarget)
            
            if character and IsAlive(character) then
                local aimPart = GetAimPart(character)
                
                if aimPart and IsVisible(aimPart) then
                    MoveMouseToTarget(aimPart.Position)
                    
                    
                    if Settings.Aimbot.AutoShoot then
                        mouse1click()
                    end
                    return
                end
            end
        end
        
        CurrentTarget = GetClosestTarget()
        
        if CurrentTarget then
            local character = GetCharacter(CurrentTarget)
            if character then
                local aimPart = GetAimPart(character)
                if aimPart then
                    MoveMouseToTarget(aimPart.Position)
                    
                    -- Auto Shoot
                    if Settings.Aimbot.AutoShoot then
                        mouse1click()
                    end
                end
            end
        end
    
    elseif Holding then
        if CurrentTarget then
            local character = GetCharacter(CurrentTarget)
            
            if character and IsAlive(character) then
                local aimPart = GetAimPart(character)
                
                if aimPart and IsVisible(aimPart) then
                    MoveMouseToTarget(aimPart.Position)
                    return
                end
            end
        end
        
        CurrentTarget = GetClosestTarget()
        
        if CurrentTarget then
            local character = GetCharacter(CurrentTarget)
            if character then
                local aimPart = GetAimPart(character)
                if aimPart then
                    MoveMouseToTarget(aimPart.Position)
                end
            end
        end
    end
end


UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local keyPressed = false
    if input.UserInputType == Enum.UserInputType.MouseButton1 and Settings.Aimbot.AimKey == "MouseButton1" then
        keyPressed = true
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 and Settings.Aimbot.AimKey == "MouseButton2" then
        keyPressed = true
    elseif input.KeyCode.Name == Settings.Aimbot.AimKey then
        keyPressed = true
    end
    
    if keyPressed then
        Holding = true
    end
    
    
    local autoAimKeyPressed = false
    if input.UserInputType == Enum.UserInputType.MouseButton1 and Settings.Aimbot.AutoAimKey == "MouseButton1" then
        autoAimKeyPressed = true
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 and Settings.Aimbot.AutoAimKey == "MouseButton2" then
        autoAimKeyPressed = true
    elseif input.KeyCode.Name == Settings.Aimbot.AutoAimKey then
        autoAimKeyPressed = true
    end
    
    if autoAimKeyPressed then
        Settings.Aimbot.AutoAim = not Settings.Aimbot.AutoAim
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Auto Aim";
            Text = Settings.Aimbot.AutoAim and "Enabled" or "Disabled";
            Duration = 2;
        })
    end
    
    if input.KeyCode == Enum.KeyCode.Insert then
        local gui = game:GetService("CoreGui"):FindFirstChild("FaerMenu")
        if gui then
            gui.Enabled = not gui.Enabled
        end
    end
    
    -- Panic Key
    if input.KeyCode.Name == Settings.UI.PanicKey then
        Settings.Aimbot.Enabled = false
        Settings.Visuals.Enabled = false
        Settings.Misc.SpeedHack = false
        Settings.Misc.FlyMode = false
        Flying = false
        ToggleFly()
        local gui = game:GetService("CoreGui"):FindFirstChild("FaerMenu")
        if gui then
            gui:Destroy()
        end
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Panic Mode";
            Text = "All features disabled!";
            Duration = 2;
        })
    end
    
    -- Fly Mode Toggle
    if input.KeyCode == Enum.KeyCode.F then
        Settings.Misc.FlyMode = not Settings.Misc.FlyMode
        ToggleFly()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Fly Mode";
            Text = Settings.Misc.FlyMode and "Enabled" or "Disabled";
            Duration = 2;
        })
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and Settings.Aimbot.AimKey == "MouseButton1" then
        Holding = false
        CurrentTarget = nil
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 and Settings.Aimbot.AimKey == "MouseButton2" then
        Holding = false
        CurrentTarget = nil
    elseif input.KeyCode.Name == Settings.Aimbot.AimKey then
        Holding = false
        CurrentTarget = nil
    end
end)

RunService.RenderStepped:Connect(AimLoop)
CreateMenu()
EnableESP()

print("=================================")
print("Faer Script loaded!")
print("INSERT - open menu")
print("=================================")

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Faer Script";
    Text = "INSERT - menu";
    Duration = 3;
})

return Settings

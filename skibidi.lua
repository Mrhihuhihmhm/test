-- Atlas UI Library
local AtlasLib = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Variables
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- UI Settings
local UISettings = {
    MainColor = Color3.fromRGB(25, 25, 35),
    SecondaryColor = Color3.fromRGB(32, 32, 42),
    AccentColor = Color3.fromRGB(82, 82, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamSemibold,
    TweenSpeed = 0.15,
    ToggleSize = 20
}

-- Create Window
function AtlasLib:CreateWindow(WindowName)
    -- Remove existing UI if it exists
    if game:GetService("CoreGui"):FindFirstChild("AtlasUI") then
        game:GetService("CoreGui"):FindFirstChild("AtlasUI"):Destroy()
    end

    -- Create new UI
    local Window = {}
    
    -- Main GUI
    local AtlasUI = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local TopBar = Instance.new("Frame")
    local TopBarCorner = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")
    local CloseButton = Instance.new("TextButton")
    local MinimizeButton = Instance.new("TextButton")
    local TabHolder = Instance.new("ScrollingFrame")
    local TabList = Instance.new("UIListLayout")
    local ContentContainer = Instance.new("Frame")
    
    -- GUI Protection
    if syn then
        syn.protect_gui(AtlasUI)
        AtlasUI.Parent = game:GetService("CoreGui")
    elseif gethui then
        AtlasUI.Parent = gethui()
    else
        AtlasUI.Parent = game:GetService("CoreGui")
    end
    
    AtlasUI.Name = "AtlasUI"
    AtlasUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    AtlasUI.ResetOnSpawn = false
    AtlasUI.DisplayOrder = 999999999
    
    -- Main Frame
    Main.Name = "Main"
    Main.Parent = AtlasUI
    Main.BackgroundColor3 = UISettings.MainColor
    Main.Position = UDim2.new(0.5, -300, 0.5, -175)
    Main.Size = UDim2.new(0, 600, 0, 350)
    Main.ClipsDescendants = true
    Main.Active = true
    Main.Draggable = true
    
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Main
    
    -- Top Bar
    TopBar.Name = "TopBar"
    TopBar.Parent = Main
    TopBar.BackgroundColor3 = UISettings.SecondaryColor
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    
    TopBarCorner.CornerRadius = UDim.new(0, 6)
    TopBarCorner.Parent = TopBar
    
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(1, -90, 1, 0)
    Title.Font = UISettings.Font
    Title.Text = WindowName
    Title.TextColor3 = UISettings.TextColor
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -25, 0, 5)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Font = UISettings.Font
    CloseButton.Text = "×"
    CloseButton.TextColor3 = UISettings.TextColor
    CloseButton.TextSize = 20
    
    CloseButton.MouseButton1Click:Connect(function()
        AtlasUI:Destroy()
    end)
    
    -- Minimize Button
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TopBar
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -50, 0, 5)
    MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
    MinimizeButton.Font = UISettings.Font
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = UISettings.TextColor
    MinimizeButton.TextSize = 20
    
    local Minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            Main:TweenSize(UDim2.new(0, 600, 0, 30), "Out", "Quad", 0.3, true)
        else
            Main:TweenSize(UDim2.new(0, 600, 0, 350), "Out", "Quad", 0.3, true)
        end
    end)
    
    -- Tab Holder
    TabHolder.Name = "TabHolder"
    TabHolder.Parent = Main
    TabHolder.BackgroundColor3 = UISettings.SecondaryColor
    TabHolder.BackgroundTransparency = 0.5
    TabHolder.Position = UDim2.new(0, 5, 0, 35)
    TabHolder.Size = UDim2.new(0, 140, 1, -40)
    TabHolder.ScrollBarThickness = 2
    TabHolder.ScrollBarImageColor3 = UISettings.AccentColor
    
    TabList.Parent = TabHolder
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    
    -- Content Container
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = Main
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 150, 0, 35)
    ContentContainer.Size = UDim2.new(1, -155, 1, -40)
    
    -- Create Tab Function
    function Window:CreateTab(TabName)
        local Tab = {}
        
        local TabButton = Instance.new("TextButton")
        local TabButtonCorner = Instance.new("UICorner")
        local TabContent = Instance.new("ScrollingFrame")
        local ContentList = Instance.new("UIListLayout")
        
        TabButton.Name = "TabButton"
        TabButton.Parent = TabHolder
        TabButton.BackgroundColor3 = UISettings.SecondaryColor
        TabButton.Size = UDim2.new(1, -10, 0, 30)
        TabButton.Text = TabName
        TabButton.TextColor3 = UISettings.TextColor
        TabButton.Font = UISettings.Font
        TabButton.TextSize = 14
        TabButton.AutoButtonColor = false
        
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton
        
        TabContent.Name = "TabContent"
        TabContent.Parent = ContentContainer
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, -5, 1, 0)
        TabContent.ScrollBarThickness = 2
        TabContent.ScrollBarImageColor3 = UISettings.AccentColor
        TabContent.Visible = false
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        ContentList.Parent = TabContent
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 5)
        
        -- Tab Button Click Handler
        TabButton.MouseButton1Click:Connect(function()
            for _, content in pairs(ContentContainer:GetChildren()) do
                if content:IsA("ScrollingFrame") then
                    content.Visible = false
                end
            end
            TabContent.Visible = true
            
            for _, button in pairs(TabHolder:GetChildren()) do
                if button:IsA("TextButton") then
                    TweenService:Create(button, TweenInfo.new(UISettings.TweenSpeed), {
                        BackgroundColor3 = UISettings.SecondaryColor
                    }):Play()
                end
            end
            
            TweenService:Create(TabButton, TweenInfo.new(UISettings.TweenSpeed), {
                BackgroundColor3 = UISettings.AccentColor
            }):Play()
        end)
        
        -- Show first tab by default
        if #TabHolder:GetChildren() == 2 then
            TabContent.Visible = true
            TabButton.BackgroundColor3 = UISettings.AccentColor
        end
        
        -- Create Button
        function Tab:CreateButton(ButtonText, Callback)
            local Button = Instance.new("TextButton")
            local ButtonCorner = Instance.new("UICorner")
            
            Button.Name = "Button"
            Button.Parent = TabContent
            Button.BackgroundColor3 = UISettings.SecondaryColor
            Button.Size = UDim2.new(1, -10, 0, 30)
            Button.Text = ButtonText
            Button.TextColor3 = UISettings.TextColor
            Button.Font = UISettings.Font
            Button.TextSize = 14
            Button.AutoButtonColor = false
            
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button
            
            -- Click Effect
            Button.MouseButton1Click:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    BackgroundColor3 = UISettings.AccentColor
                }):Play()
                wait(0.1)
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    BackgroundColor3 = UISettings.SecondaryColor
                }):Play()
                
                Callback()
            end)
            
            -- Hover Effect
            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(UISettings.TweenSpeed), {
                    BackgroundColor3 = Color3.fromRGB(
                        UISettings.SecondaryColor.R * 255 + 20,
                        UISettings.SecondaryColor.G * 255 + 20,
                        UISettings.SecondaryColor.B * 255 + 20
                    ) / 255
                }):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(UISettings.TweenSpeed), {
                    BackgroundColor3 = UISettings.SecondaryColor
                }):Play()
            end)
        end
        
        -- Create Toggle
        function Tab:CreateToggle(ToggleText, Default, Callback)
            local Toggle = Instance.new("Frame")
            local ToggleCorner = Instance.new("UICorner")
            local Title = Instance.new("TextLabel")
            local ToggleButton = Instance.new("TextButton")
            local ToggleButtonCorner = Instance.new("UICorner")
            local ToggleInner = Instance.new("Frame")
            local ToggleInnerCorner = Instance.new("UICorner")
            
            Toggle.Name = "Toggle"
            Toggle.Parent = TabContent
            Toggle.BackgroundColor3 = UISettings.SecondaryColor
            Toggle.Size = UDim2.new(1, -10, 0, 30)
            
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = Toggle
            
            Title.Name = "Title"
            Title.Parent = Toggle
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.Size = UDim2.new(1, -50, 1, 0)
            Title.Font = UISettings.Font
            Title.Text = ToggleText
            Title.TextColor3 = UISettings.TextColor
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Parent = Toggle
            ToggleButton.BackgroundColor3 = UISettings.MainColor
            ToggleButton.Position = UDim2.new(1, -35, 0.5, -10)
            ToggleButton.Size = UDim2.new(0, UISettings.ToggleSize, 0, UISettings.ToggleSize)
            ToggleButton.AutoButtonColor = false
            ToggleButton.Text = ""
            
            ToggleButtonCorner.CornerRadius = UDim.new(0, 4)
            ToggleButtonCorner.Parent = ToggleButton
            
            ToggleInner.Name = "ToggleInner"
            ToggleInner.Parent = ToggleButton
            ToggleInner.AnchorPoint = Vector2.new(0.5, 0.5)
            ToggleInner.BackgroundColor3 = Default and UISettings.AccentColor or UISettings.MainColor
            ToggleInner.Position = UDim2.new(0.5, 0, 0.5, 0)
            ToggleInner.Size = UDim2.new(0, UISettings.ToggleSize - 6, 0, UISettings.ToggleSize - 6)
            
            ToggleInnerCorner.CornerRadius = UDim.new(0, 4)
            ToggleInnerCorner.Parent = ToggleInner
            
            local Toggled = Default
            local function UpdateToggle()
                TweenService:Create(ToggleInner, TweenInfo.new(UISettings.TweenSpeed), {
                    BackgroundColor3 = Toggled and UISettings.AccentColor or UISettings.MainColor
                }):Play()
                Callback(Toggled)
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                UpdateToggle()
            end)
            
            -- Initialize
            UpdateToggle()
        end
        
        -- Create Slider
        function Tab:CreateSlider(SliderText, Min, Max, Default, Callback)
            local Slider = Instance.new("Frame")
            local SliderCorner = Instance.new("UICorner")
            local Title = Instance.new("TextLabel")
            local SliderBar = Instance.new("Frame")
            local SliderBarCorner = Instance.new("UICorner")
            local SliderFill = Instance.new("Frame")
            local SliderFillCorner = Instance.new("UICorner")
            local Value = Instance.new("TextLabel")
            
            Slider.Name = "Slider"
            Slider.Parent = TabContent
            Slider.BackgroundColor3 = UISettings.SecondaryColor
            Slider.Size = UDim2.new(1, -10, 0, 45)
            
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = Slider
            
            Title.Name = "Title"
            Title.Parent = Slider
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.Size = UDim2.new(1, -60, 0, 25)
            Title.Font = UISettings.Font
            Title.Text = SliderText
            Title.TextColor3 = UISettings.TextColor
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            Value.Name = "Value"
            Value.Parent = Slider
            Value.BackgroundTransparency = 1
            Value.Position = UDim2.new(1, -50, 0, 0)
            Value.Size = UDim2.new(0, 40, 0, 25)
            Value.Font = UISettings.Font
            Value.Text = tostring(Default)
            Value.TextColor3 = UISettings.TextColor
            Value.TextSize = 14
            
            SliderBar.Name = "SliderBar"
            SliderBar.Parent = Slider
            SliderBar.BackgroundColor3 = UISettings.MainColor
            SliderBar.Position = UDim2.new(0, 10, 0, 30)
            SliderBar.Size = UDim2.new(1, -20, 0, 4)
            
            SliderBarCorner.CornerRadius = UDim.new(0, 2)
            SliderBarCorner.Parent = SliderBar
            
            SliderFill.Name = "SliderFill"
            SliderFill.Parent = SliderBar
            SliderFill.BackgroundColor3 = UISettings.AccentColor
            SliderFill.Size = UDim2.new((Default - Min)/(Max - Min), 0, 1, 0)
            
            SliderFillCorner.CornerRadius = UDim.new(0, 2)
            SliderFillCorner.Parent = SliderFill
            
            local Dragging = false
            
            local function UpdateSlider(input)
                local SizeScale = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                local ValueToSet = math.floor(Min + ((Max - Min) * SizeScale))
                
                TweenService:Create(SliderFill, TweenInfo.new(UISettings.TweenSpeed), {
                    Size = UDim2.new(SizeScale, 0, 1, 0)
                }):Play()
                
                Value.Text = tostring(ValueToSet)
                Callback(ValueToSet)
            end
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = true
                    UpdateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
            end)
        end
        
        return Tab
    end
    
    return Window
end

return AtlasLib

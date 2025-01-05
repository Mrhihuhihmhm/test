local themes = {
    SchemeColor = Color3.fromRGB(64, 64, 64), -- Main accent color
    Background = Color3.fromRGB(20, 20, 20), -- Main background
    Header = Color3.fromRGB(15, 15, 15), -- Header background
    TextColor = Color3.fromRGB(240, 240, 240), -- Text color
    ElementColor = Color3.fromRGB(25, 25, 25) -- Element background
}

local themeStyles = {
    Default = {
        SchemeColor = Color3.fromRGB(64, 64, 64),
        Background = Color3.fromRGB(20, 20, 20),
        Header = Color3.fromRGB(15, 15, 15),
        TextColor = Color3.fromRGB(240, 240, 240),
        ElementColor = Color3.fromRGB(25, 25, 25)
    },
    Light = {
        SchemeColor = Color3.fromRGB(150, 150, 150),
        Background = Color3.fromRGB(255, 255, 255),
        Header = Color3.fromRGB(200, 200, 200),
        TextColor = Color3.fromRGB(0, 0, 0),
        ElementColor = Color3.fromRGB(224, 224, 224)
    },
    Dark = {
        SchemeColor = Color3.fromRGB(50, 50, 50),
        Background = Color3.fromRGB(15, 15, 15),
        Header = Color3.fromRGB(10, 10, 10),
        TextColor = Color3.fromRGB(240, 240, 240),
        ElementColor = Color3.fromRGB(20, 20, 20)
    },
    Midnight = {
        SchemeColor = Color3.fromRGB(30, 30, 35),
        Background = Color3.fromRGB(20, 20, 25),
        Header = Color3.fromRGB(15, 15, 20),
        TextColor = Color3.fromRGB(240, 240, 245),
        ElementColor = Color3.fromRGB(25, 25, 30)
    },
    Ocean = {
        SchemeColor = Color3.fromRGB(35, 85, 120),
        Background = Color3.fromRGB(20, 40, 60),
        Header = Color3.fromRGB(15, 30, 45),
        TextColor = Color3.fromRGB(240, 240, 240),
        ElementColor = Color3.fromRGB(25, 50, 75)
    }
}

local function UpdateCornerRadius(object, radius)
    for _, child in pairs(object:GetChildren()) do
        if child:IsA("UICorner") then
            child.CornerRadius = UDim.new(0, radius)
        end
    end
end

local function AddShadow(object)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 12, 1, 12)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0,0,0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23,23,277,277)
    shadow.Parent = object
end

local Utility = {}

function Utility:TweenObject(obj, properties, duration, ...)
    local tweenInfo = TweenInfo.new(
        duration or 0.2, 
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )
    game:GetService("TweenService"):Create(obj, tweenInfo, properties):Play()
end

function Utility:Pop(object, shrink)
    local clone = object:Clone()
    clone.AnchorPoint = Vector2.new(0.5, 0.5)
    clone.Size = object.Size - UDim2.new(0, shrink or 4, 0, shrink or 4)
    clone.Position = UDim2.new(0.5, 0, 0.5, 0)
    clone.Parent = object
    game:GetService("TweenService"):Create(clone, TweenInfo.new(0.2), {
        Size = object.Size + UDim2.new(0, shrink or 4, 0, shrink or 4),
        ImageTransparency = 1
    }):Play()
    game.Debris:AddItem(clone, 0.2)
end

function Utility:SmoothScroll(object, duration)
    local ts = game:GetService("TweenService")
    local function smooth(frame)
        local function update(input)
            local delta = input.Position - frame.AbsolutePosition
            ts:Create(frame, TweenInfo.new(duration or 0.2), {
                Position = UDim2.new(
                    frame.Position.X.Scale,
                    frame.Position.X.Offset + delta.X,
                    frame.Position.Y.Scale,
                    frame.Position.Y.Offset + delta.Y
                )
            }):Play()
        end
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                update(input)
            end
        end)
    end
    smooth(object)
end

function Elements:CreateModernElement(elementType)
    local element = Instance.new(elementType)
    element.BackgroundColor3 = themeList.ElementColor
    
    -- Add rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = element
    
    -- Add shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 12, 1, 12)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0,0,0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23,23,277,277)
    shadow.Parent = element
    
    -- Add hover effect
    local hovering = false
    element.MouseEnter:Connect(function()
        if not focusing then
            hovering = true
            Utility:TweenObject(element, {
                BackgroundColor3 = Color3.fromRGB(
                    themeList.ElementColor.r * 255 + 8,
                    themeList.ElementColor.g * 255 + 9, 
                    themeList.ElementColor.b * 255 + 10
                )
            }, 0.2)
            Utility:TweenObject(shadow, {ImageTransparency = 0.85}, 0.2)
        end
    end)
    element.MouseLeave:Connect(function()
        if not focusing then
            hovering = false
            Utility:TweenObject(element, {BackgroundColor3 = themeList.ElementColor}, 0.2)
            Utility:TweenObject(shadow, {ImageTransparency = 0.8}, 0.2)
        end
    end)
    
    return element
end

function Kavo:CreateLib(kavName, themeList)
    kavName = kavName or "Modern UI Library"
    themeList = themeList or themes
    
    -- Create main UI elements
    local ScreenGui = Instance.new("ScreenGui")
    local Main = Elements:CreateModernElement("Frame")
    local MainHeader = Elements:CreateModernElement("Frame")
    local MainSide = Elements:CreateModernElement("Frame")
    
    -- Set up ScreenGui
    ScreenGui.Name = LibName
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Set up Main frame
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = themeList.Background
    Main.Position = UDim2.new(0.336503863, 0, 0.275485456, 0)
    Main.Size = UDim2.new(0, 525, 0, 318)
    Main.ClipsDescendants = true
    
    -- Set up Header
    MainHeader.Name = "MainHeader"
    MainHeader.Parent = Main
    MainHeader.BackgroundColor3 = themeList.Header
    MainHeader.Size = UDim2.new(1, 0, 0, 29)
    
    -- Add title text
    local title = Instance.new("TextLabel")
    title.Name = "title"
    title.Parent = MainHeader
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0.0171428565, 0, 0.344827592, 0)
    title.Size = UDim2.new(0, 204, 0, 8)
    title.Font = Enum.Font.GothamBold
    title.Text = kavName
    title.TextColor3 = themeList.TextColor
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Set up Side panel
    MainSide.Name = "MainSide"
    MainSide.Parent = Main
    MainSide.BackgroundColor3 = themeList.Header
    MainSide.Position = UDim2.new(0, 0, 0.0911949649, 0)
    MainSide.Size = UDim2.new(0, 149, 0, 289)
    
    -- Make UI draggable
    Kavo:DraggingEnabled(MainHeader, Main)
    
    -- Add smooth scrolling
    Utility:SmoothScroll(MainSide)
    
    -- Add close button with modern styling
    local closeBtn = Elements:CreateModernElement("ImageButton") 
    closeBtn.Name = "close"
    closeBtn.Parent = MainHeader
    closeBtn.BackgroundTransparency = 1
    closeBtn.Position = UDim2.new(0.949999988, 0, 0.137999997, 0)
    closeBtn.Size = UDim2.new(0, 21, 0, 21)
    closeBtn.Image = "rbxassetid://3926305904"
    closeBtn.ImageRectOffset = Vector2.new(284, 4)
    closeBtn.ImageRectSize = Vector2.new(24, 24)
    closeBtn.MouseButton1Click:Connect(function()
        Utility:TweenObject(closeBtn, {ImageTransparency = 1}, 0.1)
        Utility:TweenObject(Main, {
            Size = UDim2.new(0,0,0,0),
            Position = UDim2.new(0, Main.AbsolutePosition.X + (Main.AbsoluteSize.X / 2), 0, Main.AbsolutePosition.Y + (Main.AbsoluteSize.Y / 2))
        }, 0.2)
        wait(0.2)
        ScreenGui:Destroy()
    end)

    return Main
end

-- Add modern styling to buttons
function Elements:NewButton(bname, tipINf, callback)
    local ButtonFunction = {}
    tipINf = tipINf or "Tip: Clicking this nothing will happen!"
    bname = bname or "Click Me!"
    callback = callback or function() end

    local buttonElement = Elements:CreateModernElement("TextButton")
    buttonElement.Name = bname
    buttonElement.Parent = sectionInners
    buttonElement.Size = UDim2.new(0, 352, 0, 33)
    buttonElement.AutoButtonColor = false
    buttonElement.Font = Enum.Font.GothamSemibold
    buttonElement.TextColor3 = themeList.TextColor
    buttonElement.TextSize = 14.000
    buttonElement.Text = "  "..bname
    buttonElement.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Add ripple effect
    local Sample = Instance.new("ImageLabel")
    Sample.Name = "Sample"
    Sample.Parent = buttonElement
    Sample.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Sample.BackgroundTransparency = 1.000
    Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
    Sample.ImageColor3 = themeList.SchemeColor
    Sample.ImageTransparency = 0.600

    -- Add info icon
    local viewInfo = Instance.new("ImageButton")
    viewInfo.Name = "viewInfo"
    viewInfo.Parent = buttonElement
    viewInfo.BackgroundTransparency = 1.000
    viewInfo.Position = UDim2.new(0.930000007, 0, 0.151999995, 0)
    viewInfo.Size = UDim2.new(0, 23, 0, 23)
    viewInfo.Image = "rbxassetid://3926305904"
    viewInfo.ImageColor3 = themeList.SchemeColor
    viewInfo.ImageRectOffset = Vector2.new(764, 764)
    viewInfo.ImageRectSize = Vector2.new(36, 36)

    -- Add modern hover effect
    local hovering = false
    buttonElement.MouseEnter:Connect(function()
        if not focusing then
            hovering = true
            Utility:TweenObject(buttonElement, {
                BackgroundColor3 = Color3.fromRGB(
                    themeList.ElementColor.r * 255 + 8,
                    themeList.ElementColor.g * 255 + 9,
                    themeList.ElementColor.b * 255 + 10
                )
            }, 0.2)
        end
    end)
    buttonElement.MouseLeave:Connect(function()
        if not focusing then
            hovering = false
            Utility:TweenObject(buttonElement, {
                BackgroundColor3 = themeList.ElementColor
            }, 0.2)
        end
    end)

    -- Click effect
    buttonElement.MouseButton1Click:Connect(function()
        if not focusing then
            callback()
            Utility:Pop(buttonElement)
            local c = Sample:Clone()
            c.Parent = buttonElement
            local x, y = (mouse.X - c.AbsolutePosition.X), (mouse.Y - c.AbsolutePosition.Y)
            c.Position = UDim2.new(0, x, 0, y)
            local len, size = 0.35, nil
            if buttonElement.AbsoluteSize.X >= buttonElement.AbsoluteSize.Y then
                size = (buttonElement.AbsoluteSize.X * 1.5)
            else
                size = (buttonElement.AbsoluteSize.Y * 1.5)
            end
            c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
            for i = 1, 10 do
                c.ImageTransparency = c.ImageTransparency + 0.05
                wait(len / 12)
            end
            c:Destroy()
        end
    end)

    -- Add info tooltip
    local moreInfo = Instance.new("TextLabel")
    local UICorner = Instance.new("UICorner")
    
    moreInfo.Name = "TipMore"
    moreInfo.Parent = infoContainer
    moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
    moreInfo.Position = UDim2.new(0, 0, 2, 0)
    moreInfo.Size = UDim2.new(0, 353, 0, 33)
    moreInfo.ZIndex = 9
    moreInfo.Font = Enum.Font.GothamSemibold
    moreInfo.Text = "  "..tipINf
    moreInfo.TextColor3 = themeList.TextColor
    moreInfo.TextSize = 14.000
    moreInfo.TextXAlignment = Enum.TextXAlignment.Left
    moreInfo.RichText = true

    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = moreInfo

    -- Info button functionality
    viewInfo.MouseButton1Click:Connect(function()
        if not viewDe then
            viewDe = true
            focusing = true
            for i,v in next, infoContainer:GetChildren() do
                if v ~= moreInfo then
                    Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2)
                end
            end
            Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,0,0)}, 0.2)
            Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
            wait(1.5)
            focusing = false
            Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,2,0)}, 0.2)
            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
            wait(0)
            viewDe = false
        end
    end)

    -- Update theme colors
    coroutine.wrap(function()
        while wait() do
            if not hovering then
                buttonElement.BackgroundColor3 = themeList.ElementColor
            end
            buttonElement.TextColor3 = themeList.TextColor
            Sample.ImageColor3 = themeList.SchemeColor
            viewInfo.ImageColor3 = themeList.SchemeColor
            moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
            moreInfo.TextColor3 = themeList.TextColor
        end
    end)()

    function ButtonFunction:UpdateButton(newText)
        buttonElement.Text = "  "..newText
    end
    
    return ButtonFunction
end

function Elements:NewSlider(slidInf, slidTip, maxvalue, minvalue, callback)
    slidInf = slidInf or "Slider"
    slidTip = slidTip or "Slider tip here"
    maxvalue = maxvalue or 500
    minvalue = minvalue or 16
    callback = callback or function() end

    local sliderElement = Elements:CreateModernElement("Frame")
    sliderElement.Name = "sliderElement"
    sliderElement.Parent = sectionInners
    sliderElement.Size = UDim2.new(0, 352, 0, 33)

    -- Add slider title
    local title = Instance.new("TextLabel")
    title.Name = "title"
    title.Parent = sliderElement
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0.0171428565, 0, 0.272727281, 0)
    title.Size = UDim2.new(0, 138, 0, 14)
    title.Font = Enum.Font.GothamSemibold
    title.Text = slidInf
    title.TextColor3 = themeList.TextColor
    title.TextSize = 14.000
    title.TextXAlignment = Enum.TextXAlignment.Left

    -- Add modern slider bar
    local sliderBar = Instance.new("Frame")
    sliderBar.Name = "sliderBar"
    sliderBar.Parent = sliderElement
    sliderBar.BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.r * 255 + 5, themeList.ElementColor.g * 255 + 5, themeList.ElementColor.b * 255 + 5)
    sliderBar.Position = UDim2.new(0.488749951, 0, 0.393939406, 0)
    sliderBar.Size = UDim2.new(0, 149, 0, 6)
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 3)
    barCorner.Parent = sliderBar

    -- Add slider fill
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "sliderFill"
    sliderFill.Parent = sliderBar
    sliderFill.BackgroundColor3 = themeList.SchemeColor
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = sliderFill

    -- Add slider knob
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Name = "sliderKnob"
    sliderKnob.Parent = sliderFill
    sliderKnob.AnchorPoint = Vector2.new(1, 0.5)
    sliderKnob.BackgroundColor3 = themeList.SchemeColor
    sliderKnob.Position = UDim2.new(1, 0, 0.5, 0)
    sliderKnob.Size = UDim2.new(0, 12, 0, 12)
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = sliderKnob

    -- Add value display
    local valueDisplay = Instance.new("TextLabel")
    valueDisplay.Name = "valueDisplay"
    valueDisplay.Parent = sliderElement
    valueDisplay.BackgroundTransparency = 1
    valueDisplay.Position = UDim2.new(0.352386296, 0, 0.272727281, 0)
    valueDisplay.Size = UDim2.new(0, 41, 0, 14)
    valueDisplay.Font = Enum.Font.GothamSemibold
    valueDisplay.Text = tostring(minvalue)
    valueDisplay.TextColor3 = themeList.SchemeColor
    valueDisplay.TextSize = 14.000
    valueDisplay.TextXAlignment = Enum.TextXAlignment.Right

    -- Add info button
    local viewInfo = Instance.new("ImageButton")
    viewInfo.Name = "viewInfo"
    viewInfo.Parent = sliderElement
    viewInfo.BackgroundTransparency = 1
    viewInfo.Position = UDim2.new(0.930000007, 0, 0.151999995, 0)
    viewInfo.Size = UDim2.new(0, 23, 0, 23)
    viewInfo.Image = "rbxassetid://3926305904"
    viewInfo.ImageColor3 = themeList.SchemeColor
    viewInfo.ImageRectOffset = Vector2.new(764, 764)
    viewInfo.ImageRectSize = Vector2.new(36, 36)

    -- Add tooltip
    local moreInfo = Instance.new("TextLabel")
    local UICorner = Instance.new("UICorner")
    moreInfo.Name = "TipMore"
    moreInfo.Parent = infoContainer
    moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
    moreInfo.Position = UDim2.new(0, 0, 2, 0)
    moreInfo.Size = UDim2.new(0, 353, 0, 33)
    moreInfo.ZIndex = 9
    moreInfo.Font = Enum.Font.GothamSemibold
    moreInfo.Text = "  "..slidTip
    moreInfo.TextColor3 = themeList.TextColor
    moreInfo.TextSize = 14.000
    moreInfo.TextXAlignment = Enum.TextXAlignment.Left
    moreInfo.RichText = true
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = moreInfo

    -- Slider functionality
    local mouse = game:GetService("Players").LocalPlayer:GetMouse()
    local uis = game:GetService("UserInputService")
    local Value
    local dragging = false

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 149) * sliderFill.AbsoluteSize.X) + tonumber(minvalue))
            pcall(function()
                callback(Value)
            end)
            Utility:TweenObject(sliderFill, {Size = UDim2.new(0, math.clamp(mouse.X - sliderFill.AbsolutePosition.X, 0, 149), 1, 0)}, 0.1)
            valueDisplay.Text = Value
            moveconnection = mouse.Move:Connect(function()
                Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 149) * sliderFill.AbsoluteSize.X) + tonumber(minvalue))
                pcall(function()
                    callback(Value)
                end)
                valueDisplay.Text = Value
                Utility:TweenObject(sliderFill, {Size = UDim2.new(0, math.clamp(mouse.X - sliderFill.AbsolutePosition.X, 0, 149), 1, 0)}, 0.1)
            end)
            releaseconnection = uis.InputEnded:Connect(function(Mouse)
                if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    moveconnection:Disconnect()
                    releaseconnection:Disconnect()
                end
            end)
        end
    end)

    -- Info button functionality
    viewInfo.MouseButton1Click:Connect(function()
        if not viewDe then
            viewDe = true
            focusing = true
            for i,v in next, infoContainer:GetChildren() do
                if v ~= moreInfo then
                    Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2)
                end
            end
            Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,0,0)}, 0.2)
            Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
            wait(1.5)
            focusing = false
            Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,2,0)}, 0.2)
            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
            wait(0)
            viewDe = false
        end
    end)

    -- Update theme colors
    coroutine.wrap(function()
        while wait() do
            sliderBar.BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.r * 255 + 5, themeList.ElementColor.g * 255 + 5, themeList.ElementColor.b * 255 + 5)
            sliderFill.BackgroundColor3 = themeList.SchemeColor
            sliderKnob.BackgroundColor3 = themeList.SchemeColor
            title.TextColor3 = themeList.TextColor
            valueDisplay.TextColor3 = themeList.SchemeColor
            viewInfo.ImageColor3 = themeList.SchemeColor
            moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
            moreInfo.TextColor3 = themeList.TextColor
        end
    end)()
end

local function ApplyVisualUpdates(element)
    -- Add subtle shadow
    AddShadow(element)
    
    -- Update corner radius
    UpdateCornerRadius(element, 4)
    
    -- Add hover effect
    local originalColor = element.BackgroundColor3
    element.MouseEnter:Connect(function()
        if not focusing then
            game:GetService("TweenService"):Create(element, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(
                    originalColor.R * 255 + 8,
                    originalColor.G * 255 + 8,
                    originalColor.B * 255 + 8
                )
            }):Play()
        end
    end)
    element.MouseLeave:Connect(function()
        if not focusing then
            game:GetService("TweenService"):Create(element, TweenInfo.new(0.2), {
                BackgroundColor3 = originalColor
            }):Play()
        end
    end)
end

-- Hook into original Kavo element creation
local oldNewButton = Elements.NewButton
Elements.NewButton = function(self, ...)
    local btn = oldNewButton(self, ...)
    ApplyVisualUpdates(btn)
    return btn
end

local oldNewSlider = Elements.NewSlider
Elements.NewSlider = function(self, ...)
    local slider = oldNewSlider(self, ...)
    ApplyVisualUpdates(slider)
    return slider
end

local oldNewToggle = Elements.NewToggle
Elements.NewToggle = function(self, ...)
    local toggle = oldNewToggle(self, ...)
    ApplyVisualUpdates(toggle)
    return toggle
end

local oldNewDropdown = Elements.NewDropdown
Elements.NewDropdown = function(self, ...)
    local dropdown = oldNewDropdown(self, ...)
    ApplyVisualUpdates(dropdown)
    return dropdown
end

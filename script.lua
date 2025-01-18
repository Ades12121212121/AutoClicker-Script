-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")  -- Añadimos VirtualUser para clicks más confiables

-- UI Components
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local StatusFrame = Instance.new("Frame")
local StatusLabel = Instance.new("TextLabel")
local StatusIndicator = Instance.new("Frame")
local IntervalFrame = Instance.new("Frame")
local IntervalLabel = Instance.new("TextLabel")
local IntervalInput = Instance.new("TextBox")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

-- Initialize Variables
local Player = Players.LocalPlayer
local isActive = false
local clickInterval = 1

-- Style Constants
local COLORS = {
    BACKGROUND = Color3.fromRGB(22, 27, 34),
    ACCENT = Color3.fromRGB(0, 216, 255),
    TEXT = Color3.fromRGB(255, 255, 255),
    BUTTON_ACTIVE = Color3.fromRGB(57, 255, 20),
    BUTTON_INACTIVE = Color3.fromRGB(255, 0, 191)
}

-- GUI Setup
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "AutoClickerGUI"
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = COLORS.BACKGROUND
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Add smooth corners to main frame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Title Setup
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Auto Clicker | v1"
Title.TextColor3 = COLORS.TEXT
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Status Display
StatusFrame.Size = UDim2.new(0.9, 0, 0, 30)
StatusFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
StatusFrame.BackgroundTransparency = 1
StatusFrame.Parent = MainFrame

StatusLabel.Size = UDim2.new(0.5, 0, 1, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Estado:"
StatusLabel.TextColor3 = COLORS.TEXT
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = StatusFrame

StatusIndicator.Size = UDim2.new(0.4, 0, 0.8, 0)
StatusIndicator.Position = UDim2.new(0.55, 0, 0.1, 0)
StatusIndicator.BackgroundColor3 = COLORS.BUTTON_INACTIVE
StatusIndicator.Parent = StatusFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 15)
StatusCorner.Parent = StatusIndicator

-- Interval Control
IntervalFrame.Size = UDim2.new(0.9, 0, 0, 30)
IntervalFrame.Position = UDim2.new(0.05, 0, 0.5, 0)
IntervalFrame.BackgroundTransparency = 1
IntervalFrame.Parent = MainFrame

IntervalLabel.Size = UDim2.new(0.5, 0, 1, 0)
IntervalLabel.BackgroundTransparency = 1
IntervalLabel.Text = "Intervalo (s):"
IntervalLabel.TextColor3 = COLORS.TEXT
IntervalLabel.TextXAlignment = Enum.TextXAlignment.Left
IntervalLabel.Font = Enum.Font.Gotham
IntervalLabel.Parent = IntervalFrame

IntervalInput.Size = UDim2.new(0.4, 0, 1, 0)
IntervalInput.Position = UDim2.new(0.55, 0, 0, 0)
IntervalInput.BackgroundColor3 = COLORS.BACKGROUND
IntervalInput.TextColor3 = COLORS.ACCENT
IntervalInput.Text = "1.0"
IntervalInput.Font = Enum.Font.GothamSemibold
IntervalInput.Parent = IntervalFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 8)
InputCorner.Parent = IntervalInput

-- Toggle Button
ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
ToggleButton.Position = UDim2.new(0.1, 0, 0.7, 0)
ToggleButton.BackgroundColor3 = COLORS.BUTTON_INACTIVE
ToggleButton.Text = "INICIAR"
ToggleButton.TextColor3 = COLORS.TEXT
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 18
ToggleButton.AutoButtonColor = false
ToggleButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = ToggleButton

-- Button Hover Effect
local function createButtonEffect()
    local buttonEffect = Instance.new("Frame")
    buttonEffect.Size = UDim2.new(1, 0, 1, 0)
    buttonEffect.BackgroundTransparency = 0.8
    buttonEffect.BackgroundColor3 = COLORS.TEXT
    buttonEffect.ZIndex = 2
    ButtonCorner:Clone().Parent = buttonEffect
    return buttonEffect
end

ToggleButton.MouseEnter:Connect(function()
    local effect = createButtonEffect()
    effect.Parent = ToggleButton
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
    local tween = TweenService:Create(effect, tweenInfo, {BackgroundTransparency = 1})
    tween:Play()
    tween.Completed:Connect(function()
        effect:Destroy()
    end)
end)

-- Toggle Functionality
ToggleButton.MouseButton1Click:Connect(function()
    isActive = not isActive
    
    -- Visual Updates
    ToggleButton.BackgroundColor3 = isActive and COLORS.BUTTON_ACTIVE or COLORS.BUTTON_INACTIVE
    ToggleButton.Text = isActive and "DETENER" or "INICIAR"
    StatusIndicator.BackgroundColor3 = isActive and COLORS.BUTTON_ACTIVE or COLORS.BUTTON_INACTIVE
    
    -- Auto-click Logic Mejorada
    spawn(function()
        while isActive do
            -- Método más efectivo de click usando VirtualUser
            VirtualUser:Button1Down(Vector2.new(0,0))
            wait(0.1)
            VirtualUser:Button1Up(Vector2.new(0,0))
            
            wait(tonumber(IntervalInput.Text) or 1)
        end
    end)
end)

-- Make the GUI draggable
local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or
        input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Hope Vision - Prison Life Script
-- Lightweight Mobile Version (No Rayfield)

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

local AimbotEnabled = false
local ESPEnabled = false
local FlyEnabled = false
local ESPBoxes = {}
local BodyVelocity = nil
local BodyGyro = nil

-- Create simple GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HopeVisionGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Text = "Hope Vision v5.0"
Title.BorderSizePixel = 0
Title.Parent = MainFrame

-- Aimbot Label
local AimbotLabel = Instance.new("TextLabel")
AimbotLabel.Name = "AimbotLabel"
AimbotLabel.Size = UDim2.new(1, 0, 0, 30)
AimbotLabel.Position = UDim2.new(0, 0, 0, 50)
AimbotLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
AimbotLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotLabel.TextSize = 14
AimbotLabel.Font = Enum.Font.Gotham
AimbotLabel.Text = "Aimbot: OFF"
AimbotLabel.BorderSizePixel = 0
AimbotLabel.Parent = MainFrame

-- Aimbot Button
local AimbotButton = Instance.new("TextButton")
AimbotButton.Name = "AimbotButton"
AimbotButton.Size = UDim2.new(0.4, 0, 0, 30)
AimbotButton.Position = UDim2.new(0.55, 0, 0, 50)
AimbotButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotButton.TextSize = 12
AimbotButton.Font = Enum.Font.Gotham
AimbotButton.Text = "TOGGLE"
AimbotButton.BorderSizePixel = 0
AimbotButton.Parent = MainFrame

-- ESP Label
local ESPLabel = Instance.new("TextLabel")
ESPLabel.Name = "ESPLabel"
ESPLabel.Size = UDim2.new(1, 0, 0, 30)
ESPLabel.Position = UDim2.new(0, 0, 0, 90)
ESPLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ESPLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPLabel.TextSize = 14
ESPLabel.Font = Enum.Font.Gotham
ESPLabel.Text = "ESP: OFF"
ESPLabel.BorderSizePixel = 0
ESPLabel.Parent = MainFrame

-- ESP Button
local ESPButton = Instance.new("TextButton")
ESPButton.Name = "ESPButton"
ESPButton.Size = UDim2.new(0.4, 0, 0, 30)
ESPButton.Position = UDim2.new(0.55, 0, 0, 90)
ESPButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.TextSize = 12
ESPButton.Font = Enum.Font.Gotham
ESPButton.Text = "TOGGLE"
ESPButton.BorderSizePixel = 0
ESPButton.Parent = MainFrame

-- Fly Label
local FlyLabel = Instance.new("TextLabel")
FlyLabel.Name = "FlyLabel"
FlyLabel.Size = UDim2.new(1, 0, 0, 30)
FlyLabel.Position = UDim2.new(0, 0, 0, 130)
FlyLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FlyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyLabel.TextSize = 14
FlyLabel.Font = Enum.Font.Gotham
FlyLabel.Text = "Fly: OFF"
FlyLabel.BorderSizePixel = 0
FlyLabel.Parent = MainFrame

-- Fly Button
local FlyButton = Instance.new("TextButton")
FlyButton.Name = "FlyButton"
FlyButton.Size = UDim2.new(0.4, 0, 0, 30)
FlyButton.Position = UDim2.new(0.55, 0, 0, 130)
FlyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextSize = 12
FlyButton.Font = Enum.Font.Gotham
FlyButton.Text = "TOGGLE"
FlyButton.BorderSizePixel = 0
FlyButton.Parent = MainFrame

-- Info Label
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Name = "InfoLabel"
InfoLabel.Size = UDim2.new(1, 0, 0, 100)
InfoLabel.Position = UDim2.new(0, 0, 0, 170)
InfoLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoLabel.TextSize = 12
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Text = "Prison Life Executor\n\nAimbot: Target nearest player\nESP: See all players\nFly: WASD + Space/Ctrl"
InfoLabel.TextWrapped = true
InfoLabel.BorderSizePixel = 0
InfoLabel.Parent = MainFrame

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(1, 0, 0, 30)
CloseButton.Position = UDim2.new(0, 0, 0, 360)
CloseButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 12
CloseButton.Font = Enum.Font.Gotham
CloseButton.Text = "CLOSE"
CloseButton.BorderSizePixel = 0
CloseButton.Parent = MainFrame

-- Aimbot Function
local function UpdateAimbot()
    if AimbotEnabled and Character and Humanoid.Health > 0 then
        local Target = nil
        local ClosestDistance = math.huge
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v ~= Character then
                local TargetHumanoid = v:FindFirstChild("Humanoid")
                if TargetHumanoid and TargetHumanoid.Health > 0 then
                    local Distance = (v.HumanoidRootPart.Position - RootPart.Position).Magnitude
                    if Distance < ClosestDistance and Distance < 100 then
                        ClosestDistance = Distance
                        Target = v
                    end
                end
            end
        end
        if Target then
            local TargetRoot = Target:FindFirstChild("HumanoidRootPart")
            if TargetRoot then
                Humanoid:MoveTo(TargetRoot.Position)
            end
        end
    end
end

-- ESP Function
local function UpdateESP()
    if ESPEnabled then
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v ~= Character then
                local TargetHumanoid = v:FindFirstChild("Humanoid")
                if TargetHumanoid and TargetHumanoid.Health > 0 then
                    local RootPartTarget = v:FindFirstChild("HumanoidRootPart")
                    local ExistingBox = RootPartTarget:FindFirstChild("ESPBox")
                    if not ExistingBox then
                        local Box = Instance.new("BoxHandleAdornment")
                        Box.Size = RootPartTarget.Size + Vector3.new(0.5, 0.5, 0.5)
                        Box.Adornee = RootPartTarget
                        Box.Color3 = Color3.fromRGB(255, 255, 255)
                        Box.Transparency = 0.5
                        Box.AlwaysOnTop = true
                        Box.Name = "ESPBox"
                        Box.Parent = RootPartTarget
                        table.insert(ESPBoxes, Box)
                    end
                end
            end
        end
    else
        for i, box in ipairs(ESPBoxes) do
            pcall(function()
                if box and box.Parent then
                    box:Destroy()
                end
            end)
            ESPBoxes[i] = nil
        end
    end
end

-- Fly Function
local function UpdateFly()
    if FlyEnabled and BodyVelocity and BodyGyro and RootPart then
        local Camera = workspace.CurrentCamera
        local Speed = 50
        local Velocity = Vector3.new(0, 0, 0)
        local UserInputService = game:GetService("UserInputService")
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            Velocity = Velocity + (Camera.CFrame.LookVector * Speed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            Velocity = Velocity - (Camera.CFrame.RightVector * Speed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            Velocity = Velocity - (Camera.CFrame.LookVector * Speed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            Velocity = Velocity + (Camera.CFrame.RightVector * Speed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            Velocity = Velocity + Vector3.new(0, Speed, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            Velocity = Velocity - Vector3.new(0, Speed, 0)
        end
        BodyVelocity.Velocity = Velocity
        BodyGyro.CFrame = Camera.CFrame
    end
end

-- Button Callbacks
AimbotButton.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    AimbotLabel.Text = "Aimbot: " .. (AimbotEnabled and "ON" or "OFF")
    AimbotLabel.TextColor3 = AimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
end)

ESPButton.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPLabel.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
    ESPLabel.TextColor3 = ESPEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
end)

FlyButton.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    FlyLabel.Text = "Fly: " .. (FlyEnabled and "ON" or "OFF")
    FlyLabel.TextColor3 = FlyEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
    
    if FlyEnabled then
        Humanoid.PlatformStand = true
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.Parent = RootPart
        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        BodyGyro.P = 10000
        BodyGyro.CFrame = RootPart.CFrame
        BodyGyro.Parent = RootPart
    else
        Humanoid.PlatformStand = false
        if BodyVelocity then
            BodyVelocity:Destroy()
            BodyVelocity = nil
        end
        if BodyGyro then
            BodyGyro:Destroy()
            BodyGyro = nil
        end
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Main Loop
local RunService = game:GetService("RunService")
RunService.Heartbeat:Connect(UpdateAimbot)
RunService.Heartbeat:Connect(UpdateESP)
RunService.Heartbeat:Connect(UpdateFly)

-- Character Respawn Handler
Player.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    if FlyEnabled then
        FlyEnabled = false
        if BodyVelocity then BodyVelocity:Destroy() end
        if BodyGyro then BodyGyro:Destroy() end
        BodyVelocity = nil
        BodyGyro = nil
        FlyLabel.Text = "Fly: OFF"
        FlyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    for _, box in pairs(ESPBoxes) do
        pcall(function() box:Destroy() end)
    end
    ESPBoxes = {}
end)

print("Hope Vision Loaded Successfully!")

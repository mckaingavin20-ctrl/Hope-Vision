local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/rayfield/rayfield/main/source/rayfield.lua'))()
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Humanoid.RootPart

local AimbotEnabled = false
local ESPEnabled = false
local FlyEnabled = false
local AimbotTarget = nil
local ESPBoxes = {}
local BodyVelocity = nil
local BodyGyro = nil

local function CreateMenu()
    local HopeVision = Rayfield:CreateWindow({
        Name = "Hope Vision",
        Color = Color3.fromRGB(255, 255, 255),
        Background = 4,
        BackgroundColor = Color3.fromRGB(0, 0, 0),
        TextColor = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        WindowRounded = 10,
        WindowBorder = 2,
        Keybind = Enum.KeyCode.F1
    })

    -- Aimbot Tab
    local AimbotTab = HopeVision:CreateTab("Aimbot", 4483362458)
    
    AimbotTab:CreateToggle({
        Name = "Enable Aimbot",
        CurrentValue = false,
        Callback = function(value)
            AimbotEnabled = value
        end
    })

    AimbotTab:CreateLabel("Aimbot will lock onto the nearest player")

    -- ESP Tab
    local ESPTab = HopeVision:CreateTab("ESP", 4483362458)
    
    ESPTab:CreateToggle({
        Name = "Enable ESP",
        CurrentValue = false,
        Callback = function(value)
            ESPEnabled = value
            if not value then
                for _, box in pairs(ESPBoxes) do
                    if box and box.Parent then
                        box:Destroy()
                    end
                end
                ESPBoxes = {}
            end
        end
    })

    ESPTab:CreateLabel("ESP shows player positions with boxes")

    -- Fly Tab
    local FlyTab = HopeVision:CreateTab("Fly", 4483362458)
    
    FlyTab:CreateToggle({
        Name = "Enable Flight",
        CurrentValue = false,
        Callback = function(value)
            FlyEnabled = value
            if value then
                Humanoid.PlatformStand = true
                
                BodyVelocity = Instance.new("BodyVelocity")
                BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                BodyVelocity.Parent = RootPart
                
                BodyGyro = Instance.new("BodyGyro")
                BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                BodyGyro.P = 10000
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
        end
    })

    FlyTab:CreateLabel("Use WASD to move, Space to go up, Ctrl to go down")
    FlyTab:CreateLabel("Flight Speed: 50")

    -- Settings Tab
    local SettingsTab = HopeVision:CreateTab("Settings", 4483362458)
    SettingsTab:CreateLabel("Hope Vision v1.0")
    SettingsTab:CreateLabel("Press F1 to toggle menu")
    SettingsTab:CreateLabel("Made with Rayfield UI")
end

local function Aimbot()
    if AimbotEnabled then
        local Target = nil
        local ClosestDistance = math.huge
        
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= Character then
                if v.Humanoid.Health > 0 then
                    local Distance = (v.Humanoid.RootPart.Position - RootPart.Position).Magnitude
                    if Distance < ClosestDistance then
                        ClosestDistance = Distance
                        Target = v
                    end
                end
            end
        end
        
        if Target and Target:FindFirstChild("Humanoid") then
            AimbotTarget = Target
            local TargetPos = Target.Humanoid.RootPart.Position
            Humanoid:MoveTo(TargetPos)
        end
    end
end

local function ESP()
    if ESPEnabled then
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= Character then
                if v.Humanoid.Health > 0 then
                    local RootPartTarget = v.Humanoid.RootPart
                    local ExistingBox = RootPartTarget:FindFirstChild("ESPBox")
                    
                    if not ExistingBox then
                        local Box = Instance.new("BoxHandleAdornment")
                        Box.Size = RootPartTarget.Size + Vector3.new(0.2, 0.2, 0.2)
                        Box.Adornee = RootPartTarget
                        Box.Color3 = Color3.fromRGB(255, 255, 255)
                        Box.Transparency = 0.3
                        Box.AlwaysOnTop = true
                        Box.Name = "ESPBox"
                        Box.Parent = RootPartTarget
                        table.insert(ESPBoxes, Box)
                    end
                end
            end
        end
    else
        for _, box in pairs(ESPBoxes) do
            if box and box.Parent then
                box:Destroy()
            end
        end
        ESPBoxes = {}
    end
end

local function Fly()
    if FlyEnabled and BodyVelocity and BodyGyro then
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
        BodyGyro.CFrame = workspace.CurrentCamera.CFrame
    end
end

CreateMenu()

game:GetService("RunService").Heartbeat:Connect(Aimbot)
game:GetService("RunService").Heartbeat:Connect(ESP)
game:GetService("RunService").Heartbeat:Connect(Fly)

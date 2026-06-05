-- Hope Vision - Prison Life Script
-- Mobile Compatible Version with Fallback System

local main = game:HttpGet("https://raw.githubusercontent.com/mckaingavin20-ctrl/Hope-Vision/main/hopeVision.lua")
if main and main ~= "404: Not Found" then
    loadstring(main)()
else
    print("Hope Vision loading from backup...")
    -- Inline backup code
    local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/rayfield/rayfield/main/source/rayfield.lua'))()
    
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
    
    local HopeVision = Rayfield:CreateWindow({
        Name = "Hope Vision",
        LoadingTitle = "Hope Vision",
        LoadingSubtitle = "Prison Life",
        ConfigurationSaving = {Enabled = false},
        Keybind = Enum.KeyCode.F1,
    })
    
    -- Aimbot Tab
    local AimbotTab = HopeVision:CreateTab("Aimbot", 4483362458)
    AimbotTab:CreateToggle({
        Name = "Enable Aimbot",
        CurrentValue = false,
        Callback = function(value)
            AimbotEnabled = value
        end,
    })
    AimbotTab:CreateLabel("Targets nearest player")
    
    -- ESP Tab
    local ESPTab = HopeVision:CreateTab("ESP", 4483362458)
    ESPTab:CreateToggle({
        Name = "Enable ESP",
        CurrentValue = false,
        Callback = function(value)
            ESPEnabled = value
            if not value then
                for _, box in pairs(ESPBoxes) do
                    pcall(function() box:Destroy() end)
                end
                ESPBoxes = {}
            end
        end,
    })
    ESPTab:CreateLabel("Shows player positions")
    
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
        end,
    })
    FlyTab:CreateLabel("WASD to move")
    FlyTab:CreateLabel("Space/Ctrl up/down")
    
    -- Settings Tab
    local SettingsTab = HopeVision:CreateTab("Settings", 4483362458)
    SettingsTab:CreateLabel("Hope Vision v4.0")
    SettingsTab:CreateLabel("Prison Life Edition")
    SettingsTab:CreateLabel("Press F1 to toggle")
    
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
    
    local RunService = game:GetService("RunService")
    RunService.Heartbeat:Connect(UpdateAimbot)
    RunService.Heartbeat:Connect(UpdateESP)
    RunService.Heartbeat:Connect(UpdateFly)
    
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
        end
        for _, box in pairs(ESPBoxes) do
            pcall(function() box:Destroy() end)
        end
        ESPBoxes = {}
    end)
    
    Rayfield:Notify({
        Title = "Hope Vision",
        Content = "Loaded! Press F1 to open menu",
        Duration = 5,
        Image = 4483362458,
    })
end

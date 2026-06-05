local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/rayfield/rayfield/main/source/rayfield.lua'))()
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local AimbotEnabled = false
local ESPEnabled = false
local FlyEnabled = false
local AimbotTarget = nil
local function CreateMenu()
    local HopeVision = Rayfield:CreateWindow({
        Name = "Hope Vision",
        Color = Color3.fromRGB(255, 255, 255),
        Background = 4,
        BackgroundColor = Color3.fromRGB(0, 0, 0),
        TextColor = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        WindowRounded = 5,
        WindowBorder = 5,
        Keybind = Enum.KeyCode.F1
    })
    local AimbotTab = HopeVision:CreateTab("Aimbot", 4483362458)
    local ESPTab = HopeVision:CreateTab("ESP", 4483362458)
    local FlyTab = HopeVision:CreateTab("Fly", 4483362458)
    AimbotTab:CreateToggle({
        Name = "Toggle Aimbot",
        CurrentValue = false,
        Callback = function(value)
            AimbotEnabled = value
        end
    })
    ESPTab:CreateToggle({
        Name = "Toggle ESP",
        CurrentValue = false,
        Callback = function(value)
            ESPEnabled = value
        end
    })
    FlyTab:CreateToggle({
        Name = "Toggle Fly",
        CurrentValue = false,
        Callback = function(value)
            FlyEnabled = value
            if FlyEnabled then
                Humanoid.PlatformStand = true
                local BodyVelocity = Instance.new("BodyVelocity")
                BodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                BodyVelocity.Parent = Humanoid.RootPart
            else
                Humanoid.PlatformStand = false
                if Humanoid.RootPart:FindFirstChild("BodyVelocity") then
                    Humanoid.RootPart:FindFirstChild("BodyVelocity"):Destroy()
                end
            end
        end
    })
end
local function Aimbot()
    if AimbotEnabled then
        local Target = nil
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= Character then
                local Distance = (v.Humanoid.RootPart.Position - Humanoid.RootPart.Position).Magnitude
                if not Target or Distance < (Target.Humanoid.RootPart.Position - Humanoid.RootPart.Position).Magnitude then
                    Target = v
                end
            end
        end
        if Target then
            AimbotTarget = Target
            Humanoid:MoveTo(Target.Humanoid.RootPart.Position)
        end
    end
end
local function ESP()
    if ESPEnabled then
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= Character then
                local Box = Instance.new("BoxHandleAdornment")
                Box.Size = v.Humanoid.RootPart.Size + Vector3.new(0, 2, 0)
                Box.Adornee = v.Humanoid.RootPart
                Box.Color3 = Color3.fromRGB(255, 255, 255)
                Box.AlwaysOnTop = true
                Box.Parent = v.Humanoid.RootPart
            end
        end
    end
end
CreateMenu()
game:GetService("RunService").Heartbeat:Connect(Aimbot)
game:GetService("RunService").Heartbeat:Connect(ESP)

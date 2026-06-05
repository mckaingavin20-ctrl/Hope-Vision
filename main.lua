local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/rayfield/rayfield/main/source/rayfield.lua'))()
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local aimbotEnabled = false
local espEnabled = false
local flyEnabled = false

local aimbotTarget = nil

local function createMenu()
    local hopeVision = Rayfield:CreateWindow({
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

    local aimbotTab = hopeVision:CreateTab("Aimbot", 4483362458)
    local espTab = hopeVision:CreateTab("ESP", 4483362458)
    local flyTab = hopeVision:CreateTab("Fly", 4483362458)

    aimbotTab:CreateToggle({
        Name = "Toggle Aimbot",
        CurrentValue = false,
        Callback = function(value)
            aimbotEnabled = value
        end
    })

    espTab:CreateToggle({
        Name = "Toggle ESP",
        CurrentValue = false,
        Callback = function(value)
            espEnabled = value
        end
    })

    flyTab:CreateToggle({
        Name = "Toggle Fly",
        CurrentValue = false,
        Callback = function(value)
            flyEnabled = value
            if flyEnabled then
                humanoid.PlatformStand = true
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.Parent = humanoid.RootPart
            else
                humanoid.PlatformStand = false
                if humanoid.RootPart:FindFirstChild("BodyVelocity") then
                    humanoid.RootPart:FindFirstChild("BodyVelocity"):Destroy()
                end
            end
        end
    })
end

local function aimbot()
    if aimbotEnabled then
        local target = nil
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= character then
                local distance = (v.Humanoid.RootPart.Position - humanoid.RootPart.Position).Magnitude
                if not target or distance < (target.Humanoid.RootPart.Position - humanoid.RootPart.Position).Magnitude then
                    target = v
                end
            end
        end
        if target then
            aimbotTarget = target
            humanoid:MoveTo(target.Humanoid.RootPart.Position)
        end
    end
end

local function esp()
    if espEnabled then
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= character then
                local box = Instance.new("BoxHandleAdornment")
                box.Size = v.Humanoid.RootPart.Size + Vector3.new(0, 2, 0)
                box.Adornee = v.Humanoid.RootPart
                box.Color3 = Color3.fromRGB(255, 255, 255)
                box.AlwaysOnTop = true
                box.Parent = v.Humanoid.RootPart
            end
        end
    end
end

createMenu()

game:GetService("RunService").Heartbeat:Connect(aimbot)
game:GetService("RunService").Heartbeat:Connect(esp)

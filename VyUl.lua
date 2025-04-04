-- VyUl v1 | ESP + Aimbot + UI Toggle | Tương thích Delta Executor

-- SETTINGS
getgenv().AimbotEnabled = false
getgenv().ESPEnabled = false
getgenv().IgnoreNPCs = false

-- Load UI Library (Rayfield UI)
loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
local Window = Rayfield:CreateWindow({
   Name = "VyUl - Blox Fruits",
   LoadingTitle = "VyUl Loading...",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "VyUlConfig",
      FileName = "Settings"
   }
})

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateToggle({
   Name = "Bật Aimbot",
   CurrentValue = false,
   Callback = function(Value)
       AimbotEnabled = Value
   end
})

MainTab:CreateToggle({
   Name = "Bật ESP",
   CurrentValue = false,
   Callback = function(Value)
       ESPEnabled = Value
   end
})

MainTab:CreateToggle({
   Name = "Ignore Quái (chỉ nhắm Player)",
   CurrentValue = false,
   Callback = function(Value)
       IgnoreNPCs = Value
   end
})

-- ESP Setup
local function createESP(target)
   local box = Instance.new("BoxHandleAdornment")
   box.Size = Vector3.new(4,6,4)
   box.Color3 = Color3.new(1,0,0)
   box.Adornee = target
   box.AlwaysOnTop = true
   box.ZIndex = 5
   box.Transparency = 0.5
   box.Parent = target
end

-- Aimbot Logic
local function getClosestTarget()
   local closest, dist = nil, math.huge
   for _,v in pairs(game:GetService("Workspace").Characters:GetChildren()) do
       if v:FindFirstChild("HumanoidRootPart") and v ~= game.Players.LocalPlayer.Character then
           local isNPC = v:FindFirstChildOfClass("Humanoid") and game.Players:GetPlayerFromCharacter(v) == nil
           if (IgnoreNPCs and not isNPC) or not IgnoreNPCs then
               local pos = workspace.CurrentCamera:WorldToViewportPoint(v.HumanoidRootPart.Position)
               local magnitude = (Vector2.new(pos.X,pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
               if magnitude < dist and v:FindFirstChild("Humanoid").Health > 0 then
                   closest = v
                   dist = magnitude
               end
           end
       end
   end
   return closest
end

-- Aimbot Loop
game:GetService("RunService").RenderStepped:Connect(function()
   if AimbotEnabled then
       local target = getClosestTarget()
       if target and target:FindFirstChild("HumanoidRootPart") then
           workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.HumanoidRootPart.Position)
       end
   end
end)

-- ESP Loop
while true do
   if ESPEnabled then
       for _,v in pairs(workspace:GetDescendants()) do
           if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and not v:FindFirstChild("VyUlESP") then
               local tag = Instance.new("BoolValue")
               tag.Name = "VyUlESP"
               tag.Parent = v
               createESP(v.HumanoidRootPart)
           end
       end
   end
   task.wait(2)
end

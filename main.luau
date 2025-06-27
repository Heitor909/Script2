-- Blox Fruits Hub Completo Delta Executor (Windows + Android)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local states = {
    farm = false,
    quest = false,
    fruitFarm = false,
    chestFarm = false,
    seaEvent = false,
    esp = false,
    infiniteStamina = false,
    antiAfk = false,
    walkSpeed = 16,
    jumpPower = 50
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BFHub"
ScreenGui.Parent = game.CoreGui

local function createButton(text, position, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 40)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = text
    btn.Parent = parent
    btn.AutoButtonColor = true
    btn.BorderSizePixel = 0
    btn.BackgroundTransparency = 0.3
    return btn
end

local function createLabel(text, position, parent)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 0, 20)
    label.Position = position
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Text = text
    label.Parent = parent
    return label
end

local function createESP(character)
    if character and character:FindFirstChild("HumanoidRootPart") then
        if not character:FindFirstChild("ESP_Box") then
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "ESP_Box"
            box.Adornee = character.HumanoidRootPart
            box.AlwaysOnTop = true
            box.ZIndex = 2
            box.Size = Vector3.new(4, 6, 1)
            box.Color3 = Color3.new(0, 1, 0)
            box.Transparency = 0.5
            box.Parent = character.HumanoidRootPart
        end
    end
end

Players.PlayerRemoving:Connect(function(player)
    if player.Character and player.Character:FindFirstChild("ESP_Box") then
        player.Character.ESP_Box:Destroy()
    end
end)

RunService.Heartbeat:Connect(function()
    if states.esp then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character ~= LocalPlayer.Character then
                createESP(player.Character)
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("ESP_Box") then
                player.Character.ESP_Box:Destroy()
            end
        end
    end
end)

local function autoFarm()
    while states.farm do
        wait(0.3)
        local mob = nil
        local mobsFolder = Workspace:FindFirstChild("Enemies") or Workspace:FindFirstChild("Mobs") or Workspace:FindFirstChild("Monsters")
        if mobsFolder then
            for _, v in pairs(mobsFolder:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    mob = v
                    break
                end
            end
        end
        if mob and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
        end
    end
end

local function autoQuest()
    while states.quest do
        wait(1)
        local questGui = LocalPlayer.PlayerGui:FindFirstChild("QuestGui")
        if questGui and questGui.Visible then
            local acceptButton = questGui:FindFirstChild("AcceptButton")
            local completeButton = questGui:FindFirstChild("CompleteButton")
            if acceptButton and acceptButton.Visible then
                acceptButton.MouseButton1Click:Fire()
            elseif completeButton and completeButton.Visible then
                completeButton.MouseButton1Click:Fire()
            end
        end
    end
end

local function autoFruitFarm()
    while states.fruitFarm do
        wait(0.5)
        local fruitFolder = Workspace:FindFirstChild("Fruits") or Workspace:FindFirstChild("FruitSpawns")
        if fruitFolder then
            for _, fruit in pairs(fruitFolder:GetChildren()) do
                if fruit:IsA("Part") and fruit.Transparency < 1 then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = fruit.CFrame
                    wait(0.2)
                end
            end
        end
    end
end

local function autoChestFarm()
    while states.chestFarm do
        wait(0.5)
        local chestFolder = Workspace:FindFirstChild("Chests") or Workspace:FindFirstChild("TreasureChests")
        if chestFolder then
            for _, chest in pairs(chestFolder:GetChildren()) do
                if chest:IsA("Part") and (chest.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 20 then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, chest, 0)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, chest, 1)
                    wait(0.5)
                end
            end
        end
    end
end

local function autoSeaEventFarm()
    while states.seaEvent do
        wait(0.5)
        local seaEventMobs = Workspace:FindFirstChild("SeaEventMobs")
        if seaEventMobs then
            for _, mob in pairs(seaEventMobs:GetChildren()) do
                if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,0,5)
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if states.infiniteStamina and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Stamina") then
        LocalPlayer.Character.Stamina.Value = LocalPlayer.Character.Stamina.MaxValue
    end
end)

local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    if states.antiAfk then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

local function updateHumanoid()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = states.walkSpeed
        LocalPlayer.Character.Humanoid.JumpPower = states.jumpPower
    end
end

RunService.Heartbeat:Connect(updateHumanoid)

local buttonsInfo = {
    {name = "Auto Farm", key = "farm", func = autoFarm},
    {name = "Auto Quest", key = "quest", func = autoQuest},
    {name = "Auto Fruit Farm", key = "fruitFarm", func = autoFruitFarm},
    {name = "Auto Chest Farm", key = "chestFarm", func = autoChestFarm},
    {name = "Auto Sea Event", key = "seaEvent", func = autoSeaEventFarm},
    {name = "ESP", key = "esp"},
    {name = "Infinite Stamina", key = "infiniteStamina"},
    {name = "Anti AFK", key = "antiAfk"},
}

for i, btn in ipairs(buttonsInfo) do
    local button = createButton(btn.name, UDim2.new(0,10,0,10 + (i-1)*50), ScreenGui)
    button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    
    button.MouseButton1Click:Connect(function()
        states[btn.key] = not states[btn.key]
        button.BackgroundColor3 = states[btn.key] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(25, 25, 25)
        if states[btn.key] and btn.func then
            spawn(btn.func)
        end
    end)
end

local wsLabel = createLabel("WalkSpeed: "..states.walkSpeed, UDim2.new(0,10,0,10 + #buttonsInfo*50), ScreenGui)
local wsInc = createButton("+ WS", UDim2.new(0,170,0,10 + #buttonsInfo*50), ScreenGui)
local wsDec = createButton("- WS", UDim2.new(0,230,0,10 + #buttonsInfo*50), ScreenGui)

local jpLabel = createLabel("JumpPower: "..states.jumpPower, UDim2.new(0,10,0,60 + #buttonsInfo*50), ScreenGui)
local jpInc = createButton("+ JP", UDim2.new(0,170,0,60 + #buttonsInfo*50), ScreenGui)
local jpDec = createButton("- JP", UDim2.new(0,230,0,60 + #buttonsInfo*50), ScreenGui)

wsInc.MouseButton1Click:Connect(function()
    states.walkSpeed = math.min(states.walkSpeed + 5, 500)
    wsLabel.Text = "WalkSpeed: "..states.walkSpeed
end)

wsDec.MouseButton1Click:Connect(function()
    states.walkSpeed = math.max(states.walkSpeed - 5, 16)
    wsLabel.Text = "WalkSpeed: "..states.walkSpeed
end)

jpInc.MouseButton1Click:Connect(function()
    states.jumpPower = math.min(states.jumpPower + 5, 250)
    jpLabel.Text = "JumpPower: "..states.jumpPower
end)

jpDec.MouseButton1Click:Connect(function()
    states.jumpPower = math.max(states.jumpPower - 5, 50)
    jpLabel.Text = "JumpPower: "..states.jumpPower
end)

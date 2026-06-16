-- HasoDex by AndikaDex

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "HasoDex",
    LoadingTitle = "HasoDex",
    LoadingSubtitle = "SCP Monster System",
    ConfigurationSaving = {Enabled = true, FolderName = "HasoDex", FileName = "Config"},
    KeySystem = false,
})

local MonsterTab = Window:CreateTab("🦇 Monsters", 4483362458)

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local CurrentMonster = nil

local Monsters = {
    {Name = "SCP-096", Color = Color3.fromRGB(255,240,220), Size = 1.4, Speed = 30, Damage = 50},
    {Name = "SCP-173", Color = Color3.fromRGB(150,150,150), Size = 1.6, Speed = 0, Damage = 80},
    {Name = "SCP-106", Color = Color3.fromRGB(30,30,30), Size = 1.3, Speed = 18, Damage = 35},
    {Name = "SCP-682", Color = Color3.fromRGB(80,120,40), Size = 2.0, Speed = 22, Damage = 60},
    {Name = "SCP-939", Color = Color3.fromRGB(100,0,0), Size = 1.5, Speed = 25, Damage = 45},
    {Name = "SCP-049", Color = Color3.fromRGB(20,20,20), Size = 1.4, Speed = 20, Damage = 55},
    {Name = "Siren Head", Color = Color3.fromRGB(50,50,50), Size = 2.5, Speed = 28, Damage = 65},
    {Name = "The Rake", Color = Color3.fromRGB(70,70,70), Size = 1.3, Speed = 32, Damage = 50},
    {Name = "SCP-035", Color = Color3.fromRGB(255,215,0), Size = 1.2, Speed = 24, Damage = 40}
}

local function TransformToMonster(monster)
    CurrentMonster = monster
    Humanoid.WalkSpeed = monster.Speed

    for _, part in pairs(Character:GetChildren()) do
        if part:IsA("BasePart") and part.Name \~= "HumanoidRootPart" then
            part.Color = monster.Color
            part.Size = part.Size * monster.Size
        end
    end

    Rayfield:Notify({Title = "TRANSFORM BERHASIL", Content = "Kamu sekarang " .. monster.Name, Duration = 5})
end

MonsterTab:CreateDropdown({
    Name = "Pilih Monster SCP",
    Options = {"SCP-096","SCP-173","SCP-106","SCP-682","SCP-939","SCP-049","Siren Head","The Rake","SCP-035"},
    Default = "SCP-096",
    Callback = function(val)
        for _, m in ipairs(Monsters) do
            if m.Name == val then 
                TransformToMonster(m) 
                break 
            end
        end
    end
})

MonsterTab:CreateButton({Name = "🎲 Random Monster", Callback = function()
    TransformToMonster(Monsters[math.random(#Monsters)])
end})

MonsterTab:CreateButton({Name = "🔄 Reset to Human", Callback = function()
    CurrentMonster = nil
    Humanoid.WalkSpeed = 16
    Rayfield:Notify({Title = "RESET", Content = "Kembali Normal", Duration = 3})
end})

-- Attack Tool
local Tool = Instance.new("Tool")
Tool.Name = "HasoDex Attack"
Tool.RequiresHandle = false
Tool.Parent = Player.Backpack

Tool.Activated:Connect(function()
    if not CurrentMonster then 
        Rayfield:Notify({Title = "ERROR", Content = "Transform dulu!", Duration = 3})
        return 
    end
    local mouse = Player:GetMouse()
    local target = mouse.Target
    if target and target.Parent:FindFirstChild("Humanoid") and target.Parent \~= Character then
        target.Parent.Humanoid:TakeDamage(CurrentMonster.Damage)
    end
end)

Rayfield:Notify({Title = "HasoDex", Content = "by AndikaDex - Loaded! Pilih monster di tab Monsters", Duration = 8})

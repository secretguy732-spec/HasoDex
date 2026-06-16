-- HasoDex
-- by AndikaDex

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "HasoDex",
    LoadingTitle = "HasoDex",
    LoadingSubtitle = "SCP Inspired Monster System",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "HasoDex",
        FileName = "Config"
    },
    KeySystem = false,
})

local MainTab = Window:CreateTab("🏠 Main", 4483362458)
local MonsterTab = Window:CreateTab("🦇 Monsters", 4483362458)
local AttackTab = Window:CreateTab("⚔️ Attacks", 4483362458)

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local CurrentMonster = nil

-- 10 SCP-Inspired Monster (Lebih Serius & Menyeramkan)
local Monsters = {
    {Name = "SCP-096", Color = Color3.fromRGB(255, 240, 220), Size = 1.4, Speed = 30, Damage = 50, Desc = "Shy Guy - Jangan Lihat Wajahnya", Aggro = true},
    {Name = "SCP-173", Color = Color3.fromRGB(150, 150, 150), Size = 1.6, Speed = 0, Damage = 80, Desc = "The Sculpture - Bergerak Saat Tidak Dilihat", Aggro = false},
    {Name = "SCP-106", Color = Color3.fromRGB(30, 30, 30), Size = 1.3, Speed = 18, Damage = 35, Desc = "Old Man - Corrosion Touch", Aggro = true},
    {Name = "SCP-682", Color = Color3.fromRGB(80, 120, 40), Size = 2.0, Speed = 22, Damage = 60, Desc = "Hard-to-Destroy Reptile", Aggro = true},
    {Name = "SCP-939", Color = Color3.fromRGB(100, 0, 0), Size = 1.5, Speed = 25, Damage = 45, Desc = "With Many Voices", Aggro = true},
    {Name = "SCP-049", Color = Color3.fromRGB(20, 20, 20), Size = 1.4, Speed = 20, Damage = 55, Desc = "Plague Doctor", Aggro = true},
    {Name = "SCP-035", Color = Color3.fromRGB(255, 215, 0), Size = 1.2, Speed = 24, Damage = 40, Desc = "Possessive Mask", Aggro = true},
    {Name = "SCP-3008", Color = Color3.fromRGB(139, 69, 19), Size = 1.8, Speed = 16, Damage = 30, Desc = "Infinite IKEA Staff", Aggro = false},
    {Name = "Siren Head", Color = Color3.fromRGB(50, 50, 50), Size = 2.5, Speed = 28, Damage = 65, Desc = "Horror Siren", Aggro = true},
    {Name = "The Rake", Color = Color3.fromRGB(70, 70, 70), Size = 1.3, Speed = 32, Damage = 50, Desc = "The Rake - Nocturnal Hunter", Aggro = true}
}

-- Transform Function (Replicated ke semua player)
local function TransformToMonster(monster)
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    CurrentMonster = monster

    -- Reset dulu
    for _, part in pairs(Character:GetChildren()) do
        if part:IsA("BasePart") and part.Name \~= "HumanoidRootPart" then
            part.Color = Color3.fromRGB(255,255,255)
            part.Transparency = 0
            part.Size = Vector3.new(1,1,1)
            part.Material = Enum.Material.Plastic
        end
    end

    Humanoid.WalkSpeed = monster.Speed
    Humanoid.JumpPower = 70

    -- Apply Monster Look
    for _, part in pairs(Character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Color = monster.Color
            part.Size = part.Size * monster.Size
            if monster.Name == "SCP-096" or monster.Name == "The Rake" then
                part.Material = Enum.Material.SmoothPlastic
            elseif monster.Name == "SCP-106" then
                part.Material = Enum.Material.CorrodedMetal
            end
        end
    end

    -- Tambah Attachment sederhana (lebih mirip monster)
    local head = Character:FindFirstChild("Head")
    if head then
        local face = Instance.new("Decal")
        face.Name = "MonsterFace"
        face.Texture = monster.Name == "SCP-096" and "rbxassetid://123456789" or "" -- Ganti dengan asset ID horror jika ada
        face.Parent = head
    end

    Rayfield:Notify({
        Title = "TRANSFORMATION COMPLETE",
        Content = "Kamu sekarang " .. monster.Name .. "\n" .. monster.Desc,
        Duration = 6,
    })
end

-- UI
MonsterTab:CreateDropdown({
    Name = "Pilih Monster SCP",
    Options = {"SCP-096", "SCP-173", "SCP-106", "SCP-682", "SCP-939", "SCP-049", "SCP-035", "SCP-3008", "Siren Head", "The Rake"},
    Default = "SCP-096",
    Callback = function(Value)
        for _, mon in ipairs(Monsters) do
            if mon.Name == Value then
                TransformToMonster(mon)
                break
            end
        end
    end,
})

MonsterTab:CreateButton({
    Name = "🎲 Random Monster",
    Callback = function()
        local randomMon = Monsters[math.random(1, #Monsters)]
        TransformToMonster(randomMon)
    end,
})

MonsterTab:CreateButton({
    Name = "🔄 Reset to Human",
    Callback = function()
        CurrentMonster = nil
        Humanoid.WalkSpeed = 16
        for _, part in pairs(Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Color = Color3.fromRGB(255,255,255)
                part.Transparency = 0
                part.Size = Vector3.new(1,1,1)
                part.Material = Enum.Material.Plastic
            end
        end
        Rayfield:Notify({Title = "RESET", Content = "Kembali ke bentuk manusia", Duration = 4})
    end,
})

-- Attack System (Replicated)
local AttackTool = Instance.new("Tool")
AttackTool.Name = "HasoDex_Attack"
AttackTool.RequiresHandle = false
AttackTool.Parent = Player.Backpack

AttackTool.Activated:Connect(function()
    if not CurrentMonster then
        Rayfield:Notify({Title = "ERROR", Content = "Transform dulu menjadi monster!", Duration = 3})
        return
    end

    local mouse = Player:GetMouse()
    local target = mouse.Target

    if target and target.Parent:FindFirstChild("Humanoid") and target.Parent \~= Character then
        local hum = target.Parent.Humanoid
        local dmg = CurrentMonster.Damage

        hum:TakeDamage(dmg)

        -- Visual Effect (visible semua player)
        local hitEffect = Instance.new("ParticleEmitter")
        hitEffect.Texture = "rbxassetid://241650934"
        hitEffect.Color = ColorSequence.new(CurrentMonster.Color)
        hitEffect.Lifetime = NumberRange.new(1)
        hitEffect.Parent = target
        game.Debris:AddItem(hitEffect, 1.5)

        Rayfield:Notify({
            Title = CurrentMonster.Name .. " ATTACK",
            Content = "Menyerang dengan " .. dmg .. " damage!",
            Duration = 2.5,
        })
    end
end)

-- Respawn Handler
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    wait(1.5)
    if CurrentMonster then
        TransformToMonster(CurrentMonster)
    end
end)

-- Info
MainTab:CreateParagraph({
    Title = "HasoDex",
    Content = "Script Monster SCP Style by AndikaDex\nSemua perubahan terlihat oleh semua player\nGunakan dengan bijak."
})

Rayfield:Notify({
    Title = "HasoDex Loaded",
    Content = "by AndikaDex\nPilih monster dan hancurkan mereka.",
    Duration = 8,
})

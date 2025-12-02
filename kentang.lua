----- =======[ LOADING SCREEN ] =======
-------------------------------------------

local LoadingUI = Instance.new("ScreenGui")
local LoadingFrame = Instance.new("Frame")
local LoadingLabel = Instance.new("TextLabel")
local ProgressBar = Instance.new("Frame")
local ProgressFill = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local StatusLabel = Instance.new("TextLabel")

LoadingUI.Name = "LoadingUI"
LoadingUI.Parent = game.CoreGui
LoadingUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Parent = LoadingUI
LoadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Position = UDim2.new(0.5, -150, 0.5, -50)
LoadingFrame.Size = UDim2.new(0, 300, 0, 120)

UICorner.Parent = LoadingFrame

LoadingLabel.Name = "LoadingLabel"
LoadingLabel.Parent = LoadingFrame
LoadingLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LoadingLabel.BackgroundTransparency = 1.0
LoadingLabel.Position = UDim2.new(0, 0, 0, 15)
LoadingLabel.Size = UDim2.new(1, 0, 0, 30)
LoadingLabel.Font = Enum.Font.GothamBold
LoadingLabel.Text = "SIMPLE BOOSTER"
LoadingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingLabel.TextScaled = true

StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = LoadingFrame
StatusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.BackgroundTransparency = 1.0
StatusLabel.Position = UDim2.new(0, 0, 0, 45)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Memuat sistem..."
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 14

ProgressBar.Name = "ProgressBar"
ProgressBar.Parent = LoadingFrame
ProgressBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ProgressBar.BorderSizePixel = 0
ProgressBar.Position = UDim2.new(0.05, 0, 0.7, 0)
ProgressBar.Size = UDim2.new(0.9, 0, 0, 12)

UICorner_2 = Instance.new("UICorner")
UICorner_2.Parent = ProgressBar

ProgressFill.Name = "ProgressFill"
ProgressFill.Parent = ProgressBar
ProgressFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
ProgressFill.BorderSizePixel = 0
ProgressFill.Size = UDim2.new(0, 0, 1, 0)

UICorner_3 = Instance.new("UICorner")
UICorner_3.Parent = ProgressFill

-- Fungsi update loading
local function UpdateLoading(status, progress)
    StatusLabel.Text = status
    ProgressFill:TweenSize(UDim2.new(progress, 0, 1, 0), "Out", "Quad", 0.3, true)
    task.wait(0.5)
end

-- Simulasi loading process
task.spawn(function()
    UpdateLoading("Memuat sistem...", 0.3)
    UpdateLoading("Menyiapkan UI...", 0.6)
    UpdateLoading("Siap! Memulai...", 1.0)
    
    task.wait(1)
    LoadingUI:Destroy()
end)

-------------------------------------------
----- =======[ Memuat WindUI ] =======
-------------------------------------------

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-------------------------------------------
----- =======[ FUNGSI UTAMA ] =======
-------------------------------------------

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain") or workspace.Terrain

-- Fix untuk setfpscap
if not setfpscap then
    if set_fps_cap then
        setfpscap = set_fps_cap
    else
        setfpscap = function(fps)
            pcall(function() 
                settings().Rendering.Framerate = fps == 0 and 1000 or fps 
            end)
        end
    end
end

-- Fungsi notifikasi WindUI
local function Notify(judul, pesan, durasi)
    pcall(function()
        WindUI:Notify({
            Title = judul,
            Content = pesan,
            Duration = durasi or 3,
            Icon = "info"
        })
    end)
end

-- Fungsi FPS Limit
local function SetFPSLimit(fps)
    local success, result = pcall(function()
        if type(fps) ~= "number" then
            fps = tonumber(fps) or 60
        end
        
        pcall(function() setfpscap(fps) end)
        pcall(function() 
            if setfpsmax then
                setfpsmax(fps)
            end
        end)
        pcall(function()
            settings().Rendering.Framerate = fps
        end)
        
        return tostring(fps)
    end)
    
    if success then
        Notify("FPS Limit", "FPS diatur ke: " .. tostring(fps))
        return true
    else
        Notify("Error", "Gagal mengatur FPS")
        return false
    end
end

-- Fungsi No Texture
local noTextureEnabled = false
local function ToggleNoTexture(enabled)
    noTextureEnabled = enabled
    
    if enabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") then
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
            elseif obj:IsA("Decal") then
                obj:Destroy()
            elseif obj:IsA("Texture") then
                obj:Destroy()
            end
        end
        Notify("No Texture", "Mode No Texture diaktifkan")
    else
        Notify("No Texture", "Mode No Texture dinonaktifkan")
    end
end

-- Fungsi Low Graphic
local lowGraphicEnabled = false
local function ToggleLowGraphic(enabled)
    lowGraphicEnabled = enabled
    
    if enabled then
        settings().Rendering.QualityLevel = 1
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 25000
        Lighting.Brightness = 2.0
        
        if Terrain then
            Terrain.Decoration = false
            Terrain.WaterReflection = false
        end
        
        for _, obj in pairs(Lighting:GetChildren()) do
            if obj:IsA("PostEffect") then
                obj.Enabled = false
            end
        end
        
        Notify("Low Graphic", "Mode Low Graphic diaktifkan")
    else
        settings().Rendering.QualityLevel = 8
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 1000000
        Lighting.Brightness = 1.0
        
        if Terrain then
            Terrain.Decoration = true
            Terrain.WaterReflection = true
        end
        
        Notify("Low Graphic", "Mode Low Graphic dinonaktifkan")
    end
end

-- Fungsi Rejoin Server
local function RejoinServer()
    local placeId = game.PlaceId
    local jobId = game.JobId
    
    Notify("Rejoin", "Mencoba rejoin server...", 2)
    
    task.wait(1)
    
    local success = pcall(function()
        TeleportService:TeleportToPlaceInstance(placeId, jobId, LocalPlayer)
    end)
    
    if not success then
        Notify("Error", "Gagal rejoin, coba lagi nanti", 3)
    end
end

-- Fungsi Join Server Hop
local function JoinServerHop()
    local placeId = game.PlaceId
    
    Notify("Server Hop", "Mencari server baru...", 2)
    
    local success, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    
    if success and servers and servers.data then
        local availableServers = {}
        for _, server in ipairs(servers.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(availableServers, server)
            end
        end
        
        if #availableServers > 0 then
            local randomServer = availableServers[math.random(1, #availableServers)]
            TeleportService:TeleportToPlaceInstance(placeId, randomServer.id, LocalPlayer)
            Notify("Server Hop", "Bergabung ke server baru...", 3)
        else
            Notify("Error", "Tidak ada server tersedia", 3)
        end
    else
        Notify("Error", "Gagal mendapatkan list server", 3)
    end
end

-------------------------------------------
----- =======[ INISIALISASI WINDOW ] =======
-------------------------------------------

local Window = WindUI:CreateWindow({
    Title = "SIMPLE BOOSTER",
    Icon = "zap",
    Author = "Simple Version",
    Folder = "SimpleBooster",
    Size = UDim2.fromOffset(400, 320),
    Theme = "Indigo",
    KeySystem = false
})

-- Set toggle key
pcall(function()
    Window:SetToggleKey(Enum.KeyCode.RightShift)
end)

pcall(function()
    WindUI:SetNotificationLower(true)
end)

Notify("Simple Booster", "Script Berhasil Dimuat!\nFitur siap digunakan!", 4)

-------------------------------------------
----- =======[ TAB UTAMA ] =======
-------------------------------------------

local MainTab = Window:Tab({
    Title = "Main Features",
    Icon = "settings"
})

-- Section FPS Limit
local SectionFPS = MainTab:Section({
    Title = "SET FPS LIMIT",
    Icon = "gauge"
})

local selectedFPS = "60"

local DropdownFPS = SectionFPS:Dropdown({
    Title = "Pilih FPS",
    Content = "Pilih batas FPS yang diinginkan",
    Values = {"15", "30", "60", "90"},
    Callback = function(value)
        selectedFPS = value
        Notify("FPS", "Dipilih: " .. value .. " FPS", 2)
    end
})

-- Set nilai default
pcall(function()
    DropdownFPS:Set("60")
end)

SectionFPS:Button({
    Title = "Apply FPS",
    Content = "Terapkan pengaturan FPS",
    Callback = function()
        local fps = tonumber(selectedFPS)
        if fps then
            SetFPSLimit(fps)
        else
            Notify("Error", "Pilihan FPS tidak valid", 3)
        end
    end
})

-- Section No Texture
local SectionTexture = MainTab:Section({
    Title = "NO TEXTURE",
    Icon = "image-off"
})

SectionTexture:Toggle({
    Title = "No Texture Mode",
    Content = "Nonaktifkan semua tekstur",
    Callback = function(value)
        ToggleNoTexture(value)
    end
})

-- Section Low Graphic
local SectionGraphic = MainTab:Section({
    Title = "LOW GRAPHIC",
    Icon = "monitor"
})

SectionGraphic:Toggle({
    Title = "Low Graphic Mode",
    Content = "Minimalkan pengaturan grafik",
    Callback = function(value)
        ToggleLowGraphic(value)
    end
})

-- Section Server
local SectionServer = MainTab:Section({
    Title = "SERVER",
    Icon = "server"
})

SectionServer:Button({
    Title = "REJOIN SERVER",
    Content = "Bergabung kembali ke server yang sama",
    Callback = function()
        RejoinServer()
    end
})

SectionServer:Button({
    Title = "JOIN SERVER HOP",
    Content = "Bergabung ke server yang berbeda",
    Callback = function()
        JoinServerHop()
    end
})

-- Section Info
local SectionInfo = MainTab:Section({
    Title = "INFO",
    Icon = "info"
})

SectionInfo:Label({
    Title = "Version",
    Content = "1.0"
})

SectionInfo:Label({
    Title = "Status",
    Content = "Aktif"
})

SectionInfo:Button({
    Title = "Reset All",
    Content = "Reset semua pengaturan ke default",
    Callback = function()
        -- Reset FPS
        SetFPSLimit(60)
        
        -- Reset No Texture
        if noTextureEnabled then
            ToggleNoTexture(false)
        end
        
        -- Reset Low Graphic
        if lowGraphicEnabled then
            ToggleLowGraphic(false)
        end
        
        Notify("Reset", "Semua pengaturan direset ke default", 3)
    end
})

-------------------------------------------
----- =======[ NOTIFIKASI AKHIR ] =======
-------------------------------------------

task.wait(2)
Notify("Simple Booster", 
    "Fitur Tersedia:\n• SET FPS LIMIT (15/30/60/90)\n• NO TEXTURE ON/OFF\n• LOW GRAPHIC ON/OFF\n• REJOIN SERVER\n• JOIN SERVER HOP\n\nGunakan RightShift untuk toggle UI", 
    6)

return {
    Window = Window,
    Version = "1.0"
}

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
LoadingLabel.Text = "SOVEREIGN BOOSTER"
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

-- =======[ FITUR BARU: NO SHADOW ] =======
local noShadowEnabled = false
local originalShadows = {}

local function ToggleNoShadow(enabled)
    noShadowEnabled = enabled
    
    if enabled then
        -- Simpan pengaturan shadow asli
        originalShadows.GlobalShadows = Lighting.GlobalShadows
        originalShadows.ShadowSoftness = Lighting.ShadowSoftness
        originalShadows.ShadowColor = Lighting.ShadowColor
        originalShadows.Ambient = Lighting.Ambient
        originalShadows.OutdoorAmbient = Lighting.OutdoorAmbient
        
        -- Nonaktifkan semua shadow
        Lighting.GlobalShadows = false
        Lighting.ShadowSoftness = 0
        Lighting.ShadowColor = Color3.new(1, 1, 1) -- Warna putih = tidak ada shadow
        Lighting.Ambient = Color3.fromRGB(128, 128, 128) -- Cahaya ambient seragam
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        
        -- Nonaktifkan shadow pada semua BasePart di workspace
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.CastShadow = false
            end
        end
        
        -- Connect untuk objek baru yang masuk ke workspace
        if not workspace.ChildAdded then
            workspace.ChildAdded:Connect(function(child)
                if noShadowEnabled then
                    task.wait(0.1) -- Tunggu sedikit agar descendants terbentuk
                    for _, obj in pairs(child:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            pcall(function()
                                obj.CastShadow = false
                            end)
                        end
                    end
                end
            end)
        end
        
        Notify("No Shadow", "Mode No Shadow diaktifkan\nSemua bayangan dihapus!", 3)
    else
        -- Kembalikan pengaturan shadow asli
        if originalShadows.GlobalShadows ~= nil then
            Lighting.GlobalShadows = originalShadows.GlobalShadows
        else
            Lighting.GlobalShadows = true
        end
        
        if originalShadows.ShadowSoftness ~= nil then
            Lighting.ShadowSoftness = originalShadows.ShadowSoftness
        else
            Lighting.ShadowSoftness = 0.5
        end
        
        if originalShadows.ShadowColor ~= nil then
            Lighting.ShadowColor = originalShadows.ShadowColor
        else
            Lighting.ShadowColor = Color3.new(0, 0, 0)
        end
        
        if originalShadows.Ambient ~= nil then
            Lighting.Ambient = originalShadows.Ambient
        end
        
        if originalShadows.OutdoorAmbient ~= nil then
            Lighting.OutdoorAmbient = originalShadows.OutdoorAmbient
        end
        
        Notify("No Shadow", "Mode No Shadow dinonaktifkan", 2)
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
    Title = "SOVEREIGN BOOSTER",
    Icon = "zap",
    Author = "Premium Version",
    Folder = "SovereignBooster",
    Size = UDim2.fromOffset(450, 400),
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

Notify("SOVEREIGN Booster", "Script Berhasil Dimuat!\nFitur premium siap digunakan!", 4)

-------------------------------------------
----- =======[ TAB UTAMA ] =======
-------------------------------------------

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "home"
})

-- Section FPS Limit
local SectionFPS = MainTab:Section({
    Title = "FPS OPTIMIZATION",
    Icon = "gauge"
})

local selectedFPS = "60"

local DropdownFPS = SectionFPS:Dropdown({
    Title = "FPS Limit",
    Content = "Pilih batas FPS yang diinginkan",
    Values = {"15", "30", "60", "90", "120", "144", "240"},
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
    Title = "Apply FPS Limit",
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

-- Section Performance
local SectionPerformance = MainTab:Section({
    Title = "PERFORMANCE",
    Icon = "cpu"
})

SectionPerformance:Toggle({
    Title = "Low Graphic Mode",
    Content = "Minimalkan pengaturan grafik",
    Callback = function(value)
        ToggleLowGraphic(value)
    end
})

SectionPerformance:Toggle({
    Title = "No Texture Mode",
    Content = "Nonaktifkan semua tekstur",
    Callback = function(value)
        ToggleNoTexture(value)
    end
})

-- =======[ SECTION BARU: NO SHADOW ] =======
SectionPerformance:Toggle({
    Title = "No Shadow Mode",
    Content = "Hapus semua bayangan di map",
    Callback = function(value)
        ToggleNoShadow(value)
    end
})

-------------------------------------------
----- =======[ TAB UTILITY ] =======
-------------------------------------------

local UtilityTab = Window:Tab({
    Title = "Utility",
    Icon = "tool"
})

-- Section Camera
local SectionCamera = UtilityTab:Section({
    Title = "CAMERA",
    Icon = "camera"
})

local fieldOfView = 70
SectionCamera:Slider({
    Title = "Field of View",
    Min = 30,
    Max = 120,
    Default = 70,
    Callback = function(value)
        fieldOfView = value
        if game.Workspace.CurrentCamera then
            game.Workspace.CurrentCamera.FieldOfView = value
        end
    end
})

SectionCamera:Button({
    Title = "Apply FOV",
    Content = "Terapkan pengaturan FOV",
    Callback = function()
        if game.Workspace.CurrentCamera then
            game.Workspace.CurrentCamera.FieldOfView = fieldOfView
            Notify("Camera", "FOV diatur ke: " .. fieldOfView, 2)
        end
    end
})

-- Section Visual
local SectionVisual = UtilityTab:Section({
    Title = "VISUAL",
    Icon = "eye"
})

local fullBrightEnabled = false
SectionVisual:Toggle({
    Title = "Full Bright",
    Content = "Meningkatkan kecerahan",
    Callback = function(value)
        fullBrightEnabled = value
        if value then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GeographicLatitude = 41.733
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            Lighting.Brightness = 1
        end
        Notify("Full Bright", value and "Diaktifkan" or "Dinonaktifkan", 2)
    end
})

-------------------------------------------
----- =======[ TAB SERVER ] =======
-------------------------------------------

local ServerTab = Window:Tab({
    Title = "Server",
    Icon = "server"
})

-- Section Server Control
local SectionControl = ServerTab:Section({
    Title = "SERVER CONTROL",
    Icon = "settings"
})

SectionControl:Button({
    Title = "Rejoin Server",
    Content = "Bergabung kembali ke server yang sama",
    Callback = function()
        RejoinServer()
    end
})

SectionControl:Button({
    Title = "Server Hop",
    Content = "Bergabung ke server yang berbeda",
    Callback = function()
        JoinServerHop()
    end
})

SectionControl:Button({
    Title = "Copy Job ID",
    Content = "Salin ID server saat ini",
    Callback = function()
        local jobId = game.JobId
        if jobId and jobId ~= "" then
            pcall(function()
                setclipboard(jobId)
                Notify("Server", "Job ID disalin: " .. jobId, 3)
            end)
        end
    end
})

-- Section Server Info
local SectionInfo = ServerTab:Section({
    Title = "SERVER INFO",
    Icon = "info"
})

local playersCount = #Players:GetPlayers()
local maxPlayers = game.PlaceId and 50 or 20

SectionInfo:Label({
    Title = "Players",
    Content = playersCount .. "/" .. maxPlayers
})

SectionInfo:Label({
    Title = "Place ID",
    Content = tostring(game.PlaceId)
})

SectionInfo:Button({
    Title = "Refresh Info",
    Content = "Perbarui informasi server",
    Callback = function()
        playersCount = #Players:GetPlayers()
        Notify("Server Info", "Informasi server diperbarui", 2)
    end
})

-------------------------------------------
----- =======[ TAB INFO ] =======
-------------------------------------------

local InfoTab = Window:Tab({
    Title = "Info",
    Icon = "info"
})

-- Section About
local SectionAbout = InfoTab:Section({
    Title = "ABOUT",
    Icon = "package"
})

SectionAbout:Label({
    Title = "SOVEREIGN BOOSTER",
    Content = "Premium Performance Tool"
})

SectionAbout:Label({
    Title = "Version",
    Content = "2.1 Premium"
})

SectionAbout:Label({
    Title = "Status",
    Content = "Active ✓"
})

-- Section Creator
local SectionCreator = InfoTab:Section({
    Title = "CREATOR",
    Icon = "user"
})

SectionCreator:Label({
    Title = "Developer",
    Content = "SOVEREIGN Team"
})

SectionCreator:Button({
    Title = "Discord",
    Content = "Join our Discord server",
    Callback = function()
        pcall(function()
            setclipboard("https://discord.gg/sovereign")
            Notify("Discord", "Link Discord disalin!", 3)
        end)
    end
})

-- Section Reset
local SectionReset = InfoTab:Section({
    Title = "SYSTEM",
    Icon = "refresh-cw"
})

SectionReset:Button({
    Title = "Reset All Settings",
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
        
        -- Reset No Shadow
        if noShadowEnabled then
            ToggleNoShadow(false)
        end
        
        -- Reset Full Bright
        if fullBrightEnabled then
            Lighting.Brightness = 1
            fullBrightEnabled = false
        end
        
        -- Reset Camera FOV
        if game.Workspace.CurrentCamera then
            game.Workspace.CurrentCamera.FieldOfView = 70
        end
        
        Notify("System Reset", "Semua pengaturan direset ke default", 3)
    end
})

SectionReset:Button({
    Title = "Hide UI",
    Content = "Sembunyikan antarmuka",
    Callback = function()
        pcall(function()
            Window:Close()
            Notify("UI", "Antarmuka disembunyikan", 2)
        end)
    end
})

-------------------------------------------
----- =======[ NOTIFIKASI AKHIR ] =======
-------------------------------------------

task.wait(2)
Notify("SOVEREIGN Booster Premium", 
    "Fitur Premium Tersedia:\n• FPS LIMIT (15-240 FPS)\n• LOW GRAPHIC MODE\n• NO TEXTURE MODE\n• NO SHADOW MODE (NEW!)\n• CAMERA FOV CONTROL\n• FULL BRIGHT MODE\n• SERVER MANAGEMENT\n\nGunakan RightShift untuk toggle UI", 
    6)

-- Auto apply default settings
task.spawn(function()
    task.wait(3)
    SetFPSLimit(60)
    Notify("Auto Setup", "Pengaturan default diterapkan", 2)
end)

return {
    Window = Window,
    Version = "2.1 Premium"
}

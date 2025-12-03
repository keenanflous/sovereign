----- =======[ LOADING SCREEN ] =======
-------------------------------------------

local LoadingUI = Instance.new("ScreenGui")
local LoadingFrame = Instance.new("Frame")
local LoadingLabel = Instance.new("TextLabel")
local ProgressBar = Instance.new("Frame")
local ProgressFill = Instance.new("Frame")
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

local UICorner = Instance.new("UICorner")
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

local UICorner_2 = Instance.new("UICorner")
UICorner_2.Parent = ProgressBar

ProgressFill.Name = "ProgressFill"
ProgressFill.Parent = ProgressBar
ProgressFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
ProgressFill.BorderSizePixel = 0
ProgressFill.Size = UDim2.new(0, 0, 1, 0)

local UICorner_3 = Instance.new("UICorner")
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

local WindUI
local success, errorMsg = pcall(function()
    WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success then
    warn("Gagal memuat WindUI: " .. tostring(errorMsg))
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ERROR",
        Text = "Gagal memuat WindUI Library",
        Duration = 5
    })
    return
end

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
        Lighting.ShadowColor = Color3.new(1, 1, 1)
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        
        -- Nonaktifkan shadow pada semua BasePart di workspace
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.CastShadow = false
            end
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

-- =======[ FITUR BARU: NO NIGHT ] =======
local noNightEnabled = false
local originalLighting = {}
local nightLoopConnection = nil

local function ToggleNoNight(enabled)
    noNightEnabled = enabled
    
    if enabled then
        -- Simpan pengaturan lighting asli
        originalLighting.ClockTime = Lighting.ClockTime
        originalLighting.TimeOfDay = Lighting.TimeOfDay
        originalLighting.GeographicLatitude = Lighting.GeographicLatitude
        originalLighting.ExposureCompensation = Lighting.ExposureCompensation
        originalLighting.Brightness = Lighting.Brightness
        
        -- Atur waktu menjadi siang hari terus
        Lighting.ClockTime = 14
        Lighting.TimeOfDay = "14:00:00"
        Lighting.GeographicLatitude = 0
        Lighting.ExposureCompensation = 1
        Lighting.Brightness = 2
        
        -- Lock waktu agar tidak berubah
        if nightLoopConnection then
            nightLoopConnection:Disconnect()
        end
        
        nightLoopConnection = RunService.Heartbeat:Connect(function()
            if noNightEnabled then
                Lighting.ClockTime = 14
                Lighting.TimeOfDay = "14:00:00"
                
                -- Pastikan tidak ada efek malam
                Lighting.FogEnd = 1000000
                Lighting.FogStart = 999999
                Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
                Lighting.Ambient = Color3.fromRGB(128, 128, 128)
            end
        end)
        
        Notify("No Night", "Mode No Night diaktifkan\nMalam hari dihilangkan!", 3)
    else
        -- Hentikan loop
        if nightLoopConnection then
            nightLoopConnection:Disconnect()
            nightLoopConnection = nil
        end
        
        -- Kembalikan pengaturan asli
        if originalLighting.ClockTime ~= nil then
            Lighting.ClockTime = originalLighting.ClockTime
        else
            Lighting.ClockTime = 12
        end
        
        if originalLighting.TimeOfDay ~= nil then
            Lighting.TimeOfDay = originalLighting.TimeOfDay
        end
        
        if originalLighting.GeographicLatitude ~= nil then
            Lighting.GeographicLatitude = originalLighting.GeographicLatitude
        end
        
        if originalLighting.ExposureCompensation ~= nil then
            Lighting.ExposureCompensation = originalLighting.ExposureCompensation
        end
        
        if originalLighting.Brightness ~= nil then
            Lighting.Brightness = originalLighting.Brightness
        else
            Lighting.Brightness = 1
        end
        
        Notify("No Night", "Mode No Night dinonaktifkan", 2)
    end
end

-- =======[ FITUR BARU: SPEED HACK ] =======
local speedHackEnabled = false
local currentSpeed = 16
local speedLoopConnection = nil
local originalWalkspeed = 16

local function ToggleSpeedHack(enabled, speed)
    speedHackEnabled = enabled
    
    if enabled then
        -- Simpan walkspeed asli
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            originalWalkspeed = LocalPlayer.Character.Humanoid.WalkSpeed
        end
        
        -- Atur walkspeed
        currentSpeed = speed or currentSpeed
        
        -- Hentikan loop sebelumnya jika ada
        if speedLoopConnection then
            speedLoopConnection:Disconnect()
        end
        
        -- Loop untuk terus mengupdate walkspeed
        speedLoopConnection = RunService.Heartbeat:Connect(function()
            if speedHackEnabled and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = currentSpeed
                end
            end
        end)
        
        -- Atur walkspeed sekarang juga
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = currentSpeed
        end
        
        Notify("Speed Hack", "Speed Hack diaktifkan\nKecepatan: " .. currentSpeed .. " studs", 3)
    else
        -- Hentikan loop
        if speedLoopConnection then
            speedLoopConnection:Disconnect()
            speedLoopConnection = nil
        end
        
        -- Kembalikan walkspeed asli
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = originalWalkspeed
        end
        
        Notify("Speed Hack", "Speed Hack dinonaktifkan", 2)
    end
end

-- Fungsi untuk update speed
local function UpdateSpeed(newSpeed)
    currentSpeed = newSpeed
    if speedHackEnabled then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = currentSpeed
        end
        Notify("Speed Hack", "Kecepatan diatur ke: " .. currentSpeed .. " studs", 2)
    end
end

-- =======[ FITUR BARU: JUMP HACK ] =======
local jumpHackEnabled = false
local currentJumpPower = 50
local jumpLoopConnection = nil
local originalJumpPower = 50

local function ToggleJumpHack(enabled, power)
    jumpHackEnabled = enabled
    
    if enabled then
        -- Simpan jump power asli
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            originalJumpPower = LocalPlayer.Character.Humanoid.JumpPower
        end
        
        -- Atur jump power
        currentJumpPower = power or currentJumpPower
        
        -- Hentikan loop sebelumnya jika ada
        if jumpLoopConnection then
            jumpLoopConnection:Disconnect()
        end
        
        -- Loop untuk terus mengupdate jump power
        jumpLoopConnection = RunService.Heartbeat:Connect(function()
            if jumpHackEnabled and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.JumpPower = currentJumpPower
                end
            end
        end)
        
        -- Atur jump power sekarang juga
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = currentJumpPower
        end
        
        Notify("Jump Hack", "Jump Hack diaktifkan\nJump Power: " .. currentJumpPower, 3)
    else
        -- Hentikan loop
        if jumpLoopConnection then
            jumpLoopConnection:Disconnect()
            jumpLoopConnection = nil
        end
        
        -- Kembalikan jump power asli
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = originalJumpPower
        end
        
        Notify("Jump Hack", "Jump Hack dinonaktifkan", 2)
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

local Window
local success2, errorMsg2 = pcall(function()
    Window = WindUI:CreateWindow({
        Title = "SOVEREIGN BOOSTER",
        Icon = "zap",
        Author = "Premium Version",
        Folder = "SovereignBooster",
        Size = UDim2.fromOffset(500, 500),
        Theme = "Indigo",
        KeySystem = false
    })
end)

if not success2 then
    warn("Gagal membuat window: " .. tostring(errorMsg2))
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ERROR",
        Text = "Gagal membuat UI Window",
        Duration = 5
    })
    return
end

-- Set toggle key
pcall(function()
    Window:SetToggleKey(Enum.KeyCode.RightShift)
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

SectionPerformance:Toggle({
    Title = "No Shadow Mode",
    Content = "Hapus semua bayangan di map",
    Callback = function(value)
        ToggleNoShadow(value)
    end
})

SectionPerformance:Toggle({
    Title = "No Night Mode",
    Content = "Hilangkan malam hari",
    Callback = function(value)
        ToggleNoNight(value)
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

local fovInputValue = "70"

SectionCamera:Input({
    Title = "Field of View",
    Desc = "Masukkan nilai FOV (30-120)",  -- Ganti "Content" menjadi "Desc"
    Default = "70",
    Callback = function(value)
        fovInputValue = value
        local fov = tonumber(value)
        if fov and fov >= 30 and fov <= 120 then
            if game.Workspace.CurrentCamera then
                game.Workspace.CurrentCamera.FieldOfView = fov
                Notify("Camera", "FOV diatur ke: " .. fov, 2)
            end
        end
    end
})

SectionCamera:Button({
    Title = "Apply FOV",
    Content = "Terapkan pengaturan FOV",
    Callback = function()
        local fov = tonumber(fovInputValue)
        if fov and fov >= 30 and fov <= 120 then
            if game.Workspace.CurrentCamera then
                game.Workspace.CurrentCamera.FieldOfView = fov
                Notify("Camera", "FOV diatur ke: " .. fov, 2)
            end
        else
            Notify("Error", "Nilai FOV tidak valid", 3)
        end
    end
})

-- Section Movement
local SectionSpeed = UtilityTab:Section({
    Title = "MOVEMENT",
    Icon = "zap"
})

local speedInputValue = "16"

SectionSpeed:Input({
    Title = "Walk Speed",
    Desc = "Masukkan kecepatan (16-500)",  -- Ganti "Content" menjadi "Desc"
    Default = "16",
    Callback = function(value)
        speedInputValue = value
    end
})

SectionSpeed:Toggle({
    Title = "Enable Speed Hack",
    Content = "Aktifkan kecepatan gerak",
    Callback = function(value)
        local speed = tonumber(speedInputValue) or 16
        if speed < 16 then speed = 16 end
        if speed > 500 then speed = 500 end
        ToggleSpeedHack(value, speed)
    end
})

SectionSpeed:Button({
    Title = "Apply Speed",
    Content = "Terapkan kecepatan",
    Callback = function()
        local speed = tonumber(speedInputValue)
        if speed and speed >= 16 and speed <= 500 then
            if speedHackEnabled then
                UpdateSpeed(speed)
            else
                Notify("Speed", "Aktifkan Speed Hack terlebih dahulu", 3)
            end
        else
            Notify("Error", "Kecepatan harus antara 16-500", 3)
        end
    end
})

-- Section Jump Hack
local jumpInputValue = "50"

SectionSpeed:Input({
    Title = "Jump Power",
    Desc = "Masukkan jump power (50-200)",  -- Ganti "Content" menjadi "Desc"
    Default = "50",
    Callback = function(value)
        jumpInputValue = value
    end
})

SectionSpeed:Toggle({
    Title = "Enable Jump Hack",
    Content = "Aktifkan jump power",
    Callback = function(value)
        local jumpPower = tonumber(jumpInputValue) or 50
        if jumpPower < 50 then jumpPower = 50 end
        if jumpPower > 200 then jumpPower = 200 end
        ToggleJumpHack(value, jumpPower)
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
    Content = "2.3 Premium"
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
        
        -- Reset No Night
        if noNightEnabled then
            ToggleNoNight(false)
        end
        
        -- Reset Speed Hack
        if speedHackEnabled then
            ToggleSpeedHack(false)
        end
        
        -- Reset Jump Hack
        if jumpHackEnabled then
            ToggleJumpHack(false)
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
        
        -- Reset input values
        fovInputValue = "70"
        speedInputValue = "16"
        jumpInputValue = "50"
        
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
    "Fitur Premium Tersedia:\n• FPS LIMIT (15-240 FPS)\n• LOW GRAPHIC MODE\n• NO TEXTURE MODE\n• NO SHADOW MODE\n• NO NIGHT MODE\n• SPEED HACK\n• JUMP HACK\n• CAMERA FOV CONTROL\n• FULL BRIGHT MODE\n• SERVER MANAGEMENT\n\nGunakan RightShift untuk toggle UI", 
    7)

-- Auto apply default settings
task.spawn(function()
    task.wait(3)
    SetFPSLimit(60)
    Notify("Auto Setup", "Pengaturan default diterapkan", 2)
end)

print("SOVEREIGN BOOSTER Premium v2.3 Loaded Successfully!")
return {
    Window = Window,
    Version = "2.3 Premium"
}

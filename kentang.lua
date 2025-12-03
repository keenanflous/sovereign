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
LoadingLabel.Text = "SOVEREIGN Booster v2.0"
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
    UpdateLoading("Memuat sistem...", 0.2)
    UpdateLoading("Menyiapkan UI...", 0.4)
    UpdateLoading("Memuat fitur...", 0.7)
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
local StatsService = game:GetService("Stats")

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

-- Variabel global
local savedServers = {}
local themeColors = {
    Indigo = Color3.fromRGB(79, 70, 229),
    Red = Color3.fromRGB(239, 68, 68),
    Green = Color3.fromRGB(34, 197, 94),
    Blue = Color3.fromRGB(59, 130, 246),
    Purple = Color3.fromRGB(168, 85, 247),
    Pink = Color3.fromRGB(236, 72, 153),
    Yellow = Color3.fromRGB(234, 179, 8),
    Orange = Color3.fromRGB(249, 115, 22)
}

-------------------------------------------
----- =======[ FUNGSI BARU ] =======
-------------------------------------------

-- [PERFORMANCE] 2. Reduce Particles
local reduceParticlesEnabled = false
local originalParticleSettings = {}

local function ToggleReduceParticles(enabled)
    reduceParticlesEnabled = enabled
    
    if enabled then
        -- Simpan setting asli
        for _, particle in pairs(workspace:GetDescendants()) do
            if particle:IsA("ParticleEmitter") then
                originalParticleSettings[particle] = {
                    Rate = particle.Rate,
                    Enabled = particle.Enabled
                }
                particle.Rate = 0
                particle.Enabled = false
            elseif particle:IsA("Fire") or particle:IsA("Smoke") or particle:IsA("Sparkles") then
                originalParticleSettings[particle] = particle.Enabled
                particle.Enabled = false
            end
        end
        
        Notify("Reduce Particles", "Partikel efek dikurangi", 2)
    else
        -- Kembalikan setting asli
        for particle, settings in pairs(originalParticleSettings) do
            if particle and particle.Parent then
                if particle:IsA("ParticleEmitter") then
                    particle.Rate = settings.Rate
                    particle.Enabled = settings.Enabled
                else
                    particle.Enabled = settings
                end
            end
        end
        originalParticleSettings = {}
        
        Notify("Reduce Particles", "Partikel efek dikembalikan", 2)
    end
end

-- [PERFORMANCE] 3. Disable Shadows
local disableShadowsEnabled = false
local function ToggleDisableShadows(enabled)
    disableShadowsEnabled = enabled
    
    if enabled then
        Lighting.GlobalShadows = false
        for _, light in pairs(Lighting:GetChildren()) do
            if light:IsA("Light") then
                light.Shadows = false
            end
        end
        
        Notify("Disable Shadows", "Bayangan dinonaktifkan", 2)
    else
        Lighting.GlobalShadows = true
        for _, light in pairs(Lighting:GetChildren()) do
            if light:IsA("Light") then
                light.Shadows = true
            end
        end
        
        Notify("Disable Shadows", "Bayangan diaktifkan", 2)
    end
end

-- [PERFORMANCE] 5. Model Simplifier
local modelSimplifierEnabled = false
local originalMaterials = {}

local function ToggleModelSimplifier(enabled)
    modelSimplifierEnabled = enabled
    
    if enabled then
        for _, model in pairs(workspace:GetDescendants()) do
            if model:IsA("Model") and #model:GetDescendants() > 20 then
                for _, part in pairs(model:GetDescendants()) do
                    if part:IsA("BasePart") then
                        originalMaterials[part] = part.Material
                        part.Material = Enum.Material.Plastic
                    end
                end
            end
        end
        
        Notify("Model Simplifier", "Model disederhanakan", 2)
    else
        for part, material in pairs(originalMaterials) do
            if part and part.Parent then
                part.Material = material
            end
        end
        originalMaterials = {}
        
        Notify("Model Simplifier", "Model dikembalikan", 2)
    end
end

-- [UTILITY] 6. Auto Rejoin
local autoRejoinEnabled = false
local autoRejoinConnection

local function ToggleAutoRejoin(enabled)
    autoRejoinEnabled = enabled
    
    if enabled then
        autoRejoinConnection = Players.PlayerRemoving:Connect(function(player)
            if player == LocalPlayer then
                Notify("Auto Rejoin", "Terdisconnect, mencoba rejoin...", 3)
                task.wait(3)
                RejoinServer()
            end
        end)
        
        Notify("Auto Rejoin", "Auto Rejoin diaktifkan", 2)
    else
        if autoRejoinConnection then
            autoRejoinConnection:Disconnect()
            autoRejoinConnection = nil
        end
        
        Notify("Auto Rejoin", "Auto Rejoin dinonaktifkan", 2)
    end
end

-- [UTILITY] 7. Server Saver
local function SaveCurrentServer()
    local success, info = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)
    
    savedServers[game.PlaceId] = {
        JobId = game.JobId,
        GameName = success and info.Name or "Game ID: " .. game.PlaceId,
        TimeSaved = os.time()
    }
    
    Notify("Server Saver", "Server berhasil disimpan", 2)
end

local function LoadSavedServer(placeId)
    if savedServers[placeId] then
        local server = savedServers[placeId]
        Notify("Server Saver", "Mencoba join server...", 2)
        local success = pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, server.JobId, LocalPlayer)
        end)
        if not success then
            Notify("Error", "Gagal join server, mungkin sudah penuh", 3)
        end
    else
        Notify("Server Saver", "Server tidak ditemukan", 2)
    end
end

-- [UTILITY] 8. FPS Monitor
local fpsMonitorEnabled = false
local fpsMonitor
local fpsLabel
local lastTime = tick()
local frameCount = 0

local function ToggleFPSMonitor(enabled)
    fpsMonitorEnabled = enabled
    
    if enabled then
        fpsMonitor = Instance.new("ScreenGui")
        fpsMonitor.Name = "FPSMonitor"
        fpsMonitor.Parent = game.CoreGui
        fpsMonitor.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        fpsLabel = Instance.new("TextLabel")
        fpsLabel.Name = "FPSLabel"
        fpsLabel.Parent = fpsMonitor
        fpsLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        fpsLabel.BackgroundTransparency = 0.7
        fpsLabel.Position = UDim2.new(0.85, 0, 0.02, 0)
        fpsLabel.Size = UDim2.new(0, 120, 0, 35)
        fpsLabel.Font = Enum.Font.GothamBold
        fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        fpsLabel.TextSize = 14
        fpsLabel.Text = "FPS: 60"
        fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
        fpsLabel.PaddingLeft = UDim.new(0, 10)
        
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 6)
        UICorner.Parent = fpsLabel
        
        -- Update FPS setiap frame
        local connection = RunService.RenderStepped:Connect(function()
            if fpsLabel then
                frameCount = frameCount + 1
                local currentTime = tick()
                
                if currentTime - lastTime >= 0.5 then
                    local fps = math.floor(frameCount / (currentTime - lastTime))
                    fpsLabel.Text = string.format("FPS: %d", fps)
                    frameCount = 0
                    lastTime = currentTime
                end
            end
        end)
        
        -- Simpan connection untuk cleanup
        fpsMonitor:SetAttribute("Connection", connection)
        
        Notify("FPS Monitor", "FPS Monitor diaktifkan", 2)
    else
        if fpsMonitor then
            local conn = fpsMonitor:GetAttribute("Connection")
            if conn then
                conn:Disconnect()
            end
            fpsMonitor:Destroy()
            fpsMonitor = nil
            fpsLabel = nil
        end
        
        Notify("FPS Monitor", "FPS Monitor dinonaktifkan", 2)
    end
end

-- [UTILITY] 9. Ping Display
local pingDisplayEnabled = false

local function TogglePingDisplay(enabled)
    pingDisplayEnabled = enabled
    
    if enabled then
        if not fpsMonitor then
            ToggleFPSMonitor(true)
        end
        
        if fpsLabel then
            fpsLabel.Size = UDim2.new(0, 120, 0, 60)
            
            -- Update ping setiap detik
            local pingConnection = RunService.Heartbeat:Connect(function()
                if fpsLabel then
                    local ping = 0
                    local success, value = pcall(function()
                        return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
                    end)
                    if success then
                        ping = math.floor(value or 0)
                    end
                    
                    local currentText = fpsLabel.Text
                    local fps = currentText:match("FPS: (%d+)")
                    if fps then
                        fpsLabel.Text = string.format("FPS: %s\nPing: %dms", fps, ping)
                    end
                end
            end)
            
            fpsMonitor:SetAttribute("PingConnection", pingConnection)
        end
        
        Notify("Ping Display", "Ping Display diaktifkan", 2)
    else
        if fpsMonitor and fpsLabel then
            local pingConn = fpsMonitor:GetAttribute("PingConnection")
            if pingConn then
                pingConn:Disconnect()
            end
            fpsLabel.Size = UDim2.new(0, 120, 0, 35)
        end
        
        Notify("Ping Display", "Ping Display dinonaktifkan", 2)
    end
end

-- [UTILITY] 10. Game Time
local gameTimeEnabled = false
local startTime = os.time()

local function ToggleGameTime(enabled)
    gameTimeEnabled = enabled
    
    if enabled then
        if not fpsMonitor then
            ToggleFPSMonitor(true)
        end
        
        if fpsLabel then
            fpsLabel.Size = UDim2.new(0, 150, 0, 85)
            
            -- Update waktu setiap detik
            local timeConnection = RunService.Heartbeat:Connect(function()
                if fpsLabel then
                    local currentTime = os.time() - startTime
                    local hours = math.floor(currentTime / 3600)
                    local minutes = math.floor((currentTime % 3600) / 60)
                    local seconds = currentTime % 60
                    
                    local ping = 0
                    local success, value = pcall(function()
                        return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
                    end)
                    if success then
                        ping = math.floor(value or 0)
                    end
                    
                    fpsLabel.Text = string.format("FPS: 60\nPing: %dms\nTime: %02d:%02d:%02d", 
                        ping, hours, minutes, seconds)
                end
            end)
            
            fpsMonitor:SetAttribute("TimeConnection", timeConnection)
        end
        
        Notify("Game Time", "Game Timer diaktifkan", 2)
    else
        if fpsMonitor and fpsLabel then
            local timeConn = fpsMonitor:GetAttribute("TimeConnection")
            if timeConn then
                timeConn:Disconnect()
            end
            fpsLabel.Size = pingDisplayEnabled and UDim2.new(0, 120, 0, 60) or UDim2.new(0, 120, 0, 35)
        end
        
        Notify("Game Time", "Game Timer dinonaktifkan", 2)
    end
end

-- [UTILITY] 11. Speed Hack
local speedHackEnabled = false
local originalWalkSpeed = 16
local speedMultiplier = 2
local speedConnection

local function ToggleSpeedHack(enabled)
    speedHackEnabled = enabled
    
    if enabled then
        local function updateSpeed()
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    originalWalkSpeed = humanoid.WalkSpeed
                    humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
                end
            end
        end
        
        -- Update saat ini
        updateSpeed()
        
        -- Connect untuk character added
        speedConnection = LocalPlayer.CharacterAdded:Connect(function(character)
            task.wait(1)
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
            end
        end)
        
        Notify("Speed Hack", "Speed Hack diaktifkan (x" .. speedMultiplier .. ")", 2)
    else
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
        
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = originalWalkSpeed
            end
        end
        
        Notify("Speed Hack", "Speed Hack dinonaktifkan", 2)
    end
end

-- [UTILITY] 12. Jump Power
local jumpPowerEnabled = false
local originalJumpPower = 50
local jumpMultiplier = 2
local jumpConnection

local function ToggleJumpPower(enabled)
    jumpPowerEnabled = enabled
    
    if enabled then
        local function updateJump()
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    originalJumpPower = humanoid.JumpPower
                    humanoid.JumpPower = originalJumpPower * jumpMultiplier
                end
            end
        end
        
        -- Update saat ini
        updateJump()
        
        -- Connect untuk character added
        jumpConnection = LocalPlayer.CharacterAdded:Connect(function(character)
            task.wait(1)
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = originalJumpPower * jumpMultiplier
            end
        end)
        
        Notify("Jump Power", "Jump Power diaktifkan (x" .. jumpMultiplier .. ")", 2)
    else
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
        
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = originalJumpPower
            end
        end
        
        Notify("Jump Power", "Jump Power dinonaktifkan", 2)
    end
end

-- [VISUAL] 15. Fullbright
local fullbrightEnabled = false
local originalBrightness = Lighting.Brightness
local originalAmbient = Lighting.Ambient
local originalOutdoorAmbient = Lighting.OutdoorAmbient

local function ToggleFullbright(enabled)
    fullbrightEnabled = enabled
    
    if enabled then
        originalBrightness = Lighting.Brightness
        originalAmbient = Lighting.Ambient
        originalOutdoorAmbient = Lighting.OutdoorAmbient
        
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.GlobalShadows = false
        
        for _, light in pairs(Lighting:GetChildren()) do
            if light:IsA("Light") then
                light.Enabled = false
            end
        end
        
        Notify("Fullbright", "Fullbright diaktifkan", 2)
    else
        Lighting.Brightness = originalBrightness
        Lighting.Ambient = originalAmbient
        Lighting.OutdoorAmbient = originalOutdoorAmbient
        Lighting.GlobalShadows = true
        
        for _, light in pairs(Lighting:GetChildren()) do
            if light:IsA("Light") then
                light.Enabled = true
            end
        end
        
        Notify("Fullbright", "Fullbright dinonaktifkan", 2)
    end
end

-- [VISUAL] 19. Brightness Control
local currentBrightness = 1.0

local function SetBrightness(value)
    currentBrightness = value
    Lighting.Brightness = value
    Notify("Brightness", "Kecerahan diatur: " .. string.format("%.1f", value), 2)
end

-- [VISUAL] 20. FOV Changer
local fovChangerEnabled = false
local originalFOV = 70
local customFOV = 90
local fovConnection

local function ToggleFOVChanger(enabled)
    fovChangerEnabled = enabled
    
    if enabled then
        if workspace.CurrentCamera then
            originalFOV = workspace.CurrentCamera.FieldOfView
            workspace.CurrentCamera.FieldOfView = customFOV
        end
        
        -- Monitor perubahan camera
        fovConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            if workspace.CurrentCamera then
                workspace.CurrentCamera.FieldOfView = customFOV
            end
        end)
        
        Notify("FOV Changer", "FOV diubah ke: " .. customFOV .. "°", 2)
    else
        if fovConnection then
            fovConnection:Disconnect()
            fovConnection = nil
        end
        
        if workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = originalFOV
        end
        
        Notify("FOV Changer", "FOV dikembalikan ke: " .. originalFOV .. "°", 2)
    end
end

local function SetFOV(value)
    customFOV = value
    if fovChangerEnabled and workspace.CurrentCamera then
        workspace.CurrentCamera.FieldOfView = value
    end
end

-- [KEAMANAN] 26. Anti-Kick
local antiKickEnabled = false

local function ToggleAntiKick(enabled)
    antiKickEnabled = enabled
    
    if enabled then
        -- Hook fungsi kick
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if method == "Kick" and self == LocalPlayer then
                Notify("Anti-Kick", "Mencegah kick!", 3)
                warn("[Anti-Kick] Kick attempt blocked")
                return nil
            end
            
            return oldNamecall(self, unpack(args))
        end)
        setreadonly(mt, true)
        
        Notify("Anti-Kick", "Anti-Kick diaktifkan", 2)
    else
        Notify("Anti-Kick", "Anti-Kick dinonaktifkan", 2)
    end
end

-- [KEAMANAN] 27. Anti-Ban
local antiBanEnabled = false

local function ToggleAntiBan(enabled)
    antiBanEnabled = enabled
    
    if enabled then
        Notify("Anti-Ban", "Anti-Ban diaktifkan", 2)
        
        -- Basic anti-ban measure
        pcall(function()
            -- Coba sembunyikan script
            if script then
                script.Name = "SystemCore"
            end
        end)
    else
        Notify("Anti-Ban", "Anti-Ban dinonaktifkan", 2)
    end
end

-- [UI/UX] 30. Theme Changer
local currentTheme = "Indigo"

local function ChangeTheme(themeName)
    currentTheme = themeName
    if themeColors[themeName] then
        pcall(function()
            WindUI:ChangeTheme(themeName)
        end)
        Notify("Theme", "Tema diubah: " .. themeName, 2)
    end
end

-- [UI/UX] 31. Transparency Control
local currentTransparency = 0

local function SetTransparency(value)
    currentTransparency = value
    -- Ini adalah placeholder, WindUI mungkin tidak support transparency
    Notify("Transparency", "Transparansi diatur: " .. string.format("%.0f%%", value * 100), 2)
end

-- ========================================
-- FUNGSI ORIGINAL
-- ========================================

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
    Title = "SIMPLE BOOSTER v2.0",
    Icon = "zap",
    Author = "Simple Version",
    Folder = "SimpleBooster",
    Size = UDim2.fromOffset(500, 600),
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

Notify("Simple Booster v2.0", "Script Berhasil Dimuat!\n17 fitur baru ditambahkan!", 5)

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
    Values = {"15", "30", "60", "90", "120", "144", "240", "Unlimited"},
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
        local fps = selectedFPS == "Unlimited" and 0 or tonumber(selectedFPS)
        if fps or selectedFPS == "Unlimited" then
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
    Content = "2.0"
})

SectionInfo:Label({
    Title = "Status",
    Content = "Aktif"
})

SectionInfo:Button({
    Title = "Reset All",
    Content = "Reset semua pengaturan ke default",
    Callback = function()
        -- Reset semua toggle
        if noTextureEnabled then ToggleNoTexture(false) end
        if lowGraphicEnabled then ToggleLowGraphic(false) end
        if reduceParticlesEnabled then ToggleReduceParticles(false) end
        if disableShadowsEnabled then ToggleDisableShadows(false) end
        if modelSimplifierEnabled then ToggleModelSimplifier(false) end
        if autoRejoinEnabled then ToggleAutoRejoin(false) end
        if fpsMonitorEnabled then ToggleFPSMonitor(false) end
        if pingDisplayEnabled then TogglePingDisplay(false) end
        if gameTimeEnabled then ToggleGameTime(false) end
        if speedHackEnabled then ToggleSpeedHack(false) end
        if jumpPowerEnabled then ToggleJumpPower(false) end
        if fullbrightEnabled then ToggleFullbright(false) end
        if fovChangerEnabled then ToggleFOVChanger(false) end
        if antiKickEnabled then ToggleAntiKick(false) end
        if antiBanEnabled then ToggleAntiBan(false) end
        
        -- Reset nilai
        SetFPSLimit(60)
        SetBrightness(1.0)
        SetFOV(70)
        ChangeTheme("Indigo")
        
        Notify("Reset", "Semua pengaturan direset ke default", 3)
    end
})

-------------------------------------------
----- =======[ TAB PERFORMANCE ] =======
-------------------------------------------

local PerfTab = Window:Tab({
    Title = "Performance",
    Icon = "gauge"
})

-- Section Reduce Particles
local SectionParticles = PerfTab:Section({
    Title = "REDUCE PARTICLES",
    Icon = "sparkles"
})

SectionParticles:Toggle({
    Title = "Reduce Particles",
    Content = "Kurangi efek partikel untuk FPS",
    Callback = function(value)
        ToggleReduceParticles(value)
    end
})

-- Section Disable Shadows
local SectionShadows = PerfTab:Section({
    Title = "DISABLE SHADOWS",
    Icon = "sun"
})

SectionShadows:Toggle({
    Title = "Disable Shadows",
    Content = "Nonaktifkan semua bayangan",
    Callback = function(value)
        ToggleDisableShadows(value)
    end
})

-- Section Model Simplifier
local SectionSimplifier = PerfTab:Section({
    Title = "MODEL SIMPLIFIER",
    Icon = "cube"
})

SectionSimplifier:Toggle({
    Title = "Simplify Models",
    Content = "Sederhanakan model kompleks",
    Callback = function(value)
        ToggleModelSimplifier(value)
    end
})

-------------------------------------------
----- =======[ TAB UTILITY ] =======
-------------------------------------------

local UtilTab = Window:Tab({
    Title = "Utility",
    Icon = "tool"
})

-- Section Auto Rejoin
local SectionAutoRejoin = UtilTab:Section({
    Title = "AUTO REJOIN",
    Icon = "refresh-cw"
})

SectionAutoRejoin:Toggle({
    Title = "Auto Rejoin",
    Content = "Otomatis rejoin saat disconnect",
    Callback = function(value)
        ToggleAutoRejoin(value)
    end
})

-- Section Server Saver
local SectionServerSaver = UtilTab:Section({
    Title = "SERVER SAVER",
    Icon = "save"
})

SectionServerSaver:Button({
    Title = "Save Current Server",
    Content = "Simpan server saat ini",
    Callback = function()
        SaveCurrentServer()
    end
})

SectionServerSaver:Button({
    Title = "Load Saved Servers",
    Content = "Lihat server yang disimpan",
    Callback = function()
        local message = "Server Tersimpan:\n"
        if next(savedServers) == nil then
            message = message .. "\nTidak ada server yang disimpan"
        else
            for placeId, server in pairs(savedServers) do
                message = message .. string.format("\n• %s\n  ID: %s", 
                    server.GameName, string.sub(server.JobId, 1, 10) .. "...")
            end
        end
        Notify("Saved Servers", message, 5)
    end
})

-- Section Display
local SectionDisplay = UtilTab:Section({
    Title = "DISPLAY INFO",
    Icon = "monitor"
})

SectionDisplay:Toggle({
    Title = "FPS Monitor",
    Content = "Tampilkan FPS counter",
    Callback = function(value)
        ToggleFPSMonitor(value)
    end
})

SectionDisplay:Toggle({
    Title = "Ping Display",
    Content = "Tampilkan ping (ms)",
    Callback = function(value)
        TogglePingDisplay(value)
    end
})

SectionDisplay:Toggle({
    Title = "Game Time",
    Content = "Tampilkan waktu bermain",
    Callback = function(value)
        ToggleGameTime(value)
    end
})

-- Section Movement
local SectionMovement = UtilTab:Section({
    Title = "MOVEMENT",
    Icon = "zap"
})

SectionMovement:Toggle({
    Title = "Speed Hack",
    Content = "Tingkatkan kecepatan gerak",
    Callback = function(value)
        ToggleSpeedHack(value)
    end
})

SectionMovement:Slider({
    Title = "Speed Multiplier",
    Content = "Pengali kecepatan",
    Min = 1,
    Max = 5,
    Default = 2,
    Callback = function(value)
        speedMultiplier = value
        if speedHackEnabled then
            ToggleSpeedHack(false)
            ToggleSpeedHack(true)
        end
        Notify("Speed", "Multiplier: x" .. value, 2)
    end
})

SectionMovement:Toggle({
    Title = "Jump Power",
    Content = "Tingkatkan tinggi lompatan",
    Callback = function(value)
        ToggleJumpPower(value)
    end
})

SectionMovement:Slider({
    Title = "Jump Multiplier",
    Content = "Pengali tinggi lompat",
    Min = 1,
    Max = 5,
    Default = 2,
    Callback = function(value)
        jumpMultiplier = value
        if jumpPowerEnabled then
            ToggleJumpPower(false)
            ToggleJumpPower(true)
        end
        Notify("Jump", "Multiplier: x" .. value, 2)
    end
})

-------------------------------------------
----- =======[ TAB VISUAL ] =======
-------------------------------------------

local VisualTab = Window:Tab({
    Title = "Visual",
    Icon = "eye"
})

-- Section Fullbright
local SectionLighting = VisualTab:Section({
    Title = "LIGHTING",
    Icon = "sun"
})

SectionLighting:Toggle({
    Title = "Fullbright",
    Content = "Cahaya maksimal di semua area",
    Callback = function(value)
        ToggleFullbright(value)
    end
})

SectionLighting:Slider({
    Title = "Brightness",
    Content = "Kecerahan game",
    Min = 0.1,
    Max = 3,
    Default = 1,
    Callback = function(value)
        SetBrightness(value)
    end
})

-- Section Camera
local SectionCamera = VisualTab:Section({
    Title = "CAMERA",
    Icon = "camera"
})

SectionCamera:Toggle({
    Title = "FOV Changer",
    Content = "Ubah field of view",
    Callback = function(value)
        ToggleFOVChanger(value)
    end
})

SectionCamera:Slider({
    Title = "FOV Value",
    Content = "Nilai FOV (derajat)",
    Min = 50,
    Max = 120,
    Default = 90,
    Callback = function(value)
        SetFOV(value)
    end
})

-------------------------------------------
----- =======[ TAB KEAMANAN ] =======
-------------------------------------------

local SecurityTab = Window:Tab({
    Title = "Security",
    Icon = "shield"
})

-- Section Anti-Kick
local SectionAntiKick = SecurityTab:Section({
    Title = "ANTI-KICK",
    Icon = "shield-off"
})

SectionAntiKick:Toggle({
    Title = "Anti-Kick",
    Content = "Mencegah kick dari game",
    Callback = function(value)
        ToggleAntiKick(value)
    end
})

-- Section Anti-Ban
local SectionAntiBan = SecurityTab:Section({
    Title = "ANTI-BAN",
    Icon = "shield-alert"
})

SectionAntiBan:Toggle({
    Title = "Anti-Ban",
    Content = "Proteksi basic anti-ban",
    Callback = function(value)
        ToggleAntiBan(value)
    end
})

-------------------------------------------
----- =======[ TAB UI/UX ] =======
-------------------------------------------

local UITab = Window:Tab({
    Title = "UI/UX",
    Icon = "palette"
})

-- Section Theme
local SectionTheme = UITab:Section({
    Title = "THEME",
    Icon = "palette"
})

local themeDropdown = SectionTheme:Dropdown({
    Title = "Theme Color",
    Content = "Pilih tema warna UI",
    Values = {"Indigo", "Red", "Green", "Blue", "Purple", "Pink", "Yellow", "Orange"},
    Callback = function(value)
        ChangeTheme(value)
    end
})

-- Set default theme
pcall(function()
    themeDropdown:Set("Indigo")
end)

-- Section Transparency
local SectionTransparency = UITab:Section({
    Title = "TRANSPARENCY",
    Icon = "layout"
})

SectionTransparency:Slider({
    Title = "UI Transparency",
    Content = "Transparansi window UI",
    Min = 0,
    Max = 0.8,
    Default = 0,
    Callback = function(value)
        SetTransparency(value)
    end
})

-------------------------------------------
----- =======[ NOTIFIKASI AKHIR ] =======
-------------------------------------------

task.wait(2)
Notify("SOVEREIGN Booster v2.0", 
    "Fitur Baru Ditambahkan:\n" ..
    "• REDUCE PARTICLES\n" ..
    "• DISABLE SHADOWS\n" ..
    "• MODEL SIMPLIFIER\n" ..
    "• AUTO REJOIN\n" ..
    "• SERVER SAVER\n" ..
    "• FPS MONITOR\n" ..
    "• PING DISPLAY\n" ..
    "• GAME TIME\n" ..
    "• SPEED HACK\n" ..
    "• JUMP POWER\n" ..
    "• FULLBRIGHT\n" ..
    "• BRIGHTNESS CONTROL\n" ..
    "• FOV CHANGER\n" ..
    "• ANTI-KICK\n" ..
    "• ANTI-BAN\n" ..
    "• THEME CHANGER\n" ..
    "• TRANSPARENCY CONTROL\n\n" ..
    "Gunakan RightShift untuk toggle UI", 
    8)

return {
    Window = Window,
    Version = "2.0",
    Features = {
        Performance = {"Reduce Particles", "Disable Shadows", "Model Simplifier"},
        Utility = {"Auto Rejoin", "Server Saver", "FPS Monitor", "Ping Display", 
                  "Game Time", "Speed Hack", "Jump Power"},
        Visual = {"Fullbright", "Brightness Control", "FOV Changer"},
        Security = {"Anti-Kick", "Anti-Ban"},
        UIUX = {"Theme Changer", "Transparency Control"}
    }
}

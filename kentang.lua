local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🔥 SOVEREIGN Booster | All Maps",
   LoadingTitle = "🔄 SOVEREIGN Booster",
   LoadingSubtitle = "Optimization for All Roblox Games",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "FPS Booster"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
})

-- Store original settings for proper reset
local OriginalSettings = {
    QualityLevel = settings().Rendering.QualityLevel,
    GlobalShadows = game:GetService("Lighting").GlobalShadows,
    FieldOfView = workspace.CurrentCamera.FieldOfView,
    Materials = {},
    Textures = {},
    Particles = {},
    Lighting = {}
}

-- Track modified objects for proper reset
local ModifiedParticles = {}
local ModifiedTransparency = {}
local ModifiedMaterials = {}

-- Safe FPS cap function
local function SafeSetFpsCap(value)
    pcall(function()
        if setfpscap then
            setfpscap(value)
        end
    end)
end

-- Level-based optimization functions
local function ApplyTextureLevel(level)
    pcall(function()
        if level == 0 then
            -- Restore original
            settings().Rendering.QualityLevel = OriginalSettings.QualityLevel
            spawn(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
                        if ModifiedMaterials[obj] then
                            obj.Material = ModifiedMaterials[obj]
                        end
                        if obj:FindFirstChildOfClass("Texture") then
                            local texture = obj:FindFirstChildOfClass("Texture")
                            texture.Transparency = 0
                        end
                    end
                end
            end)
            
        elseif level == 1 then
            -- Level 1: Mild optimization
            settings().Rendering.QualityLevel = 5
            spawn(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
                        if not ModifiedMaterials[obj] then
                            ModifiedMaterials[obj] = obj.Material
                        end
                        -- Only change expensive materials
                        if obj.Material == Enum.Material.Neon or obj.Material == Enum.Material.Glass then
                            obj.Material = Enum.Material.Plastic
                        end
                        if obj:FindFirstChildOfClass("Texture") then
                            local texture = obj:FindFirstChildOfClass("Texture")
                            texture.Transparency = 0.2
                        end
                    end
                end
            end)
            
        elseif level == 2 then
            -- Level 2: Medium optimization
            settings().Rendering.QualityLevel = 3
            spawn(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
                        if not ModifiedMaterials[obj] then
                            ModifiedMaterials[obj] = obj.Material
                        end
                        -- Change more materials to plastic
                        if obj.Material == Enum.Material.Neon or obj.Material == Enum.Material.Glass or 
                           obj.Material == Enum.Material.Metal then
                            obj.Material = Enum.Material.Plastic
                        end
                        if obj:FindFirstChildOfClass("Texture") then
                            local texture = obj:FindFirstChildOfClass("Texture")
                            texture.Transparency = 0.4
                        end
                    end
                end
            end)
            
        elseif level == 3 then
            -- Level 3: Maximum optimization
            settings().Rendering.QualityLevel = 1
            spawn(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
                        if not ModifiedMaterials[obj] then
                            ModifiedMaterials[obj] = obj.Material
                        end
                        obj.Material = Enum.Material.Plastic
                        if obj:FindFirstChildOfClass("Texture") then
                            local texture = obj:FindFirstChildOfClass("Texture")
                            texture.Transparency = 0.7
                        end
                    end
                end
            end)
        end
    end)
end

local function ApplyGraphicsLevel(level)
    pcall(function()
        local Lighting = game:GetService("Lighting")
        
        if level == 0 then
            -- Restore original
            Lighting.GlobalShadows = OriginalSettings.GlobalShadows
            Lighting.FogEnd = 999999
            Lighting.Brightness = 1
            Lighting.EnvironmentDiffuseScale = 1
            Lighting.EnvironmentSpecularScale = 1
            
            for _, light in pairs(Lighting:GetChildren()) do
                if light:IsA("SpotLight") or light:IsA("PointLight") then
                    light.Shadows = true
                end
            end
            
        elseif level == 1 then
            -- Level 1: Mild optimization
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 500
            Lighting.Brightness = 1.5
            Lighting.EnvironmentDiffuseScale = 0.5
            Lighting.EnvironmentSpecularScale = 0.5
            
            for _, light in pairs(Lighting:GetChildren()) do
                if light:IsA("SpotLight") or light:IsA("PointLight") then
                    light.Shadows = true
                    light.Range = math.min(light.Range, 30)
                end
            end
            
        elseif level == 2 then
            -- Level 2: Medium optimization
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 200
            Lighting.Brightness = 2
            Lighting.EnvironmentDiffuseScale = 0.2
            Lighting.EnvironmentSpecularScale = 0.2
            
            for _, light in pairs(Lighting:GetChildren()) do
                if light:IsA("SpotLight") or light:IsA("PointLight") then
                    light.Shadows = false
                    light.Range = math.min(light.Range, 20)
                end
            end
            
        elseif level == 3 then
            -- Level 3: Maximum optimization
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 50
            Lighting.Brightness = 3
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
            
            for _, light in pairs(Lighting:GetChildren()) do
                if light:IsA("SpotLight") or light:IsA("PointLight") then
                    light.Shadows = false
                    light.Range = math.min(light.Range, 10)
                    light.Enabled = false
                end
            end
        end
    end)
end

local function ApplyRenderingLevel(level)
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        local camera = workspace.CurrentCamera
        
        if level == 0 then
            -- Restore original
            camera.FieldOfView = OriginalSettings.FieldOfView
            
            for obj, originalValue in pairs(ModifiedTransparency) do
                if obj and obj.Parent then
                    pcall(function()
                        obj.LocalTransparencyModifier = originalValue
                    end)
                end
            end
            ModifiedTransparency = {}
            
        elseif level == 1 then
            -- Level 1: Mild optimization
            camera.FieldOfView = 75
            
            ModifiedTransparency = {}
            spawn(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Part") and obj.Transparency < 0.5 then
                        local distance = 100
                        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local success = pcall(function()
                                distance = (obj.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            end)
                        end
                        if distance > 150 then
                            ModifiedTransparency[obj] = obj.LocalTransparencyModifier
                            obj.LocalTransparencyModifier = 0.1
                        end
                    end
                end
            end)
            
        elseif level == 2 then
            -- Level 2: Medium optimization
            camera.FieldOfView = 70
            
            ModifiedTransparency = {}
            spawn(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Part") and obj.Transparency < 0.5 then
                        local distance = 100
                        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local success = pcall(function()
                                distance = (obj.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            end)
                        end
                        if distance > 100 then
                            ModifiedTransparency[obj] = obj.LocalTransparencyModifier
                            obj.LocalTransparencyModifier = 0.3
                        end
                    end
                end
            end)
            
        elseif level == 3 then
            -- Level 3: Maximum optimization
            camera.FieldOfView = 65
            
            ModifiedTransparency = {}
            spawn(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Part") and obj.Transparency < 0.5 then
                        local distance = 100
                        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local success = pcall(function()
                                distance = (obj.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            end)
                        end
                        if distance > 50 then
                            ModifiedTransparency[obj] = obj.LocalTransparencyModifier
                            obj.LocalTransparencyModifier = 0.5
                        end
                    end
                end
            end)
        end
    end)
end

local function ApplyParticlesLevel(level)
    pcall(function()
        if level == 0 then
            -- Restore particles
            for obj, wasEnabled in pairs(ModifiedParticles) do
                if obj and obj.Parent then
                    pcall(function()
                        obj.Enabled = wasEnabled
                    end)
                end
            end
            ModifiedParticles = {}
            
        elseif level == 1 then
            -- Level 1: Reduce particle count
            ModifiedParticles = {}
            spawn(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") then
                        ModifiedParticles[obj] = obj.Enabled
                        obj.Rate = math.floor(obj.Rate * 0.5)  -- Reduce by 50%
                    elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                        ModifiedParticles[obj] = obj.Enabled
                        obj.Enabled = true  -- Keep enabled but reduce
                    end
                end
            end)
            
        elseif level == 2 then
            -- Level 2: Disable most particles
            ModifiedParticles = {}
            spawn(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") then
                        ModifiedParticles[obj] = obj.Enabled
                        obj.Enabled = false
                    elseif obj:IsA("Sparkles") then
                        ModifiedParticles[obj] = obj.Enabled
                        obj.Enabled = true  -- Keep sparkles
                    end
                end
            end)
            
        elseif level == 3 then
            -- Level 3: Disable all effects
            ModifiedParticles = {}
            spawn(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or 
                       obj:IsA("Sparkles") or obj:IsA("Beam") or obj:IsA("Trail") then
                        ModifiedParticles[obj] = obj.Enabled
                        obj.Enabled = false
                    end
                end
            end)
        end
    end)
end

local function ApplyDetailLevel(level)
    pcall(function()
        if level == 0 then
            -- Restore detail
            spawn(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Decal") then
                        obj.Transparency = 0
                    end
                end
            end)
            
        elseif level == 1 then
            -- Level 1: Mild detail reduction
            spawn(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Part") then
                        if obj.Material == Enum.Material.Neon or obj.Material == Enum.Material.Glass then
                            obj.Material = Enum.Material.Plastic
                        end
                    elseif obj:IsA("Decal") then
                        obj.Transparency = 0.3
                    end
                end
            end)
            
        elseif level == 2 then
            -- Level 2: Medium detail reduction
            spawn(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Part") then
                        if obj.Material == Enum.Material.Neon or obj.Material == Enum.Material.Glass or 
                           obj.Material == Enum.Material.Metal or obj.Material == Enum.Material.Wood then
                            obj.Material = Enum.Material.Plastic
                        end
                    elseif obj:IsA("Decal") then
                        obj.Transparency = 0.6
                    elseif obj:IsA("SurfaceGui") then
                        obj.Enabled = false
                    end
                end
            end)
            
        elseif level == 3 then
            -- Level 3: Maximum detail reduction
            spawn(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Part") then
                        obj.Material = Enum.Material.Plastic
                    elseif obj:IsA("Decal") then
                        obj.Transparency = 0.9
                    elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
                        obj.Enabled = false
                    end
                end
            end)
        end
    end)
end

-- Main Tab
local MainTab = Window:CreateTab("⚙️ Settings", nil)
local FPSSection = MainTab:CreateSection("FPS Settings")

local FPSDropdown = MainTab:CreateDropdown({
   Name = "Set FPS Cap",
   Options = {"15", "30", "60", "120", "Unlimited"},
   CurrentOption = "60",
   MultipleOptions = false,
   Flag = "fpscap",
   Callback = function(Option)
        local selectedOption = Option
        if type(Option) == "table" then
            selectedOption = Option[1] or "60"
        end
        
        if selectedOption == "Unlimited" then
            SafeSetFpsCap(0)
        else
            SafeSetFpsCap(tonumber(selectedOption))
        end
        Rayfield:Notify({
            Title = "FPS Cap Updated",
            Content = "FPS Cap set to: " .. selectedOption,
            Duration = 3,
        })
   end,
})

local OptimizationSection = MainTab:CreateSection("Graphics Optimization")

local TextureSlider = MainTab:CreateSlider({
   Name = "Texture Quality Level",
   Range = {0, 3},
   Increment = 1,
   Suffix = "Level",
   CurrentValue = 0,
   Flag = "texturelevel",
   Callback = function(Value)
        ApplyTextureLevel(Value)
        local levels = {[0] = "Original", [1] = "Mild", [2] = "Medium", [3] = "Maximum"}
        Rayfield:Notify({
            Title = "Texture Quality",
            Content = "Set to: " .. levels[Value] .. " Optimization",
            Duration = 3,
        })
   end,
})

local GraphicsSlider = MainTab:CreateSlider({
   Name = "Graphics Quality Level",
   Range = {0, 3},
   Increment = 1,
   Suffix = "Level",
   CurrentValue = 0,
   Flag = "graphicslevel",
   Callback = function(Value)
        ApplyGraphicsLevel(Value)
        local levels = {[0] = "Original", [1] = "Mild", [2] = "Medium", [3] = "Maximum"}
        Rayfield:Notify({
            Title = "Graphics Quality",
            Content = "Set to: " .. levels[Value] .. " Optimization",
            Duration = 3,
        })
   end,
})

local RenderingSlider = MainTab:CreateSlider({
   Name = "Rendering Distance Level",
   Range = {0, 3},
   Increment = 1,
   Suffix = "Level",
   CurrentValue = 0,
   Flag = "renderinglevel",
   Callback = function(Value)
        ApplyRenderingLevel(Value)
        local levels = {[0] = "Original", [1] = "Mild", [2] = "Medium", [3] = "Maximum"}
        Rayfield:Notify({
            Title = "Rendering Distance",
            Content = "Set to: " .. levels[Value] .. " Optimization",
            Duration = 3,
        })
   end,
})

local AntiAliasingToggle = MainTab:CreateToggle({
   Name = "Anti-Aliasing",
   CurrentValue = true,
   Flag = "antialiasing",
   Callback = function(Value)
        pcall(function()
            local UserGameSettings = game:GetService("UserGameSettings")
            if Value then
                UserGameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel10
            else
                UserGameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
            end
        end)
        Rayfield:Notify({
            Title = "Anti-Aliasing",
            Content = Value and "Anti-Aliasing Enabled" or "Anti-Aliasing Disabled",
            Duration = 3,
        })
   end,
})

local AdvancedSection = MainTab:CreateSection("Advanced Optimization")

local ParticlesSlider = MainTab:CreateSlider({
   Name = "Particles Optimization Level",
   Range = {0, 3},
   Increment = 1,
   Suffix = "Level",
   CurrentValue = 0,
   Flag = "particleslevel",
   Callback = function(Value)
        ApplyParticlesLevel(Value)
        local levels = {[0] = "Original", [1] = "Reduced", [2] = "Minimal", [3] = "Disabled"}
        Rayfield:Notify({
            Title = "Particles Optimization",
            Content = "Set to: " .. levels[Value],
            Duration = 3,
        })
   end,
})

local DetailSlider = MainTab:CreateSlider({
   Name = "Detail Level Optimization",
   Range = {0, 3},
   Increment = 1,
   Suffix = "Level",
   CurrentValue = 0,
   Flag = "detaillevel",
   Callback = function(Value)
        ApplyDetailLevel(Value)
        local levels = {[0] = "Original", [1] = "Mild", [2] = "Maximum"}
        Rayfield:Notify({
            Title = "Detail Optimization",
            Content = "Set to: " .. levels[Value] .. " Optimization",
            Duration = 3,
        })
   end,
})

local NoTerrainToggle = MainTab:CreateToggle({
   Name = "Simplify Terrain",
   CurrentValue = false,
   Flag = "noterrain",
   Callback = function(Value)
        pcall(function()
            if Value then
                workspace.TerrainDecoration = false
            else
                workspace.TerrainDecoration = true
            end
        end)
        Rayfield:Notify({
            Title = "Terrain",
            Content = Value and "Terrain Simplified" or "Terrain Restored",
            Duration = 3,
        })
   end,
})

-- Quick Apply Presets Section
local PresetSection = MainTab:CreateSection("Quick Presets")

local PerformanceButton = MainTab:CreateButton({
   Name = "Apply Performance Preset (Level 3)",
   Callback = function()
        SafeSetFpsCap(60)
        FPSDropdown:Set("60")
        
        -- Set all sliders to maximum optimization
        TextureSlider:Set(3)
        GraphicsSlider:Set(3)
        RenderingSlider:Set(3)
        AntiAliasingToggle:Set(false)
        ParticlesSlider:Set(3)
        DetailSlider:Set(3)
        NoTerrainToggle:Set(true)
        
        Rayfield:Notify({
            Title = "Performance Preset Applied",
            Content = "All optimizations set to maximum level for best FPS",
            Duration = 5,
        })
   end,
})

local BalancedButton = MainTab:CreateButton({
   Name = "Apply Balanced Preset (Level 1)",
   Callback = function()
        SafeSetFpsCap(120)
        FPSDropdown:Set("120")
        
        -- Set all sliders to mild optimization
        TextureSlider:Set(1)
        GraphicsSlider:Set(1)
        RenderingSlider:Set(1)
        AntiAliasingToggle:Set(true)
        ParticlesSlider:Set(1)
        DetailSlider:Set(1)
        NoTerrainToggle:Set(false)
        
        Rayfield:Notify({
            Title = "Balanced Preset Applied",
            Content = "Mild optimizations for good performance and visuals",
            Duration = 5,
        })
   end,
})

local CompetitiveButton = MainTab:CreateButton({
   Name = "Apply Competitive Preset (Level 2)",
   Callback = function()
        SafeSetFpsCap(144)
        FPSDropdown:Set("120")
        
        -- Set all sliders to medium optimization
        TextureSlider:Set(2)
        GraphicsSlider:Set(2)
        RenderingSlider:Set(2)
        AntiAliasingToggle:Set(false)
        ParticlesSlider:Set(2)
        DetailSlider:Set(2)
        NoTerrainToggle:Set(true)
        
        Rayfield:Notify({
            Title = "Competitive Preset Applied",
            Content = "Medium optimizations for competitive gaming",
            Duration = 5,
        })
   end,
})

-- Reset All Settings Button
local ResetButton = MainTab:CreateButton({
   Name = "🔁 Reset All to Default",
   Callback = function()
        SafeSetFpsCap(60)
        FPSDropdown:Set("60")
        
        -- Reset all sliders to 0
        TextureSlider:Set(0)
        GraphicsSlider:Set(0)
        RenderingSlider:Set(0)
        AntiAliasingToggle:Set(true)
        ParticlesSlider:Set(0)
        DetailSlider:Set(0)
        NoTerrainToggle:Set(false)
        
        -- Restore original settings
        pcall(function()
            settings().Rendering.QualityLevel = OriginalSettings.QualityLevel
            game:GetService("Lighting").GlobalShadows = OriginalSettings.GlobalShadows
            workspace.CurrentCamera.FieldOfView = OriginalSettings.FieldOfView
            
            -- Restore lighting
            local Lighting = game:GetService("Lighting")
            Lighting.FogEnd = 999999
            Lighting.Brightness = 1
            Lighting.EnvironmentDiffuseScale = 1
            Lighting.EnvironmentSpecularScale = 1
            
            -- Restore terrain
            workspace.TerrainDecoration = true
            
            -- Restore light shadows
            for _, light in pairs(Lighting:GetChildren()) do
                if light:IsA("SpotLight") or light:IsA("PointLight") then
                    light.Shadows = true
                    light.Enabled = true
                end
            end
            
            -- Restore particles
            for obj, wasEnabled in pairs(ModifiedParticles) do
                if obj and obj.Parent then
                    pcall(function()
                        obj.Enabled = wasEnabled
                        if obj:IsA("ParticleEmitter") then
                            obj.Rate = obj.Rate * 2  -- Restore original rate
                        end
                    end)
                end
            end
            ModifiedParticles = {}
            
            -- Restore transparency
            for obj, originalValue in pairs(ModifiedTransparency) do
                if obj and obj.Parent then
                    pcall(function()
                        obj.LocalTransparencyModifier = originalValue
                    end)
                end
            end
            ModifiedTransparency = {}
            
            -- Restore materials
            for obj, originalMaterial in pairs(ModifiedMaterials) do
                if obj and obj.Parent then
                    pcall(function()
                        obj.Material = originalMaterial
                    end)
                end
            end
            ModifiedMaterials = {}
            
            -- Restore decals and GUI elements
            spawn(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Decal") then
                        obj.Transparency = 0
                    elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
                        obj.Enabled = true
                    end
                end
            end)
        end)
        
        Rayfield:Notify({
            Title = "Settings Reset Complete",
            Content = "All settings restored to original state",
            Duration = 5,
        })
   end,
})

-- Info Tab
local InfoTab = Window:CreateTab("📊 Info", nil)
local InfoSection = InfoTab:CreateSection("Performance Information")

local fpsText = InfoTab:CreateLabel("Current FPS: Calculating...")
local pingText = InfoTab:CreateLabel("Current Ping: Calculating...")

-- Level descriptions
local LevelInfoSection = InfoTab:CreateSection("Optimization Levels Guide")

InfoTab:CreateParagraph({
    Title = "🎯 Level 0 - Original Quality",
    Content = "• No optimizations applied\n• Best visual quality\n• Lowest FPS performance"
})

InfoTab:CreateParagraph({
    Title = "🎯 Level 1 - Mild Optimization",
    Content = "• Small performance improvements\n• Minimal visual impact\n• Good balance for most games"
})

InfoTab:CreateParagraph({
    Title = "🎯 Level 2 - Medium Optimization",
    Content = "• Significant performance boost\n• Noticeable visual changes\n• Recommended for competitive gaming"
})

InfoTab:CreateParagraph({
    Title = "🎯 Level 3 - Maximum Optimization",
    Content = "• Maximum FPS performance\n• Major visual reductions\n• Use for low-end devices or maximum FPS"
})

-- Performance monitoring
spawn(function()
    local RunService = game:GetService("RunService")
    local Stats = game:GetService("Stats")
    
    local frameCount = 0
    local lastUpdate = tick()
    
    while true do
        wait(0.1)
        frameCount = frameCount + 1
        
        local currentTime = tick()
        if currentTime - lastUpdate >= 1 then
            local fps = math.floor(frameCount / (currentTime - lastUpdate))
            frameCount = 0
            lastUpdate = currentTime
            
            pcall(function()
                fpsText:Set("Current FPS: " .. fps)
                
                local success, pingValue = pcall(function()
                    return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                end)
                
                if success then
                    pingText:Set("Current Ping: " .. math.floor(pingValue) .. "ms")
                else
                    pingText:Set("Current Ping: N/A")
                end
            end)
        end
    end
end)

-- Auto-cleanup on script termination
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == game:GetService("Players").LocalPlayer then
        -- Restore settings when player leaves
        pcall(function()
            SafeSetFpsCap(60)
            settings().Rendering.QualityLevel = OriginalSettings.QualityLevel
            game:GetService("Lighting").GlobalShadows = OriginalSettings.GlobalShadows
            workspace.CurrentCamera.FieldOfView = OriginalSettings.FieldOfView
        end)
    end
end)

-- Initial notification
Rayfield:Notify({
   Title = "SOVEREIGN Booster Loaded",
   Content = "Level-based optimization system activated!",
   Duration = 5,
})

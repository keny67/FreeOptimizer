--[[
    DeepHat ULTRA Optimizer v5.0
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local UserSettings = UserSettings()
local GameSettings = UserSettings:GetService("UserGameSettings")
local StarterGui = game:GetService("StarterGui")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")

local Camera = Workspace.CurrentCamera

-- ====================== COLOQUE O ID DA IMAGEM AQUI ======================
local IMAGE_ID = "rbxassetid://98843498706263" -- Troque pelo ID correto da menina
-- ========================================================================

local function CreateLoadingScreen()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DeepHat_Loading"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 999999
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    local Background = Instance.new("Frame")
    Background.Name = "Background"
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundTransparency = 1
    Background.Parent = ScreenGui

    local Blur = Instance.new("BlurEffect")
    Blur.Name = "DeepHatBlur"
    Blur.Size = 26
    Blur.Parent = Lighting

    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.Size = UDim2.new(1.6, 0, 1.6, 0)
    Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Glow.AnchorPoint = Vector2.new(0.5, 0.5)
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://5028857082"
    Glow.ImageColor3 = Color3.fromRGB(100, 160, 255)
    Glow.ImageTransparency = 0.6
    Glow.Parent = Background

    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Size = UDim2.new(0, 340, 0, 340)
    Logo.Position = UDim2.new(0.5, 0, 0.41, 0)
    Logo.AnchorPoint = Vector2.new(0.5, 0.5)
    Logo.BackgroundTransparency = 1
    Logo.Image = IMAGE_ID
    Logo.ScaleType = Enum.ScaleType.Fit
    Logo.Parent = Background

    local LoadingText = Instance.new("TextLabel")
    LoadingText.Name = "LoadingText"
    LoadingText.Size = UDim2.new(0, 400, 0, 50)
    LoadingText.Position = UDim2.new(0.5, 0, 0.73, 0)
    LoadingText.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadingText.BackgroundTransparency = 1
    LoadingText.Font = Enum.Font.GothamBold
    LoadingText.TextSize = 38
    LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadingText.TextStrokeTransparency = 0.5
    LoadingText.Text = "loading..."
    LoadingText.Parent = Background

    return ScreenGui, Blur, Background, Logo, LoadingText
end

local function CreateFPSCounter()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DeepHat_FPS"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    local Label = Instance.new("TextLabel")
    Label.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Label.BackgroundTransparency = 0.25
    Label.Position = UDim2.new(0, 12, 0, 12)
    Label.Size = UDim2.new(0, 105, 0, 32)
    Label.Font = Enum.Font.GothamBold
    Label.TextColor3 = Color3.fromRGB(100, 255, 140)
    Label.TextSize = 16
    Label.Text = "FPS: --"
    Label.Parent = ScreenGui

    Instance.new("UICorner", Label).CornerRadius = UDim.new(0, 6)

    return Label
end

local function ApplyOptimizations()
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level03
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
        settings().Rendering.EditQualityLevel = Enum.QualityLevel.Level03
    end)

    pcall(function()
        GameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    end)

    Lighting.GlobalShadows = false
    Lighting.ShadowSoftness = 0
    Lighting.EnvironmentDiffuseScale = 0.35
    Lighting.EnvironmentSpecularScale = 0.2
    Lighting.Brightness = 1.55
    Lighting.Ambient = Color3.fromRGB(130, 130, 145)
    Lighting.OutdoorAmbient = Color3.fromRGB(130, 130, 145)
    Lighting.ClockTime = 14.5
    Lighting.GeographicLatitude = 0
    Lighting.FogEnd = 100000

    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("BloomEffect") or v:IsA("SunRaysEffect") or 
           v:IsA("DepthOfFieldEffect") or v:IsA("Atmosphere") or
           v:IsA("ColorCorrectionEffect") or v:IsA("BlurEffect") then
            if v.Name ~= "DeepHatBlur" then
                v:Destroy()
            end
        end
    end

    local sky = Lighting:FindFirstChildOfClass("Sky")
    if sky then
        sky.StarCount = 0
        sky.SunAngularSize = 15
        sky.MoonAngularSize = 15
        sky.CelestialBodiesShown = false
    end

    if Terrain then
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 1
        pcall(function()
            Terrain.Decoration = false
        end)
    end
end

local function CleanTexturesAndParticles()
    local count = 0

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
            count += 1
        elseif obj:IsA("BasePart") then
            obj.CastShadow = false
            obj.Reflectance = 0
            if obj.Material ~= Enum.Material.Neon and 
               obj.Material ~= Enum.Material.ForceField and 
               obj.Material ~= Enum.Material.Glass then
                obj.Material = Enum.Material.SmoothPlastic
            end
            if obj.Size.Magnitude < 1.8 then
                obj.CanTouch = false
                obj.CanQuery = false
            end
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
            obj.Enabled = false
            count += 1
        elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
            count += 1
        end
    end

    return count
end

local function StartContinuousOptimizer()
    task.spawn(function()
        while true do
            task.wait(2.5)
            Lighting.GlobalShadows = false
            Lighting.Brightness = 1.55
            Lighting.Ambient = Color3.fromRGB(130, 130, 145)
            Lighting.OutdoorAmbient = Color3.fromRGB(130, 130, 145)

            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.CastShadow = false
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                end
            end
        end
    end)
end

-- ====================== EXECUÇÃO ======================
local loadingGui, blurEffect, background, logo, loadingText = CreateLoadingScreen()
local fpsLabel = CreateFPSCounter()

task.spawn(function()
    pcall(function()
        ContentProvider:PreloadAsync({logo})
    end)
end)

task.spawn(function()
    task.wait(0.35)

    ApplyOptimizations()
    local removed = CleanTexturesAndParticles()
    StartContinuousOptimizer()

    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
    end)

    task.spawn(function()
        local frames = 0
        local last = tick()
        RunService.RenderStepped:Connect(function()
            frames += 1
            if tick() - last >= 0.5 then
                local fps = math.floor(frames / (tick() - last))
                fpsLabel.Text = "FPS: " .. fps

                if fps >= 55 then
                    fpsLabel.TextColor3 = Color3.fromRGB(80, 255, 140)
                elseif fps >= 40 then
                    fpsLabel.TextColor3 = Color3.fromRGB(255, 220, 80)
                else
                    fpsLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
                end

                frames = 0
                last = tick()
            end
        end)
    end)

    task.wait(1.9)

    local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    TweenService:Create(logo, tweenInfo, {ImageTransparency = 1}):Play()
    TweenService:Create(loadingText, tweenInfo, {TextTransparency = 1}):Play()
    TweenService:Create(background.Glow, tweenInfo, {ImageTransparency = 1}):Play()

    task.wait(0.75)

    if blurEffect then blurEffect:Destroy() end
    loadingGui:Destroy()

    print("[DeepHat Ultra] Otimização concluída | Itens otimizados: " .. removed)
end)

--[[
  Serenity Hub — Any-Executor Edition
  Target: Roblox (universal)
  Executor: any (Synapse, Script-Ware, Wave, Solara, Delta, Krnl, Fluxus, Hydrogen, AWP, generic)
  UI: WindUI
  Layout: 8 tabs, 50+ features, no empty tabs
  Discord: discord.gg/8XbXfAQkMm
]]

--=============================================================
-- 0. UNIVERSAL COMPAT LAYER
--=============================================================
local Compat = {}

do
    local ok, name = pcall(function()
        if identifyexecutor then return identifyexecutor() end
        if getexecutorname then return getexecutorname() end
        if KRNL_LOADED then return "Krnl" end
        if Fluxus then return "Fluxus" end
        if syn then return "Synapse" end
        return "generic"
    end)
    Compat.executor = ok and name or "generic"
end

function Compat.http_get(url)
    local fns = { rawget(getfenv(), "httpget"), rawget(getfenv(), "HttpGet"),
                  rawget(getfenv(), "game_httpget") }
    for _, fn in ipairs(fns) do
        if type(fn) == "function" then
            local ok, res = pcall(fn, url)
            if ok and res then return res end
        end
    end
    if game.HttpGet then
        local ok, res = pcall(function() return game:HttpGet(url) end)
        if ok then return res end
    end
    if syn and syn.request then
        local ok, res = pcall(syn.request, { Url = url, Method = "GET" })
        if ok and res and res.Body then return res.Body end
    end
    if http and http.request then
        local ok, res = pcall(http.request, { Url = url, Method = "GET" })
        if ok and res and res.Body then return res.Body end
    end
    if request then
        local ok, res = pcall(request, { Url = url, Method = "GET" })
        if ok and res and res.Body then return res.Body end
    end
    error("[Compat] No HTTP method available")
end

function Compat.set_clipboard(text)
    local candidates = {
        rawget(getfenv(), "setclipboard"),
        rawget(getfenv(), "toclipboard"),
        rawget(getfenv(), "Clipboard"),
    }
    for _, fn in ipairs(candidates) do
        if type(fn) == "function" then pcall(fn, text); return true end
    end
    if syn and syn.clipboard_set then pcall(syn.clipboard_set, text); return true end
    if Clipboard and Clipboard.set then pcall(Clipboard.set, text); return true end
    return false
end

function Compat.get_hui()
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    if syn and syn.protect_gui then return game:GetService("CoreGui") end
    if get_hidden_gui then
        local ok, h = pcall(get_hidden_gui)
        if ok and h then return h end
    end
    return game:GetService("CoreGui")
end

function Compat.protect_gui(gui)
    if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end
    if protect_gui and type(protect_gui) == "function" then pcall(protect_gui, gui) end
end

function Compat.set_fpscap(n)
    if setfpscap then pcall(setfpscap, n); return true end
    return false
end

function Compat.get_custom_asset(path)
    if getcustomasset then
        local ok, a = pcall(getcustomasset, path)
        if ok then return a end
    end
    if getsynasset then
        local ok, a = pcall(getsynasset, path)
        if ok then return a end
    end
    return nil
end

--=============================================================
-- 1. LOAD WINDU (multi-source fallback)
--=============================================================
local HUI = Compat.get_hui()

local WindUI
do
    local sources = {
        "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua",
        "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua",
    }
    local src
    for _, url in ipairs(sources) do
        local ok, body = pcall(Compat.http_get, url)
        if ok and body and #body > 100 then src = body; break end
    end
    if not src and isfile and isfile("WindUI.lua") then
        src = readfile("WindUI.lua")
    end
    if not src then
        return warn("[Serenity Hub] Could not fetch WindUI from any source.")
    end
    local loader = loadstring or load
    local ok, result = pcall(loader(src))
    if not ok or type(result) ~= "table" then
        return warn("[Serenity Hub] WindUI load failed: " .. tostring(result))
    end
    WindUI = result
end

--=============================================================
-- 2. SERVICES / STATE
--=============================================================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting         = game:GetService("Lighting")
local Workspace        = game:GetService("Workspace")
local TweenService     = game:GetService("TweenService")
local StarterGui       = game:GetService("StarterGui")
local HttpService      = game:GetService("HttpService")
local VirtualUser      = game:GetService("VirtualUser")
local TeleportService  = game:GetService("TeleportService")

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local State = {
    speed = 16, jump = 50, gravity = Workspace.Gravity,
    fov = 70, fly = false, flySpeed = 50, noclip = false,
    infiniteJump = false, antiAfk = false, fullbright = false,
    noFog = false, esp = false, chams = false, tracers = false,
    freecam = false, godmode = false, antiFling = false, antiVoid = false,
    hitboxSize = 1, timeOfDay = 14, saved = {},
    espObjects = {}, connections = {},
}

--=============================================================
-- 3. HELPERS
--=============================================================
local function notify(title, text, dur)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title, Text = text, Duration = dur or 3,
        })
    end)
end

local function getChar() return LP.Character or LP.CharacterAdded:Wait() end
local function getHRP() local c = LP.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c = LP.Character; return c and c:FindFirstChildOfClass("Humanoid") end

--=============================================================
-- 4. WINDOW
--=============================================================
local Window = WindUI:CreateWindow({
    Title = "Serenity Hub",
    Icon = "rbxassetid://10723407380",
    Author = "Baggute · discord.gg/8XbXfAQkMm",
    Folder = "SerenityHub",
    Size = UDim2.fromOffset(600, 420),
    Transparent = true,
    Theme = "Dark",
    User = { Enabled = true, Anonymous = true },
})

--=============================================================
-- 5. MOVEMENT
--=============================================================
local Movement = Window:Tab({ Title = "Movement", Icon = "move" })

Movement:Slider({ Title = "Walk Speed", Value = { Min = 16, Max = 500, Default = 16 },
    Callback = function(v) State.speed = v; local h = getHum(); if h then h.WalkSpeed = v end end })
Movement:Slider({ Title = "Jump Power", Value = { Min = 50, Max = 500, Default = 50 },
    Callback = function(v) State.jump = v; local h = getHum(); if h then h.JumpPower = v; h.UseJumpPower = true end end })
Movement:Slider({ Title = "Gravity", Value = { Min = 0, Max = 300, Default = 196 },
    Callback = function(v) State.gravity = v; Workspace.Gravity = v end })
Movement:Toggle({ Title = "Infinite Jump", Callback = function(on) State.infiniteJump = on end })
Movement:Toggle({ Title = "Noclip", Callback = function(on) State.noclip = on end })
Movement:Toggle({ Title = "Fly (WASD + Space/Ctrl)", Callback = function(on)
    State.fly = on
    if not on then
        local hrp = getHRP()
        if hrp and hrp:FindFirstChild("BreadFly") then hrp.BreadFly:Destroy() end
        return
    end
    local char = getChar()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local bv = Instance.new("BodyVelocity")
    bv.Name = "BreadFly"
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp
end })
Movement:Button({ Title = "Reset Speed", Callback = function()
    State.speed = 16; local h = getHum(); if h then h.WalkSpeed = 16 end end })

--=============================================================
-- 6. CAMERA
--=============================================================
local CameraTab = Window:Tab({ Title = "Camera", Icon = "camera" })

CameraTab:Slider({ Title = "Field of View", Value = { Min = 30, Max = 160, Default = 70 },
    Callback = function(v) State.fov = v; if Camera then Camera.FieldOfView = v end end })
CameraTab:Slider({ Title = "Max Zoom Distance", Value = { Min = 0, Max = 2000, Default = 128 },
    Callback = function(v) LP.CameraMaxZoomDistance = v end })
CameraTab:Slider({ Title = "Min Zoom Distance", Value = { Min = 0, Max = 128, Default = 0 },
    Callback = function(v) LP.CameraMinZoomDistance = v end })
CameraTab:Toggle({ Title = "Freecam (hook)", Callback = function(on) State.freecam = on end })
CameraTab:Button({ Title = "Lock Camera to Cursor", Callback = function()
    if Camera then Camera.CameraType = Enum.CameraType.Scriptable end end })
CameraTab:Button({ Title = "Restore Default Camera", Callback = function()
    if Camera then Camera.CameraType = Enum.CameraType.Custom end end })

--=============================================================
-- 7. CHARACTER
--=============================================================
local CharTab = Window:Tab({ Title = "Character", Icon = "user" })

CharTab:Toggle({ Title = "Godmode (local)", Callback = function(on)
    State.godmode = on
    local h = getHum()
    if h then
        if on then
            State.connections.god = h.HealthChanged:Connect(function()
                if State.godmode then h.Health = h.MaxHealth end
            end)
        elseif State.connections.god then
            State.connections.god:Disconnect()
        end
    end
end })
CharTab:Toggle({ Title = "Anti-Fling", Callback = function(on)
    State.antiFling = on
    if on then
        local hrp = getHRP()
        if hrp then
            State.connections.fling = hrp.ChildAdded:Connect(function(c)
                if (c:IsA("BodyAngularVelocity") or c:IsA("BodyVelocity")) and not c.Name:match("Bread") then
                    c:Destroy()
                end
            end)
        end
    elseif State.connections.fling then
        State.connections.fling:Disconnect()
    end
end })
CharTab:Toggle({ Title = "Anti-Void", Callback = function(on)
    State.antiVoid = on
    if on then
        State.connections.void = RunService.Heartbeat:Connect(function()
            local hrp = getHRP()
            if hrp and hrp.Position.Y < -100 then hrp.CFrame = CFrame.new(0, 50, 0) end
        end)
    elseif State.connections.void then
        State.connections.void:Disconnect()
    end
end })
CharTab:Slider({ Title = "Hitbox Size", Value = { Min = 1, Max = 20, Default = 1 },
    Callback = function(v)
        State.hitboxSize = v
        local char = LP.Character
        if not char then return end
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                p.Size = Vector3.new(v, v, v)
            end
        end
    end })
CharTab:Button({ Title = "Reset Character", Callback = function()
    local h = getHum(); if h then h.Health = 0 end end })

--=============================================================
-- 8. TELEPORT
--=============================================================
local TpTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })

local tpTarget = ""
TpTab:Input({ Title = "Player Name", Placeholder = "username",
    Callback = function(v) tpTarget = v end })
TpTab:Button({ Title = "Teleport to Player", Callback = function()
    local t = Players:FindFirstChild(tpTarget)
    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = getHRP()
        if hrp then hrp.CFrame = t.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0) end
    else notify("Teleport", "Player not found.") end
end })
TpTab:Button({ Title = "Teleport to Cursor", Callback = function()
    local mouse = LP:GetMouse()
    local hrp = getHRP()
    if hrp and mouse.Hit then hrp.CFrame = mouse.Hit + Vector3.new(0, 3, 0) end
end })
TpTab:Button({ Title = "Save Current Position", Callback = function()
    local hrp = getHRP()
    if hrp then
        table.insert(State.saved, { name = "pos_" .. (#State.saved + 1), cf = hrp.CFrame })
        notify("Saved", "Position stored.")
    end
end })
TpTab:Button({ Title = "Teleport to Last Saved", Callback = function()
    local s = State.saved[#State.saved]
    local hrp = getHRP()
    if s and hrp then hrp.CFrame = s.cf end
end })
TpTab:Button({ Title = "Clear Saved", Callback = function() State.saved = {} end })

--=============================================================
-- 9. VISUALS
--=============================================================
local VisTab = Window:Tab({ Title = "Visuals", Icon = "eye" })

VisTab:Toggle({ Title = "Player ESP (name + distance)", Callback = function(on)
    State.esp = on
    if not on then
        for _, o in ipairs(State.espObjects) do if o and o.Parent then o:Destroy() end end
        State.espObjects = {}
    end
end })
VisTab:Toggle({ Title = "Chams (highlight)", Callback = function(on)
    State.chams = on
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local h = p.Character:FindFirstChildOfClass("Highlight")
            if on and not h then
                h = Instance.new("Highlight")
                h.FillColor = Color3.fromRGB(0, 200, 255)
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
                h.Parent = p.Character
            elseif not on and h then h:Destroy() end
        end
    end
end })
VisTab:Toggle({ Title = "Tracers (flag)", Callback = function(on) State.tracers = on end })
VisTab:Toggle({ Title = "Fullbright", Callback = function(on)
    State.fullbright = on
    Lighting.Brightness = on and 5 or 2
    Lighting.Ambient = on and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(70, 70, 70)
    Lighting.OutdoorAmbient = on and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(128, 128, 128)
end })
VisTab:Toggle({ Title = "No Fog", Callback = function(on)
    State.noFog = on
    Lighting.FogEnd = on and 1e6 or 1000
    Lighting.FogStart = on and 1e5 or 0
end })
VisTab:Button({ Title = "X-Ray (0.7 transparency)", Callback = function()
    for _, p in ipairs(Workspace:GetDescendants()) do
        if p:IsA("BasePart") then p.LocalTransparencyModifier = 0.7 end
    end
end })
VisTab:Button({ Title = "Restore All Transparency", Callback = function()
    for _, p in ipairs(Workspace:GetDescendants()) do
        if p:IsA("BasePart") then p.LocalTransparencyModifier = 0 end
    end
end })

--=============================================================
-- 10. WORLD
--=============================================================
local WorldTab = Window:Tab({ Title = "World", Icon = "globe" })

WorldTab:Slider({ Title = "Time of Day", Value = { Min = 0, Max = 24, Default = 14 },
    Callback = function(v) State.timeOfDay = v; Lighting.ClockTime = v end })
WorldTab:Slider({ Title = "Global Gravity", Value = { Min = 0, Max = 500, Default = 196 },
    Callback = function(v) Workspace.Gravity = v end })
WorldTab:Button({ Title = "Delete Part Under Cursor", Callback = function()
    local mouse = LP:GetMouse()
    local t = mouse.Target
    if t then t:Destroy() end
end })
WorldTab:Button({ Title = "Remove All Textures", Callback = function()
    for _, d in ipairs(Workspace:GetDescendants()) do
        if d:IsA("Decal") or d:IsA("Texture") then d.Transparency = 1 end
    end
end })
WorldTab:Toggle({ Title = "Disable Shadows", Callback = function(on)
    Lighting.GlobalShadows = not on end })

--=============================================================
-- 11. SERVER
--=============================================================
local SrvTab = Window:Tab({ Title = "Server", Icon = "server" })

SrvTab:Button({ Title = "Copy JobId", Callback = function()
    if Compat.set_clipboard(game.JobId) then notify("Server", "JobId copied.") end
end })
SrvTab:Button({ Title = "Rejoin Server", Callback = function()
    TeleportService:Teleport(game.PlaceId, LP)
end })
SrvTab:Button({ Title = "Server Hop (random)", Callback = function()
    local ok, servers = pcall(function()
        return HttpService:JSONDecode(Compat.http_get(
            "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"
        ))
    end)
    if ok and servers and servers.data then
        for _, s in ipairs(servers.data) do
            if s.id ~= game.JobId and s.playing < s.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LP)
                return
            end
        end
    end
    notify("Server", "No server found.")
end })
SrvTab:Button({ Title = "Player Count", Callback = function()
    notify("Server", #Players:GetPlayers() .. " players") end })
SrvTab:Input({ Title = "Join by JobId", Placeholder = "job id",
    Callback = function(v) TeleportService:TeleportToPlaceInstance(game.PlaceId, v, LP) end })
SrvTab:Toggle({ Title = "Anti-AFK", Callback = function(on)
    State.antiAfk = on
    if on then
        State.connections.afk = LP.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    elseif State.connections.afk then
        State.connections.afk:Disconnect()
    end
end })

--=============================================================
-- 12. MISC
--=============================================================
local MiscTab = Window:Tab({ Title = "Misc", Icon = "settings" })

MiscTab:Toggle({ Title = "FPS Unlocker Hint", Callback = function(on)
    if on then notify("FPS", "Click 'Unlock FPS' button to apply.") end
end })
MiscTab:Button({ Title = "Unlock FPS (999)", Callback = function()
    if Compat.set_fpscap(999) then notify("FPS", "Cap set to 999.") else
        notify("FPS", "Executor does not expose setfpscap.") end
end })
MiscTab:Button({ Title = "Respawn", Callback = function() LP:LoadCharacter() end })
MiscTab:Input({ Title = "Chat Message", Placeholder = "type here...",
    Callback = function(v) State.chatMsg = v end })
MiscTab:Toggle({ Title = "Chat Spam (2s)", Callback = function(on)
    if on then
        State.connections.spam = true
        task.spawn(function()
            while State.connections.spam do
                if State.chatMsg then
                    pcall(function()
                        game:GetService("ReplicatedStorage")
                            .DefaultChatSystemChatEvents.SayMessageRequest:FireServer(State.chatMsg, "All")
                    end)
                end
                task.wait(2)
            end
        end)
    else
        State.connections.spam = false
    end
end })
MiscTab:Button({ Title = "Copy Discord Invite", Callback = function()
    if Compat.set_clipboard("https://discord.gg/8XbXfAQkMm") then
        notify("Discord", "Invite copied.")
    end
end })
MiscTab:Button({ Title = "Credits", Callback = function()
    notify("Serenity Hub", "by Baggute · discord.gg/8XbXfAQkMm", 5) end })
MiscTab:Button({ Title = "Show Detected Executor", Callback = function()
    notify("Executor", Compat.executor, 4) end })

--=============================================================
-- 13. LOOPS
--=============================================================
UserInputService.JumpRequest:Connect(function()
    if State.infiniteJump then
        local h = getHum()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.Stepped:Connect(function()
    if State.noclip then
        local c = LP.Character
        if c then
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
    if State.fly then
        local hrp = getHRP()
        local bv = hrp and hrp:FindFirstChild("BreadFly")
        if bv then
            local dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0, 1, 0) end
            bv.Velocity = dir * State.flySpeed
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if not State.esp then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local existing = State.espObjects[p]
                if not existing then
                    local g = Instance.new("BillboardGui")
                    g.Name = "SerenityESP"
                    g.AlwaysOnTop = true
                    g.Size = UDim2.fromOffset(200, 50)
                    g.StudsOffset = Vector3.new(0, 3, 0)
                    g.Adornee = hrp
                    g.Parent = HUI
                    local txt = Instance.new("TextLabel")
                    txt.Size = UDim2.fromScale(1, 1)
                    txt.BackgroundTransparency = 1
                    txt.TextColor3 = Color3.fromRGB(0, 220, 255)
                    txt.TextStrokeTransparency = 0
                    txt.TextScaled = true
                    txt.Font = Enum.Font.GothamBold
                    txt.Parent = g
                    State.espObjects[p] = { gui = g, label = txt }
                else
                    local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                    existing.label.Text = string.format("%s [%d]", p.Name, math.floor(dist))
                end
            end
        end
    end
    for plr, obj in pairs(State.espObjects) do
        if not plr.Parent or not plr.Character then
            if obj.gui then obj.gui:Destroy() end
            State.espObjects[plr] = nil
        end
    end
end)

--=============================================================
-- 14. RESPAWN REBIND
--=============================================================
LP.CharacterAdded:Connect(function(char)
    task.wait(1)
    local h = char:FindFirstChildOfClass("Humanoid")
    if h then
        h.WalkSpeed = State.speed
        h.JumpPower = State.jump
        h.UseJumpPower = true
    end
end)

--=============================================================
-- 15. BOOT NOTICE
--=============================================================
notify("Serenity Hub", "Loaded on " .. Compat.executor .. " · discord.gg/8XbXfAQkMm", 5)

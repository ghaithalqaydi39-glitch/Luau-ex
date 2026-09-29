-- Serenity Hub v7 -- discord build -- ascii only
print("[Serenity] loading...")
local DISCORD="https://discord.gg/8XbXfAQkMm"

local P=game:GetService("Players")
local U=game:GetService("UserInputService")
local R=game:GetService("RunService")
local T=game:GetService("TweenService")
local L=game:GetService("Lighting")
local VU=game:GetService("VirtualUser")
local TS=game:GetService("TeleportService")
local HS=game:GetService("HttpService")
local RS=game:GetService("ReplicatedStorage")
local LP=P.LocalPlayer
local CM=workspace.CurrentCamera
local PG=LP:WaitForChild("PlayerGui",10)
if not PG then warn("[Serenity] no PlayerGui") return end

if getgenv().Serenity and getgenv().Serenity.gui then
    pcall(function() getgenv().Serenity.gui:Destroy() end)
end

local C={
    bg=Color3.fromRGB(11,9,22),
    side=Color3.fromRGB(16,14,30),
    card=Color3.fromRGB(22,20,40),
    row=Color3.fromRGB(28,25,50),
    ac=Color3.fromRGB(150,90,255),
    ac2=Color3.fromRGB(200,130,255),
    ac3=Color3.fromRGB(90,210,255),
    tx=Color3.fromRGB(240,238,252),
    sb=Color3.fromRGB(150,145,185),
    dim=Color3.fromRGB(80,74,110),
    ok=Color3.fromRGB(110,230,150),
    dg=Color3.fromRGB(255,90,110),
    hot=Color3.fromRGB(255,80,180),
    gold=Color3.fromRGB(255,200,90),
    disc=Color3.fromRGB(88,101,242),
}

local function M(c,p,par)
    local o=Instance.new(c)
    for k,v in pairs(p or {}) do o[k]=v end
    o.Parent=par
    return o
end

local G=M("ScreenGui",{Name="SerenityHub",ResetOnSpawn=false,
IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},PG)

-- ============================================================
-- LOADING SCREEN
-- ============================================================
local LOAD_TOTAL=5
local loadRoot=M("Frame",{Name="LoadScreen",
Size=UDim2.fromScale(1,1),Position=UDim2.fromScale(0,0),
BackgroundColor3=Color3.fromRGB(6,4,14),
BorderSizePixel=0,ZIndex=200,Active=true},G)
M("UIListLayout",{FillDirection=Enum.FillDirection.Vertical,
HorizontalAlignment=Enum.HorizontalAlignment.Center,
VerticalAlignment=Enum.VerticalAlignment.Center,
Padding=UDim.new(0,8)},loadRoot)

local glow=M("Frame",{Size=UDim2.fromOffset(320,320),
BackgroundColor3=C.ac,BorderSizePixel=0,
BackgroundTransparency=0.85,ZIndex=201,
Position=UDim2.fromScale(0.5,0.35),
AnchorPoint=Vector2.new(0.5,0.5)},loadRoot)
M("UICorner",{CornerRadius=UDim.new(1,0)},glow)
task.spawn(function()
    while glow.Parent do
        T:Create(glow,TweenInfo.new(1.6,
        Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
        {Size=UDim2.fromOffset(380,380),
        BackgroundTransparency=0.92}):Play()
        task.wait(1.6)
        T:Create(glow,TweenInfo.new(1.6,
        Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
        {Size=UDim2.fromOffset(320,320),
        BackgroundTransparency=0.85}):Play()
        task.wait(1.6)
    end
end)

local loadLogo=M("Frame",{Size=UDim2.fromOffset(96,96),
BackgroundColor3=C.ac,BorderSizePixel=0,ZIndex=203,
Position=UDim2.fromScale(0.5,0.35),
AnchorPoint=Vector2.new(0.5,0.5)},loadRoot)
M("UICorner",{CornerRadius=UDim.new(0,26)},loadLogo)
local loadLogoGrad=M("UIGradient",{
Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,C.ac),
    ColorSequenceKeypoint.new(0.5,C.hot),
    ColorSequenceKeypoint.new(1,C.disc),
}),Rotation=45},loadLogo)
M("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
Font=Enum.Font.GothamBlack,TextSize=52,
TextColor3=Color3.new(1,1,1),Text="S",ZIndex=204},loadLogo)
task.spawn(function()
    local t=0
    while loadLogo.Parent do
        t=(t+0.02)%1
        loadLogoGrad.Rotation=45+t*360
        task.wait(0.03)
    end
end)

local ring=M("Frame",{Size=UDim2.fromOffset(96,96),
BackgroundTransparency=1,BorderSizePixel=0,
Position=UDim2.fromScale(0.5,0.35),
AnchorPoint=Vector2.new(0.5,0.5),ZIndex=202},loadRoot)
M("UICorner",{CornerRadius=UDim.new(0,26)},ring)
local ringStroke=M("UIStroke",{Color=C.ac,Thickness=2,
Transparency=0.2},ring)
task.spawn(function()
    while ring.Parent do
        ring.Size=UDim2.fromOffset(96,96)
        ringStroke.Transparency=0.2
        T:Create(ring,TweenInfo.new(1.4,
        Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
        {Size=UDim2.fromOffset(180,180)}):Play()
        T:Create(ringStroke,TweenInfo.new(1.4,
        Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
        {Transparency=1}):Play()
        task.wait(1.4)
    end
end)

local subtitle=M("TextLabel",{Size=UDim2.new(1,0,0,20),
Position=UDim2.fromScale(0,0.50),
BackgroundTransparency=1,Font=Enum.Font.Gotham,
TextSize=12,TextColor3=C.sb,
Text="serenity developments  |  v7.0",
TextTransparency=1,ZIndex=205},loadRoot)
task.spawn(function()
    task.wait(0.5)
    T:Create(subtitle,TweenInfo.new(0.9,
    Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
    {TextTransparency=0}):Play()
end)

local discTag=M("TextLabel",{Size=UDim2.new(1,0,0,18),
Position=UDim2.fromScale(0,0.56),
BackgroundTransparency=1,Font=Enum.Font.GothamBold,
TextSize=12,TextColor3=C.disc,
Text="discord.gg/8XbXfAQkMm",
TextTransparency=1,ZIndex=205},loadRoot)
task.spawn(function()
    task.wait(0.8)
    T:Create(discTag,TweenInfo.new(0.9,
    Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
    {TextTransparency=0}):Play()
end)

local barWrap=M("Frame",{Size=UDim2.fromOffset(380,6),
Position=UDim2.fromScale(0,0.68),
BackgroundColor3=Color3.fromRGB(30,26,52),
BorderSizePixel=0,ZIndex=205},loadRoot)
M("UICorner",{CornerRadius=UDim.new(1,0)},barWrap)
local barFill=M("Frame",{Size=UDim2.new(0,0,1,0),
BackgroundColor3=C.ac,BorderSizePixel=0,ZIndex=206},barWrap)
M("UICorner",{CornerRadius=UDim.new(1,0)},barFill)
M("UIGradient",{Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,C.ac),
    ColorSequenceKeypoint.new(1,C.disc),
}),Rotation=0},barFill)

local pct=M("TextLabel",{Size=UDim2.new(1,0,0,16),
Position=UDim2.fromScale(0,0.73),
BackgroundTransparency=1,Font=Enum.Font.Code,TextSize=12,
TextColor3=C.ac2,Text="0%",ZIndex=205},loadRoot)
local statusLbl=M("TextLabel",{Size=UDim2.new(1,0,0,16),
Position=UDim2.fromScale(0,0.765),
BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=11,
TextColor3=C.sb,Text="initializing",ZIndex=205},loadRoot)

task.spawn(function()
    local stages={
        {p=8,s="initializing"},
        {p=18,s="loading modules"},
        {p=30,s="probing capabilities"},
        {p=44,s="hooking metatable"},
        {p=56,s="registering esp"},
        {p=68,s="wiring combat"},
        {p=80,s="building interface"},
        {p=92,s="finalizing"},
        {p=100,s="ready"},
    }
    local start=tick()
    local idx=1
    while tick()-start<LOAD_TOTAL do
        local progress=math.min((tick()-start)/LOAD_TOTAL,1)
        barFill.Size=UDim2.new(progress,0,1,0)
        pct.Text=math.floor(progress*100).."%"
        if idx<=#stages and progress*100>=stages[idx].p then
            statusLbl.Text=stages[idx].s
            idx=idx+1
        end
        task.wait(0.03)
    end
    task.wait(0.4)
    for _,c in ipairs(loadRoot:GetDescendants()) do
        if c:IsA("TextLabel") then
            T:Create(c,TweenInfo.new(0.6),
            {TextTransparency=1}):Play()
        end
        if c:IsA("Frame") and c~=loadRoot then
            T:Create(c,TweenInfo.new(0.6),
            {BackgroundTransparency=1}):Play()
        end
    end
    T:Create(loadRoot,TweenInfo.new(0.7),
    {BackgroundTransparency=1}):Play()
    task.wait(0.8)
    loadRoot:Destroy()
end)

-- ============================================================
-- NOTIFICATIONS
-- ============================================================
local NH=M("Frame",{Size=UDim2.new(0,260,1,0),
Position=UDim2.new(1,-270,0,0),BackgroundTransparency=1},G)
M("UIListLayout",{Padding=UDim.new(0,6),
SortOrder=Enum.SortOrder.LayoutOrder,
VerticalAlignment=Enum.VerticalAlignment.Top},NH)
M("UIPadding",{PaddingTop=UDim.new(0,60),
PaddingRight=UDim.new(0,10)},NH)

local function notify(t,m,c)
    c=c or C.ac
    local n=M("Frame",{Size=UDim2.new(1,0,0,54),
    BackgroundColor3=C.card,BorderSizePixel=0,
    BackgroundTransparency=1,ZIndex=150},NH)
    M("UICorner",{CornerRadius=UDim.new(0,10)},n)
    local st=M("UIStroke",{Color=c,Thickness=1.4,
    Transparency=0.3},n)
    M("Frame",{Size=UDim2.new(0,3,1,0),BackgroundColor3=c,
    BorderSizePixel=0},n)
    M("TextLabel",{Size=UDim2.new(1,-20,0,18),
    Position=UDim2.new(0,14,0,10),BackgroundTransparency=1,
    Font=Enum.Font.GothamBold,TextSize=12,TextColor3=c,
    TextXAlignment=Enum.TextXAlignment.Left,Text=t},n)
    M("TextLabel",{Size=UDim2.new(1,-20,0,16),
    Position=UDim2.new(0,14,0,28),BackgroundTransparency=1,
    Font=Enum.Font.Gotham,TextSize=10,TextColor3=C.sb,
    TextXAlignment=Enum.TextXAlignment.Left,Text=m},n)
    T:Create(n,TweenInfo.new(0.25),
    {BackgroundTransparency=0}):Play()
    T:Create(st,TweenInfo.new(0.25),{Transparency=0.7}):Play()
    task.spawn(function()
        task.wait(3)
        T:Create(n,TweenInfo.new(0.4),
        {BackgroundTransparency=1}):Play()
        task.wait(0.4)
        n:Destroy()
    end)
end

-- ============================================================
-- WINDOW
-- ============================================================
local MN=M("Frame",{Size=UDim2.fromOffset(660,460),
Position=UDim2.new(0.5,-330,0.5,-230),
BackgroundColor3=C.bg,BorderSizePixel=0,
Active=true,Draggable=true},G)
M("UICorner",{CornerRadius=UDim.new(0,16)},MN)
local outerStroke=M("UIStroke",{Color=C.ac,Thickness=2,
Transparency=0.4},MN)
task.spawn(function()
    local hue=0
    while outerStroke.Parent do
        hue=(hue+0.004)%1
        outerStroke.Color=Color3.fromHSV(hue,0.7,1)
        task.wait(0.05)
    end
end)

local stripeHolder=M("Frame",{Size=UDim2.new(1,-32,0,2),
Position=UDim2.new(0,16,0,2),BackgroundColor3=C.ac,
BorderSizePixel=0},MN)
M("UICorner",{CornerRadius=UDim.new(1,0)},stripeHolder)
local stripeGrad=M("UIGradient",{
Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,C.ac),
    ColorSequenceKeypoint.new(0.5,C.hot),
    ColorSequenceKeypoint.new(1,C.disc),
}),Rotation=0},stripeHolder)
task.spawn(function()
    local t=0
    while stripeGrad.Parent do
        t=(t+0.015)%1
        stripeGrad.Offset=Vector2.new(math.sin(t*math.pi*2)*0.3,0)
        task.wait(0.03)
    end
end)

-- header
local HD=M("Frame",{Size=UDim2.new(1,0,0,52),
BackgroundColor3=C.bg,BackgroundTransparency=1,BorderSizePixel=0},MN)

local LG=M("Frame",{Size=UDim2.fromOffset(32,32),
Position=UDim2.new(0,20,0.5,-16),
BackgroundColor3=C.ac,BorderSizePixel=0},HD)
M("UICorner",{CornerRadius=UDim.new(0,10)},LG)
M("UIGradient",{Color=ColorSequence.new(C.ac,C.disc),
Rotation=45},LG)
M("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
Font=Enum.Font.GothamBlack,TextSize=16,
TextColor3=Color3.new(1,1,1),Text="S",ZIndex=2},LG)

local pulse=M("Frame",{Size=UDim2.fromOffset(32,32),
Position=UDim2.new(0,20,0.5,-16),
BackgroundColor3=C.ac,BorderSizePixel=0,
BackgroundTransparency=0.7,ZIndex=0},HD)
M("UICorner",{CornerRadius=UDim.new(0,10)},pulse)
task.spawn(function()
    while pulse.Parent do
        T:Create(pulse,TweenInfo.new(1.2),
        {Size=UDim2.fromOffset(46,46),
        Position=UDim2.new(0,13,0.5,-23),
        BackgroundTransparency=0.85}):Play()
        task.wait(1.2)
        T:Create(pulse,TweenInfo.new(1.2),
        {Size=UDim2.fromOffset(32,32),
        Position=UDim2.new(0,20,0.5,-16),
        BackgroundTransparency=0.7}):Play()
        task.wait(1.2)
    end
end)

M("TextLabel",{Size=UDim2.new(0,260,0,18),
Position=UDim2.new(0,62,0,10),BackgroundTransparency=1,
Font=Enum.Font.GothamBlack,TextSize=15,TextColor3=C.tx,
TextXAlignment=Enum.TextXAlignment.Left,
Text="Serenity Hub"},HD)
M("TextLabel",{Size=UDim2.new(0,360,0,14),
Position=UDim2.new(0,62,0,30),BackgroundTransparency=1,
Font=Enum.Font.Gotham,TextSize=10,TextColor3=C.disc,
TextXAlignment=Enum.TextXAlignment.Left,
Text="discord.gg/8XbXfAQkMm  |  v7.0"},HD)

local SDot=M("Frame",{Size=UDim2.fromOffset(6,6),
Position=UDim2.new(1,-138,0.5,-3),
BackgroundColor3=C.ok,BorderSizePixel=0},HD)
M("UICorner",{CornerRadius=UDim.new(1,0)},SDot)
task.spawn(function()
    while SDot.Parent do
        T:Create(SDot,TweenInfo.new(0.6),
        {BackgroundColor3=C.disc}):Play()
        task.wait(0.6)
        T:Create(SDot,TweenInfo.new(0.6),
        {BackgroundColor3=C.ok}):Play()
        task.wait(0.6)
    end
end)

local MINB=M("TextButton",{Size=UDim2.fromOffset(26,26),
Position=UDim2.new(1,-84,0.5,-13),BackgroundTransparency=1,
BorderSizePixel=0,Font=Enum.Font.GothamBold,TextSize=15,
TextColor3=C.sb,Text="-",AutoButtonColor=false},HD)
MINB.MouseEnter:Connect(function()
    T:Create(MINB,TweenInfo.new(0.1),{TextColor3=C.ac}):Play()
end)
MINB.MouseLeave:Connect(function()
    T:Create(MINB,TweenInfo.new(0.1),{TextColor3=C.sb}):Play()
end)

local HIDEB=M("TextButton",{Size=UDim2.fromOffset(26,26),
Position=UDim2.new(1,-114,0.5,-13),BackgroundTransparency=1,
BorderSizePixel=0,Font=Enum.Font.GothamBold,TextSize=13,
TextColor3=C.sb,Text="v",AutoButtonColor=false},HD)
HIDEB.MouseEnter:Connect(function()
    T:Create(HIDEB,TweenInfo.new(0.1),{TextColor3=C.ac3}):Play()
end)
HIDEB.MouseLeave:Connect(function()
    T:Create(HIDEB,TweenInfo.new(0.1),{TextColor3=C.sb}):Play()
end)

local XB=M("TextButton",{Size=UDim2.fromOffset(26,26),
Position=UDim2.new(1,-50,0.5,-13),BackgroundTransparency=1,
BorderSizePixel=0,Font=Enum.Font.GothamBold,TextSize=17,
TextColor3=C.dg,Text="x",AutoButtonColor=false},HD)
XB.MouseEnter:Connect(function()
    T:Create(XB,TweenInfo.new(0.1),
    {TextColor3=Color3.fromRGB(255,140,160)}):Play()
end)
XB.MouseLeave:Connect(function()
    T:Create(XB,TweenInfo.new(0.1),{TextColor3=C.dg}):Play()
end)

-- sidebar
local SB=M("Frame",{Size=UDim2.new(0,185,1,-104),
Position=UDim2.new(0,16,0,58),
BackgroundColor3=C.side,BorderSizePixel=0},MN)
M("UICorner",{CornerRadius=UDim.new(0,12)},SB)
M("UIStroke",{Color=Color3.fromRGB(45,38,80),
Thickness=1,Transparency=0.4},SB)

local SR=M("Frame",{Size=UDim2.new(1,-16,0,34),
Position=UDim2.new(0,8,0,8),
BackgroundColor3=C.card,BorderSizePixel=0},SB)
M("UICorner",{CornerRadius=UDim.new(0,9)},SR)
M("TextLabel",{Size=UDim2.fromOffset(20,20),
Position=UDim2.new(0,8,0.5,-10),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,TextSize=13,TextColor3=C.dim,
Text="?"},SR)
local SRB=M("TextBox",{Size=UDim2.new(1,-40,1,0),
Position=UDim2.new(0,30,0,0),BackgroundTransparency=1,
Font=Enum.Font.Gotham,TextSize=11,TextColor3=C.tx,
PlaceholderText="Search tabs...",
PlaceholderColor3=C.dim,Text="",ClearTextOnFocus=false,
TextXAlignment=Enum.TextXAlignment.Left},SR)

local SL=M("ScrollingFrame",{Size=UDim2.new(1,-16,1,-140),
Position=UDim2.new(0,8,0,50),
BackgroundTransparency=1,BorderSizePixel=0,
ScrollBarThickness=2,ScrollBarImageColor3=C.dim,
CanvasSize=UDim2.new(0,0,0,0),
AutomaticCanvasSize=Enum.AutomaticSize.Y},SB)
M("UIListLayout",{Padding=UDim.new(0,3),
SortOrder=Enum.SortOrder.LayoutOrder},SL)

-- sidebar footer with user + discord mini button
local FT=M("Frame",{Size=UDim2.new(1,-16,0,48),
Position=UDim2.new(0,8,1,-56),
BackgroundColor3=C.card,BorderSizePixel=0},SB)
M("UICorner",{CornerRadius=UDim.new(0,10)},FT)
local AV=M("Frame",{Size=UDim2.fromOffset(32,32),
Position=UDim2.new(0,8,0.5,-16),
BackgroundColor3=C.ac,BorderSizePixel=0},FT)
M("UICorner",{CornerRadius=UDim.new(1,0)},AV)
M("UIGradient",{Color=ColorSequence.new(C.ac,C.hot),
Rotation=45},AV)
M("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
Font=Enum.Font.GothamBlack,TextSize=13,
TextColor3=Color3.new(1,1,1),
Text=string.sub(LP.Name,1,1):upper()},AV)
M("TextLabel",{Size=UDim2.new(1,-50,0,15),
Position=UDim2.new(0,48,0,8),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,TextSize=11,TextColor3=C.tx,
TextXAlignment=Enum.TextXAlignment.Left,Text=LP.Name},FT)
M("TextLabel",{Size=UDim2.new(1,-50,0,12),
Position=UDim2.new(0,48,0,26),BackgroundTransparency=1,
Font=Enum.Font.Gotham,TextSize=9,TextColor3=C.disc,
TextXAlignment=Enum.TextXAlignment.Left,
Text="discord.gg/8XbXfAQkMm"},FT)

-- bottom discord bar
local DB=M("Frame",{Size=UDim2.new(1,-32,0,34),
Position=UDim2.new(0,16,1,-44),
BackgroundColor3=C.disc,BorderSizePixel=0},MN)
M("UICorner",{CornerRadius=UDim.new(0,10)},DB)
M("UIGradient",{Color=ColorSequence.new(C.disc,C.hot),
Rotation=0},DB)
local DBB=M("TextButton",{Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,BorderSizePixel=0,
Font=Enum.Font.GothamBold,TextSize=13,
TextColor3=Color3.new(1,1,1),
Text="JOIN OUR DISCORD  --  discord.gg/8XbXfAQkMm",
AutoButtonColor=false},DB)
DBB.MouseEnter:Connect(function()
    T:Create(DB,TweenInfo.new(0.15),
    {BackgroundTransparency=0.15}):Play()
end)
DBB.MouseLeave:Connect(function()
    T:Create(DB,TweenInfo.new(0.15),
    {BackgroundTransparency=0}):Play()
end)
DBB.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("https://discord.gg/8XbXfAQkMm")
        notify("Discord","Invite copied to clipboard!",C.disc)
    else
        notify("Discord","discord.gg/8XbXfAQkMm",C.disc)
    end
end)

-- content
local CT=M("Frame",{Size=UDim2.new(1,-214,1,-130),
Position=UDim2.new(0,209,0,64),
BackgroundTransparency=1},MN)

local TABS,PGS={},{}
local function pg(n)
    local p=M("ScrollingFrame",{Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,BorderSizePixel=0,
    ScrollBarThickness=3,ScrollBarImageColor3=C.ac,
    CanvasSize=UDim2.new(0,0,0,0),
    AutomaticCanvasSize=Enum.AutomaticSize.Y,
    Visible=false},CT)
    M("UIListLayout",{Padding=UDim.new(0,10),
    SortOrder=Enum.SortOrder.LayoutOrder},p)
    M("UIPadding",{PaddingRight=UDim.new(0,4),
    PaddingBottom=UDim.new(0,14)},p)
    PGS[n]=p
    return p
end

local function sel(n)
    for k,p in pairs(PGS) do p.Visible=(k==n) end
    for k,b in pairs(TABS) do
        if k==n then
            b.BackgroundTransparency=0
            b.BackgroundColor3=C.card
            if b:FindFirstChild("bar") then b.bar.Visible=true end
            if b:FindFirstChild("lbl") then b.lbl.TextColor3=C.tx end
        else
            b.BackgroundTransparency=1
            if b:FindFirstChild("bar") then b.bar.Visible=false end
            if b:FindFirstChild("lbl") then b.lbl.TextColor3=C.sb end
        end
    end
end

local function tab(n,label)
    local b=M("TextButton",{Size=UDim2.new(1,0,0,34),
    BackgroundTransparency=1,BorderSizePixel=0,
    AutoButtonColor=false,Text=""},SL)
    M("UICorner",{CornerRadius=UDim.new(0,8)},b)
    local bar=M("Frame",{Name="bar",
    Size=UDim2.fromOffset(3,18),
    Position=UDim2.new(0,0,0.5,-9),
    BackgroundColor3=C.ac,BorderSizePixel=0,
    Visible=false},b)
    M("UICorner",{CornerRadius=UDim.new(1,0)},bar)
    M("UIGradient",{Color=ColorSequence.new(C.ac,C.hot),
    Rotation=90},bar)
    M("TextLabel",{Name="lbl",Size=UDim2.new(1,-20,1,0),
    Position=UDim2.new(0,16,0,0),BackgroundTransparency=1,
    Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=C.sb,
    TextXAlignment=Enum.TextXAlignment.Left,Text=label},b)
    b.MouseEnter:Connect(function()
        if not PGS[n].Visible then
            T:Create(b,TweenInfo.new(0.1),
            {BackgroundTransparency=0.6,
            BackgroundColor3=C.row}):Play()
        end
    end)
    b.MouseLeave:Connect(function()
        if not PGS[n].Visible then
            T:Create(b,TweenInfo.new(0.1),
            {BackgroundTransparency=1}):Play()
        end
    end)
    b.MouseButton1Click:Connect(function() sel(n) end)
    TABS[n]=b
    return pg(n)
end

local function section(par,label)
    local c=M("Frame",{Size=UDim2.new(1,0,0,24),
    BackgroundTransparency=1},par)
    local bar=M("Frame",{Size=UDim2.fromOffset(4,14),
    Position=UDim2.new(0,0,0.5,-7),
    BackgroundColor3=C.ac,BorderSizePixel=0},c)
    M("UICorner",{CornerRadius=UDim.new(1,0)},bar)
    M("UIGradient",{Color=ColorSequence.new(C.ac,C.hot),
    Rotation=90},bar)
    M("TextLabel",{Size=UDim2.new(1,-14,1,0),
    Position=UDim2.new(0,12,0,0),BackgroundTransparency=1,
    Font=Enum.Font.GothamBold,TextSize=12,TextColor3=C.ac2,
    TextXAlignment=Enum.TextXAlignment.Left,Text=label},c)
end

local function card(par)
    local c=M("Frame",{Size=UDim2.new(1,0,0,0),
    BackgroundColor3=C.card,BorderSizePixel=0,
    AutomaticSize=Enum.AutomaticSize.Y},par)
    M("UICorner",{CornerRadius=UDim.new(0,12)},c)
    M("UIStroke",{Color=Color3.fromRGB(45,38,80),
    Thickness=1,Transparency=0.4},c)
    M("UIListLayout",{Padding=UDim.new(0,0),
    SortOrder=Enum.SortOrder.LayoutOrder},c)
    M("UIPadding",{PaddingTop=UDim.new(0,4),
    PaddingBottom=UDim.new(0,4)},c)
    return c
end

local function tgl(par,title,desc,default,cb)
    local r=M("Frame",{Size=UDim2.new(1,0,0,54),
    BackgroundColor3=C.row,BorderSizePixel=0},par)
    M("UICorner",{CornerRadius=UDim.new(0,9)},r)
    M("TextLabel",{Size=UDim2.new(1,-110,0,16),
    Position=UDim2.new(0,16,0,11),BackgroundTransparency=1,
    Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=C.tx,
    TextXAlignment=Enum.TextXAlignment.Left,Text=title},r)
    if desc then
        M("TextLabel",{Size=UDim2.new(1,-110,0,14),
        Position=UDim2.new(0,16,0,29),BackgroundTransparency=1,
        Font=Enum.Font.Gotham,TextSize=10,TextColor3=C.sb,
        TextXAlignment=Enum.TextXAlignment.Left,Text=desc},r)
    end
    local sw=M("TextButton",{Size=UDim2.fromOffset(44,20),
    Position=UDim2.new(1,-60,0.5,-10),
    BackgroundColor3=default and C.ac or C.dim,
    BorderSizePixel=0,Text="",AutoButtonColor=false},r)
    M("UICorner",{CornerRadius=UDim.new(1,0)},sw)
    local swGrad=M("UIGradient",{
    Color=ColorSequence.new(C.ac,C.hot),Enabled=default},sw)
    local k=M("Frame",{Size=UDim2.fromOffset(16,16),
    Position=UDim2.new(0,default and 26 or 2,0.5,-8),
    BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0},sw)
    M("UICorner",{CornerRadius=UDim.new(1,0)},k)
    local st={value=default}
    sw.MouseButton1Click:Connect(function()
        st.value=not st.value
        T:Create(sw,TweenInfo.new(0.15),
        {BackgroundColor3=st.value and C.ac or C.dim}):Play()
        swGrad.Enabled=st.value
        T:Create(k,TweenInfo.new(0.15),
        {Position=UDim2.new(0,st.value and 26 or 2,0.5,-8)}):Play()
        if cb then pcall(cb,st.value) end
    end)
    return st
end

local function sld(par,title,desc,mn,mx,d,rd,cb)
    local r=M("Frame",{Size=UDim2.new(1,0,0,58),
    BackgroundColor3=C.row,BorderSizePixel=0},par)
    M("UICorner",{CornerRadius=UDim.new(0,9)},r)
    M("TextLabel",{Size=UDim2.new(1,-160,0,16),
    Position=UDim2.new(0,16,0,11),BackgroundTransparency=1,
    Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=C.tx,
    TextXAlignment=Enum.TextXAlignment.Left,Text=title},r)
    if desc then
        M("TextLabel",{Size=UDim2.new(1,-160,0,14),
        Position=UDim2.new(0,16,0,29),BackgroundTransparency=1,
        Font=Enum.Font.Gotham,TextSize=10,TextColor3=C.sb,
        TextXAlignment=Enum.TextXAlignment.Left,Text=desc},r)
    end
    local vl=M("TextLabel",{Size=UDim2.fromOffset(40,16),
    Position=UDim2.new(1,-140,0.5,-8),BackgroundTransparency=1,
    Font=Enum.Font.Code,TextSize=12,TextColor3=C.ac2,
    Text=tostring(d),TextXAlignment=Enum.TextXAlignment.Right},r)
    local tr=M("Frame",{Size=UDim2.fromOffset(90,6),
    Position=UDim2.new(1,-94,0.5,-3),
    BackgroundColor3=C.dim,BorderSizePixel=0},r)
    M("UICorner",{CornerRadius=UDim.new(1,0)},tr)
    local fl=M("Frame",{Size=UDim2.new((d-mn)/(mx-mn),0,1,0),
    BackgroundColor3=C.ac,BorderSizePixel=0},tr)
    M("UICorner",{CornerRadius=UDim.new(1,0)},fl)
    M("UIGradient",{Color=ColorSequence.new(C.ac,C.hot)},fl)
    local st={value=d}
    local dr=false
    local function sx(x)
        local rl=math.clamp((x-tr.AbsolutePosition.X)/
            tr.AbsoluteSize.X,0,1)
        local v=mn+(mx-mn)*rl
        if rd then v=math.floor(v+0.5) end
        st.value=v
        vl.Text=tostring(v)
        fl.Size=UDim2.new(rl,0,1,0)
        if cb then pcall(cb,v) end
    end
    tr.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then
            dr=true sx(i.Position.X)
        end
    end)
    U.InputChanged:Connect(function(i)
        if dr and (i.UserInputType==Enum.UserInputType.MouseMovement
        or i.UserInputType==Enum.UserInputType.Touch) then
            sx(i.Position.X)
        end
    end)
    U.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then
            dr=false
        end
    end)
    return st
end

local function gbtn(par,title,cb,c1,c2)
    c1=c1 or C.ac c2=c2 or C.hot
    local b=M("TextButton",{Size=UDim2.new(1,0,0,46),
    BackgroundColor3=c1,BorderSizePixel=0,
    Font=Enum.Font.GothamBold,TextSize=13,
    TextColor3=Color3.new(1,1,1),Text=title,
    AutoButtonColor=false},par)
    M("UICorner",{CornerRadius=UDim.new(0,11)},b)
    M("UIGradient",{Color=ColorSequence.new(c1,c2)},b)
    b.MouseEnter:Connect(function()
        T:Create(b,TweenInfo.new(0.15),
        {BackgroundTransparency=0.15}):Play()
    end)
    b.MouseLeave:Connect(function()
        T:Create(b,TweenInfo.new(0.15),
        {BackgroundTransparency=0}):Play()
    end)
    b.MouseButton1Click:Connect(function() if cb then pcall(cb) end end)
    return b
end

local function rbtn(par,title,cb,color)
    color=color or C.ac
    local r=M("Frame",{Size=UDim2.new(1,0,0,42),
    BackgroundColor3=C.row,BorderSizePixel=0},par)
    M("UICorner",{CornerRadius=UDim.new(0,9)},r)
    M("TextLabel",{Size=UDim2.new(1,-100,1,0),
    Position=UDim2.new(0,16,0,0),BackgroundTransparency=1,
    Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=C.tx,
    TextXAlignment=Enum.TextXAlignment.Left,Text=title},r)
    local b=M("TextButton",{Size=UDim2.fromOffset(74,28),
    Position=UDim2.new(1,-86,0.5,-14),
    BackgroundColor3=color,BorderSizePixel=0,
    Font=Enum.Font.GothamBold,TextSize=11,
    TextColor3=Color3.new(1,1,1),Text="Run",
    AutoButtonColor=false},r)
    M("UICorner",{CornerRadius=UDim.new(0,7)},b)
    b.MouseButton1Click:Connect(function() if cb then pcall(cb) end end)
    return b
end

local function dd(par,title,desc,opts,d,cb)
    local r=M("Frame",{Size=UDim2.new(1,0,0,58),
    BackgroundColor3=C.row,BorderSizePixel=0},par)
    M("UICorner",{CornerRadius=UDim.new(0,9)},r)
    M("TextLabel",{Size=UDim2.new(1,-170,0,16),
    Position=UDim2.new(0,16,0,11),BackgroundTransparency=1,
    Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=C.tx,
    TextXAlignment=Enum.TextXAlignment.Left,Text=title},r)
    if desc then
        M("TextLabel",{Size=UDim2.new(1,-170,0,14),
        Position=UDim2.new(0,16,0,29),BackgroundTransparency=1,
        Font=Enum.Font.Gotham,TextSize=10,TextColor3=C.sb,
        TextXAlignment=Enum.TextXAlignment.Left,Text=desc},r)
    end
    local s=M("TextButton",{Size=UDim2.fromOffset(140,32),
    Position=UDim2.new(1,-154,0.5,-16),
    BackgroundColor3=C.card,BorderSizePixel=0,
    Font=Enum.Font.GothamMedium,TextSize=11,
    TextColor3=C.tx,Text=d or opts[1],
    AutoButtonColor=false},r)
    M("UICorner",{CornerRadius=UDim.new(0,8)},s)
    M("UIStroke",{Color=C.ac,Thickness=1,Transparency=0.5},s)
    local i=1
    local st={value=d or opts[1]}
    s.MouseButton1Click:Connect(function()
        i=i%#opts+1
        st.value=opts[i]
        s.Text=st.value
        if cb then pcall(cb,st.value) end
    end)
    return st
end

-- ============================================================
-- CONFIG
-- ============================================================
local K={
    aim=false,aimFov=200,aimPart="Head",
    autoFire=false,fireDelay=0.05,shootMurderer=false,
    autoKnife=false,knifeRange=12,
    killAura=false,auraRad=20,
    esp=true,box=true,nm=true,ds=true,ro=true,hp=true,chams=true,
    spd=22,jmp=50,hip=2,ij=false,nc=false,
    fly=false,fs=80,gm=false,af=false,spin=false,
    pick=true,prad=60,ctp=false,grav=196,
    fb=false,nf=false,rb=false,cross=false,
    afk=true,spam=false,sptext="serenity",spdel=1.5,
}

-- ============================================================
-- TABS
-- ============================================================
local T1=tab("main","  Main")
local T2=tab("player","  Player")
local T3=tab("combat","  Combat")
local T4=tab("teleport","  Teleport")
local T5=tab("trade","  Trade & Utils")
local T6=tab("discord","  Discord")
local T7=tab("settings","  Settings")

-- MAIN
section(T1,"General")
local cm=card(T1)
tgl(cm,"Master Toggle","Enable all core features",true,
    function(v)
        K.esp=v K.aim=v
        notify("Master",v and "Enabled" or "Disabled",
            v and C.ok or C.sb)
    end)
tgl(cm,"Notifications","Show toast popups",true,nil)

section(T1,"Quick Actions")
local ca=card(T1)
gbtn(ca,"Join Sheriff Round",function()
    local gun=LP.Backpack:FindFirstChild("Gun")
    if gun then
        local h=LP.Character and
            LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h:EquipTool(gun) end
        notify("Main","Equipped sheriff gun",C.ok)
    else
        notify("Main","No sheriff gun",C.dg)
    end
end,C.ac3,C.ac)
gbtn(ca,"Join Murderer Round",function()
    local knife=LP.Backpack:FindFirstChild("Knife")
    if not knife and LP.Character then
        knife=LP.Character:FindFirstChild("Knife")
    end
    if knife then
        local h=LP.Character and
            LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h:EquipTool(knife) end
        notify("Main","Equipped knife",C.dg)
    else
        notify("Main","No knife",C.dg)
    end
end,C.hot,C.dg)

section(T1,"Community")
local ccm=card(T1)
gbtn(ccm,"JOIN OUR DISCORD",function()
    if setclipboard then
        setclipboard(DISCORD)
        notify("Discord","Copied! Paste in browser",C.disc)
    else
        notify("Discord",DISCORD,C.disc)
    end
end,C.disc,C.ac3)

-- PLAYER
section(T2,"Movement")
local pm=card(T2)
sld(pm,"Walk Speed","Base movement speed",16,300,22,true,
    function(v)
        K.spd=v
        local h=LP.Character and
            LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed=v end
    end)
sld(pm,"Jump Power","Vertical force",50,500,50,true,
    function(v)
        K.jmp=v
        local h=LP.Character and
            LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.JumpPower=v end
    end)
sld(pm,"Hip Height","Standing offset",0,20,2,true,
    function(v)
        K.hip=v
        local h=LP.Character and
            LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.HipHeight=v end
    end)
tgl(pm,"Infinite Jump","Jump mid-air",false,
    function(v)K.ij=v end)
tgl(pm,"Noclip","Walk through walls",false,
    function(v)K.nc=v end)

section(T2,"Flight")
local pf=card(T2)
tgl(pf,"Fly","Free movement",false,function(v)K.fly=v end)
sld(pf,"Fly Speed","Flight velocity",20,400,80,true,
    function(v)K.fs=v end)

section(T2,"Extras")
local pe=card(T2)
tgl(pe,"Godmode","Local health lock",false,
    function(v)K.gm=v end)
tgl(pe,"Anti-Fling","Block fling attempts",false,
    function(v)K.af=v end)
tgl(pe,"Spin","Constant rotation",false,
    function(v)K.spin=v end)
rbtn(pe,"Reset Character",function()
    local h=LP.Character and
        LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.Health=0 end
end,C.dg)

-- COMBAT
section(T3,"Kill Functions")
local cf=card(T3)
tgl(cf,"Auto Kill Radius","Kill players in radius",false,
    function(v)K.killAura=v end)
sld(cf,"Aura Radius","Radius of the kill aura",5,100,20,true,
    function(v)K.auraRad=v end)
gbtn(cf,"Equip Knife",function()
    local knife=LP.Character and
        LP.Character:FindFirstChild("Knife")
    if not knife then
        knife=LP.Backpack:FindFirstChild("Knife")
    end
    if knife then
        local h=LP.Character and
            LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h:EquipTool(knife) end
        notify("Combat","Knife equipped",C.ok)
    else
        notify("Combat","No knife",C.dg)
    end
end)
gbtn(cf,"Kill All",function()
    local myChar=LP.Character
    if not myChar then
        notify("Combat","No character",C.dg)
        return
    end
    local myHR=myChar:FindFirstChild("HumanoidRootPart")
    local hum=myChar:FindFirstChildOfClass("Humanoid")
    if not myHR or not hum then return end

    local knife=myChar:FindFirstChild("Knife")
    if not knife then
        knife=LP.Backpack:FindFirstChild("Knife")
        if knife then
            hum:EquipTool(knife)
            task.wait(0.4)
            knife=myChar:FindFirstChild("Knife")
        end
    end
    if not knife then
        notify("Combat","Need knife",C.dg)
        return
    end
    local slash=knife:FindFirstChild("Slash")
    if not slash then
        notify("Combat","No slash remote",C.dg)
        return
    end

    local orig=myHR.CFrame
    local count=0
    for _,p in ipairs(P:GetPlayers()) do
        if p~=LP and p.Character then
            local hr=p.Character:FindFirstChild("HumanoidRootPart")
            local h=p.Character:FindFirstChildOfClass("Humanoid")
            if hr and h and h.Health>0 then
                myHR.CFrame=hr.CFrame*CFrame.new(0,0,2)
                task.wait(0.12)
                pcall(function() slash:FireServer(hr) end)
                task.wait(0.12)
                count=count+1
            end
        end
    end
    myHR.CFrame=orig
    notify("Combat","Killed "..count,C.ok)
end,C.hot,C.dg)

section(T3,"Shooting")
local cs=card(T3)
tgl(cs,"Shoot Murderer","Auto-fire at murderer",false,
    function(v)K.shootMurderer=v end)
tgl(cs,"Auto Shoot","Continuous fire when equipped",false,
    function(v)K.autoFire=v end)
sld(cs,"Fire Delay","Milliseconds between shots",10,300,50,true,
    function(v)K.fireDelay=v/1000 end)

section(T3,"Knife")
local ck=card(T3)
tgl(ck,"Auto Knife","Slash nearby players",false,
    function(v)K.autoKnife=v end)
sld(ck,"Knife Range","Slash distance",5,40,12,true,
    function(v)K.knifeRange=v end)

section(T3,"Aim Assist")
local aimc=card(T3)
tgl(aimc,"Silent Aim","Hit through walls",false,
    function(v)K.aim=v end)
sld(aimc,"FOV Radius","Aim assist range",10,800,200,true,
    function(v)K.aimFov=v end)
dd(aimc,"Hit Part","Target bone",
    {"Head","HumanoidRootPart","UpperTorso","LowerTorso"},"Head",
    function(v)K.aimPart=v end)

-- TELEPORT
section(T4,"Local")
local tp=card(T4)
tgl(tp,"Click Teleport","Click to teleport",false,
    function(v)K.ctp=v end)
rbtn(tp,"Teleport to Spawn",function()
    local r=LP.Character and
        LP.Character:FindFirstChild("HumanoidRootPart")
    if r then r.CFrame=CFrame.new(0,10,0) end
end)

section(T4,"Players")
local tpl=card(T4)
rbtn(tpl,"Bring All to Me",function()
    local r=LP.Character and
        LP.Character:FindFirstChild("HumanoidRootPart")
    if not r then return end
    local n=0
    for _,p in ipairs(P:GetPlayers()) do
        if p~=LP and p.Character then
            local h=p.Character:FindFirstChild("HumanoidRootPart")
            if h then
                h.CFrame=r.CFrame*CFrame.new(0,0,3)
                n=n+1
            end
        end
    end
    notify("Teleport","Brought "..n,C.ok)
end)
rbtn(tpl,"Go to Murderer",function()
    for _,p in ipairs(P:GetPlayers()) do
        if p~=LP and p.Character then
            local hasKnife=false
            local function scan(c)
                for _,t in ipairs(c:GetChildren()) do
                    if t:IsA("Tool")
                    and t.Name:lower():find("knife") then
                        return true
                    end
                end
                return false
            end
            hasKnife=scan(p.Character)
            if not hasKnife and p:FindFirstChild("Backpack") then
                hasKnife=scan(p.Backpack)
            end
            if hasKnife then
                local myr=LP.Character and
                    LP.Character:FindFirstChild("HumanoidRootPart")
                local hr=p.Character:FindFirstChild("HumanoidRootPart")
                if myr and hr then
                    myr.CFrame=hr.CFrame*CFrame.new(0,0,4)
                    notify("Teleport","At murderer: "..p.Name,C.dg)
                end
                return
            end
        end
    end
    notify("Teleport","Not found",C.sb)
end)
rbtn(tpl,"Go to Sheriff",function()
    for _,p in ipairs(P:GetPlayers()) do
        if p~=LP and p.Character then
            local hasGun=false
            local function scan(c)
                for _,t in ipairs(c:GetChildren()) do
                    if t:IsA("Tool") then
                        local n=t.Name:lower()
                        if n:find("gun") or n:find("revolver")
                        or n:find("pistol") then return true end
                    end
                end
                return false
            end
            hasGun=scan(p.Character)
            if not hasGun and p:FindFirstChild("Backpack") then
                hasGun=scan(p.Backpack)
            end
            if hasGun then
                local myr=LP.Character and
                    LP.Character:FindFirstChild("HumanoidRootPart")
                local hr=p.Character:FindFirstChild("HumanoidRootPart")
                if myr and hr then
                    myr.CFrame=hr.CFrame*CFrame.new(0,0,4)
                    notify("Teleport","At sheriff: "..p.Name,C.ac3)
                end
                return
            end
        end
    end
    notify("Teleport","Not found",C.sb)
end)

section(T4,"Server")
local tsv=card(T4)
rbtn(tsv,"Server Hop",function()
    notify("Server","Hopping...",C.ac2)
    pcall(function()
        local u="https://games.roblox.com/v1/games/"..
            game.PlaceId.."/servers/Public?limit=100"
        local r=HS:JSONDecode(game:HttpGet(u))
        if r and r.data then
            for _,s in ipairs(r.data) do
                if s.playing<s.maxPlayers
                and s.id~=game.JobId then
                    TS:TeleportToPlaceInstance(game.PlaceId,s.id,LP)
                    return
                end
            end
        end
    end)
end)
rbtn(tsv,"Rejoin Current",function()
    TS:Teleport(game.PlaceId,LP)
end)

-- TRADE
section(T5,"Items")
local ui=card(T5)
tgl(ui,"Auto Pickup","Grab nearby drops",true,
    function(v)K.pick=v end)
sld(ui,"Pickup Radius","Auto-grab distance",10,200,60,true,
    function(v)K.prad=v end)

section(T5,"Physics")
local up=card(T5)
sld(up,"World Gravity","Global gravity",0,500,196,true,
    function(v)
        K.grav=v workspace.Gravity=v
    end)

section(T5,"Chat")
local uc=card(T5)
tgl(uc,"Chat Spam","Repeat message",false,
    function(v)K.spam=v end)
sld(uc,"Spam Delay","Delay x10ms",5,100,15,true,
    function(v)K.spdel=v/10 end)

-- DISCORD TAB
local discHero=card(T6)
gbtn(discHero,"JOIN SERENITY DISCORD",function()
    if setclipboard then
        setclipboard(DISCORD)
        notify("Discord","Copied! Paste in browser",C.disc)
    else
        notify("Discord",DISCORD,C.disc)
    end
end,C.disc,C.ac3)
M("TextLabel",{Size=UDim2.new(1,0,0,44),
BackgroundTransparency=1,Font=Enum.Font.GothamBlack,
TextSize=18,TextColor3=C.disc,
Text="discord.gg/8XbXfAQkMm"},discHero)
M("TextLabel",{Size=UDim2.new(1,0,0,60),
BackgroundTransparency=1,Font=Enum.Font.Gotham,
TextSize=11,TextColor3=C.sb,TextWrapped=true,
Text="click the button above to copy the invite. paste it in your browser to join. community, updates, support, and early builds."},discHero)

section(T6,"What you get")
local discInfo=card(T6)
M("TextLabel",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,
Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.tx,
Text="  -  early access to new builds"},discInfo)
M("TextLabel",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,
Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.tx,
Text="  -  direct support from the devs"},discInfo)
M("TextLabel",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,
Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.tx,
Text="  -  feature requests and voting"},discInfo)
M("TextLabel",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,
Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.tx,
Text="  -  announcements and changelogs"},discInfo)
M("TextLabel",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,
Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.tx,
Text="  -  community screenshots and clips"},discInfo)

-- SETTINGS
section(T7,"ESP")
local se=card(T7)
tgl(se,"Master ESP","Enable all ESP",true,function(v)K.esp=v end)
tgl(se,"Box","Outline boxes",true,function(v)K.box=v end)
tgl(se,"Name","Player names",true,function(v)K.nm=v end)
tgl(se,"Distance","Stud count",true,function(v)K.ds=v end)
tgl(se,"Role Tag","Show murderer/sheriff",true,
    function(v)K.ro=v end)
tgl(se,"Health Bar","Side health bar",true,function(v)K.hp=v end)
tgl(se,"Chams","Fill player models",true,function(v)K.chams=v end)

section(T7,"Visual")
local sv=card(T7)
tgl(sv,"Fullbright","Brighten world",false,function(v)
    K.fb=v
    L.Brightness=v and 2 or 1
    L.ClockTime=v and 14 or 12
    L.GlobalShadows=not v
    if v then L.FogEnd=1e6 end
end)
tgl(sv,"No Fog","Remove fog",false,function(v)
    K.nf=v if v then L.FogEnd=1e6 end
end)
tgl(sv,"Rainbow Ambience","Cycle ambient color",false,
    function(v)K.rb=v end)
tgl(sv,"Crosshair","Center dot",false,
    function(v)K.cross=v end)
sld(sv,"Camera FOV","Field of view",30,140,70,true,
    function(v)CM.FieldOfView=v end)

section(T7,"Automation")
local sa=card(T7)
tgl(sa,"Anti-AFK","Prevent idle kick",true,
    function(v)K.afk=v end)

section(T7,"About")
local sab=card(T7)
M("TextLabel",{Size=UDim2.new(1,0,0,20),
BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=11,
TextColor3=C.sb,Text="Serenity Hub v7.0"},sab)
M("TextLabel",{Size=UDim2.new(1,0,0,20),
BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=11,
TextColor3=C.disc,Text="discord.gg/8XbXfAQkMm"},sab)
rbtn(sab,"Unload Serenity Hub",function()
    notify("Unloaded","Goodbye",C.dg)
    task.wait(0.4)
    G:Destroy()
    if getgenv().Serenity then getgenv().Serenity.gui=nil end
end,C.dg)

SRB:GetPropertyChangedSignal("Text"):Connect(function()
    local q=SRB.Text:lower()
    for name,b in pairs(TABS) do
        local lbl=b:FindFirstChild("lbl")
        if lbl then
            b.Visible=(q=="" or lbl.Text:lower():find(q))
        end
    end
end)

-- ============================================================
-- ESP
-- ============================================================
local EC={}

local function scanRole(cont)
    if not cont then return nil end
    for _,t in ipairs(cont:GetChildren()) do
        if t:IsA("Tool") then
            local n=t.Name:lower()
            if n:find("knife") or n:find("dagger")
            or n:find("blade") or n=="murderer"
            or n:find("murder") then
                return "MURDERER"
            end
            if n:find("gun") or n:find("revolver")
            or n:find("pistol") or n:find("colt")
            or n:find("sheriff") or n:find("magnum")
            or n:find("handgun") then
                return "SHERIFF"
            end
        end
    end
    return nil
end

local function ro(p)
    if p==LP then return "YOU" end
    local c=p.Character
    if not c then return "?" end
    local r=scanRole(c)
    if r then return r end
    local bp=p:FindFirstChild("Backpack")
    if bp then
        r=scanRole(bp)
        if r then return r end
    end
    for _,f in ipairs(p:GetChildren()) do
        if f:IsA("Folder") or f:IsA("Model") then
            r=scanRole(f)
            if r then return r end
        end
    end
    return "INNOCENT"
end

local function rco(r)
    if r=="MURDERER" then return Color3.fromRGB(255,70,90) end
    if r=="SHERIFF" then return Color3.fromRGB(90,180,255) end
    if r=="YOU" then return C.ac2 end
    return Color3.fromRGB(150,230,160)
end

local function bE(p)
    if p==LP or EC[p] then return end
    local hl=Instance.new("Highlight")
    hl.Name="SerenityChams"
    hl.FillTransparency=0.7
    hl.OutlineTransparency=0.15
    hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent=G
    local bg=Instance.new("BillboardGui")
    bg.Name="SerenityTag"
    bg.Size=UDim2.fromOffset(220,40)
    bg.StudsOffset=Vector3.new(0,3.2,0)
    bg.AlwaysOnTop=true
    bg.LightInfluence=0
    bg.MaxDistance=1000
    bg.Parent=G
    local lbl=Instance.new("TextLabel")
    lbl.Size=UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency=1
    lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=13
    lbl.TextStrokeTransparency=0.3
    lbl.TextColor3=Color3.new(1,1,1)
    lbl.Text=p.Name
    lbl.Parent=bg
    local bb=Instance.new("BillboardGui")
    bb.Name="SerenityBox"
    bb.Size=UDim2.fromOffset(50,80)
    bb.AlwaysOnTop=true
    bb.LightInfluence=0
    bb.MaxDistance=1000
    bb.Parent=G
    local bf=Instance.new("Frame")
    bf.Size=UDim2.fromScale(1,1)
    bf.BackgroundTransparency=1
    bf.BorderSizePixel=0
    bf.Parent=bb
    local sk=Instance.new("UIStroke")
    sk.Thickness=1.5
    sk.Color=Color3.new(1,1,1)
    sk.Parent=bf
    local hb=Instance.new("Frame")
    hb.Size=UDim2.new(0,3,1,0)
    hb.Position=UDim2.new(0,-6,0,0)
    hb.BackgroundColor3=Color3.fromRGB(110,230,150)
    hb.BorderSizePixel=0
    hb.Parent=bf
    EC[p]={hl=hl,bg=bg,lbl=lbl,bb=bb,sk=sk,hb=hb}
end

for _,p in ipairs(P:GetPlayers()) do pcall(bE,p) end
P.PlayerAdded:Connect(function(p) pcall(bE,p) end)
P.PlayerRemoving:Connect(function(p)
    local d=EC[p]
    if d then
        for _,v in pairs(d) do
            pcall(function() v:Destroy() end)
        end
        EC[p]=nil
    end
end)

R.Heartbeat:Connect(function()
    for p,d in pairs(EC) do
        local c=p.Character
        local hd=c and c:FindFirstChild("Head")
        local hr=c and c:FindFirstChild("HumanoidRootPart")
        local h=c and c:FindFirstChildOfClass("Humanoid")
        local al=hd and hr and h and h.Health>0
        if not al then
            d.hl.Enabled=false d.bg.Enabled=false d.bb.Enabled=false
        else
            local rl=ro(p)
            local cl=rco(rl)
            d.hl.Enabled=K.esp and K.chams
            d.hl.FillColor=cl
            d.hl.OutlineColor=cl
            d.bb.Enabled=K.esp and K.box
            d.bg.Enabled=K.esp and (K.nm or K.ro or K.ds)
            if d.bb.Adornee~=hr then d.bb.Adornee=hr end
            if d.bg.Adornee~=hd then d.bg.Adornee=hd end
            if d.hl.Adornee~=c then d.hl.Adornee=c end
            d.sk.Color=cl
            if K.hp then
                d.hb.Visible=true
                local fr=math.clamp(h.Health/h.MaxHealth,0,1)
                d.hb.Size=UDim2.new(0,3,fr,0)
                d.hb.Position=UDim2.new(0,-6,1-fr,0)
                d.hb.BackgroundColor3=Color3.fromRGB(
                    255*(1-fr),255*fr,80)
            else d.hb.Visible=false end
            local pts={}
            if K.nm then table.insert(pts,p.Name) end
            if K.ro then table.insert(pts,"["..rl.."]") end
            if K.ds then
                local mr=LP.Character and
                    LP.Character:FindFirstChild("HumanoidRootPart")
                if mr then
                    table.insert(pts,math.floor(
                        (hr.Position-mr.Position).Magnitude).."s")
                end
            end
            d.lbl.Text=table.concat(pts,"  ")
            d.lbl.TextColor3=cl
        end
    end
end)

-- ============================================================
-- SILENT AIM (rewrites all Vector3 args in FireServer)
-- ============================================================
local function closestTarget()
    local center=CM.ViewportSize/2
    local best,bd=nil,K.aimFov
    for p in pairs(EC) do
        local c=p.Character
        if c then
            local part=c:FindFirstChild(K.aimPart)
                or c:FindFirstChild("HumanoidRootPart")
            local h=c:FindFirstChildOfClass("Humanoid")
            if part and h and h.Health>0 then
                local pos,on=CM:WorldToViewportPoint(part.Position)
                if on then
                    local dd=(Vector2.new(pos.X,pos.Y)-center).Magnitude
                    if dd<bd then best,bd=part,dd end
                end
            end
        end
    end
    return best
end

local hookOK=false
if hookmetamethod and newcclosure and getrawmetatable then
    local ok,err=pcall(function()
        local mt=getrawmetatable(game)
        local old=mt.__namecall
        if setreadonly then setreadonly(mt,false) end
        mt.__namecall=newcclosure(function(self,...)
            local method=getnamecallmethod
                and getnamecallmethod()
            if K.aim and method=="FireServer" then
                local t=closestTarget()
                if t then
                    local args={...}
                    for i,v in ipairs(args) do
                        if typeof(v)=="Vector3" then
                            args[i]=(t.Position-
                                CM.CFrame.Position).Unit*1000
                        end
                    end
                    return old(self,table.unpack(args))
                end
            end
            return old(self,...)
        end)
        if setreadonly then setreadonly(mt,true) end
    end)
    hookOK=ok
end

-- ============================================================
-- CROSSHAIR
-- ============================================================
local CG=M("ScreenGui",{Name="SerenityCross",
ResetOnSpawn=false,IgnoreGuiInset=true,Enabled=false},PG)
M("Frame",{Size=UDim2.fromOffset(2,10),
Position=UDim2.new(0.5,-1,0.5,-14),
BackgroundColor3=C.hot,BorderSizePixel=0},CG)
M("Frame",{Size=UDim2.fromOffset(10,2),
Position=UDim2.new(0.5,-5,0.5,-1),
BackgroundColor3=C.hot,BorderSizePixel=0},CG)

-- ============================================================
-- LOOPS
-- ============================================================
R.Stepped:Connect(function()
    local c=LP.Character
    if not c then return end
    if K.nc then
        for _,p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end
    if K.gm then
        local h=c:FindFirstChildOfClass("Humanoid")
        if h then h.Health=h.MaxHealth end
    end
    if K.af then
        local hr=c:FindFirstChild("HumanoidRootPart")
        if hr and hr.Velocity.Magnitude>200 then
            hr.Velocity=Vector3.zero
        end
    end
    if K.spin then
        local hr=c:FindFirstChild("HumanoidRootPart")
        if hr then
            hr.CFrame=hr.CFrame*CFrame.Angles(0,0.3,0)
        end
    end
end)

U.JumpRequest:Connect(function()
    if K.ij then
        local h=LP.Character and
            LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

U.InputBegan:Connect(function(i,gp)
    if gp then return end
    if K.ctp and i.UserInputType==Enum.UserInputType.MouseButton1 then
        local m=LP:GetMouse()
        local r=LP.Character and
            LP.Character:FindFirstChild("HumanoidRootPart")
        if r and m.Hit then
            r.CFrame=CFrame.new(m.Hit.Position+Vector3.new(0,3,0))
        end
    end
end)

local fBV,fBG
R.RenderStepped:Connect(function()
    if K.fly then
        if not fBV then
            local c=LP.Character
            local hr=c and c:FindFirstChild("HumanoidRootPart")
            if hr then
                local h=c:FindFirstChildOfClass("Humanoid")
                if h then h.PlatformStand=true end
                fBV=Instance.new("BodyVelocity",hr)
                fBV.MaxForce=Vector3.new(1e5,1e5,1e5)
                fBG=Instance.new("BodyGyro",hr)
                fBG.MaxTorque=Vector3.new(1e5,1e5,1e5)
                fBG.P=1e4 fBG.CFrame=hr.CFrame
            end
        end
        if fBV then
            local mv=Vector3.zero
            if U:IsKeyDown(Enum.KeyCode.W) then mv=mv+CM.CFrame.LookVector end
            if U:IsKeyDown(Enum.KeyCode.S) then mv=mv-CM.CFrame.LookVector end
            if U:IsKeyDown(Enum.KeyCode.A) then mv=mv-CM.CFrame.RightVector end
            if U:IsKeyDown(Enum.KeyCode.D) then mv=mv+CM.CFrame.RightVector end
            if U:IsKeyDown(Enum.KeyCode.Space) then mv=mv+Vector3.new(0,1,0) end
            if U:IsKeyDown(Enum.KeyCode.LeftShift) then mv=mv-Vector3.new(0,1,0) end
            fBV.Velocity=mv*K.fs
            fBG.CFrame=CM.CFrame
        end
    elseif fBV then
        fBV:Destroy() fBV=nil
        if fBG then fBG:Destroy() fBG=nil end
        local h=LP.Character and
            LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.PlatformStand=false end
    end
end)

LP.Idled:Connect(function()
    if K.afk then
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
    end
end)

task.spawn(function()
    while G.Parent do
        task.wait(0.3)
        if K.pick then
            local r=LP.Character and
                LP.Character:FindFirstChild("HumanoidRootPart")
            if r and firetouchinterest then
                for _,o in ipairs(workspace:GetChildren()) do
                    if o:IsA("Tool") and o:FindFirstChild("Handle") then
                        local d=(o.Handle.Position-r.Position).Magnitude
                        if d<=K.prad then
                            pcall(function()
                                firetouchinterest(r,o.Handle,0)
                                firetouchinterest(r,o.Handle,1)
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- auto shoot: fires with a Vector3 so silent aim can rewrite it
task.spawn(function()
    while G.Parent do
        task.wait(K.fireDelay)
        if K.autoFire or K.shootMurderer then
            local c=LP.Character
            if c then
                local g=c:FindFirstChild("Gun")
                    or c:FindFirstChildWhichIsA("Tool")
                if g and g:FindFirstChild("Fire") then
                    local fire=g.Fire
                    if K.shootMurderer then
                        for p in pairs(EC) do
                            if ro(p)=="MURDERER" then
                                local hr=p.Character and
                                    p.Character:FindFirstChild("HumanoidRootPart")
                                if hr then
                                    pcall(function()
                                        fire:FireServer(Vector3.new(0,0,0))
                                    end)
                                end
                                break
                            end
                        end
                    else
                        pcall(function()
                            fire:FireServer(Vector3.new(0,0,0))
                        end)
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while G.Parent do
        task.wait(0.15)
        if K.autoKnife then
            local c=LP.Character
            local r=c and c:FindFirstChild("HumanoidRootPart")
            local k=c and c:FindFirstChild("Knife")
            if r and k then
                local sl=k:FindFirstChild("Slash")
                if sl then
                    for p in pairs(EC) do
                        local ch=p.Character
                        local hr=ch and
                            ch:FindFirstChild("HumanoidRootPart")
                        local h=ch and
                            ch:FindFirstChildOfClass("Humanoid")
                        if hr and h and h.Health>0 then
                            if (hr.Position-r.Position).Magnitude
                            <= K.knifeRange then
                                pcall(function()
                                    sl:FireServer(hr)
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while G.Parent do
        task.wait(0.1)
        if K.killAura then
            local c=LP.Character
            local r=c and c:FindFirstChild("HumanoidRootPart")
            local k=c and (c:FindFirstChild("Knife")
                or LP.Backpack:FindFirstChild("Knife"))
            if k and k.Parent~=c then
                local h=c and c:FindFirstChildOfClass("Humanoid")
                if h then h:EquipTool(k) end
                task.wait(0.3)
                k=c:FindFirstChild("Knife")
            end
            if r and k then
                local sl=k:FindFirstChild("Slash")
                if sl then
                    for p in pairs(EC) do
                        local ch=p.Character
                        local hr=ch and
                            ch:FindFirstChild("HumanoidRootPart")
                        local h=ch and
                            ch:FindFirstChildOfClass("Humanoid")
                        if hr and h and h.Health>0 then
                            if (hr.Position-r.Position).Magnitude
                            <= K.auraRad then
                                pcall(function()
                                    sl:FireServer(hr)
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while G.Parent do
        task.wait(0.08)
        if K.rb then
            L.Ambient=Color3.fromHSV((tick()*0.1)%1,0.6,0.7)
        end
        if K.cross~=CG.Enabled then CG.Enabled=K.cross end
    end
end)

task.spawn(function()
    while G.Parent do
        task.wait(K.spdel)
        if K.spam then
            pcall(function()
                local ev=RS:FindFirstChild(
                    "DefaultChatSystemChatEvents")
                if ev then
                    ev.SayMessageRequest:FireServer(K.sptext,"All")
                end
            end)
        end
    end
end)

-- ============================================================
-- FLOATING REOPEN BUTTON
-- ============================================================
local reopen=M("TextButton",{Name="SerenityReopen",
Size=UDim2.fromOffset(58,58),
Position=UDim2.new(0,20,0,120),
BackgroundColor3=C.ac,BorderSizePixel=0,
Text="",Visible=false,AutoButtonColor=false,
Active=true,Draggable=true,ZIndex=100},G)
M("UICorner",{CornerRadius=UDim.new(1,0)},reopen)
M("UIGradient",{Color=ColorSequence.new(C.ac,C.disc),
Rotation=45},reopen)
local reopenStroke=M("UIStroke",{Color=C.disc,Thickness=2,
Transparency=0.3},reopen)
M("TextLabel",{Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,Font=Enum.Font.GothamBlack,
TextSize=26,TextColor3=Color3.new(1,1,1),
Text="S",ZIndex=2},reopen)

task.spawn(function()
    while reopen.Parent do
        if reopen.Visible then
            T:Create(reopenStroke,TweenInfo.new(0.9),
            {Transparency=0.8}):Play()
            task.wait(0.9)
            T:Create(reopenStroke,TweenInfo.new(0.9),
            {Transparency=0.3}):Play()
            task.wait(0.9)
        else
            task.wait(0.3)
        end
    end
end)

reopen.MouseButton1Click:Connect(function()
    MN.Visible=true
    reopen.Visible=false
end)

XB.MouseButton1Click:Connect(function()
    MN.Visible=false
    reopen.Visible=true
end)

HIDEB.MouseButton1Click:Connect(function()
    MN.Visible=false
    reopen.Visible=true
    notify("Hidden","Click S to reopen  |  rshift toggles",C.ac2)
end)

U.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.RightShift then
        MN.Visible=not MN.Visible
        reopen.Visible=not MN.Visible
    end
    if i.KeyCode==Enum.KeyCode.RightControl then
        K.aim=not K.aim
        notify("Aim",K.aim and "ON" or "OFF",
            K.aim and C.ok or C.sb)
    end
    if i.KeyCode==Enum.KeyCode.RightAlt then
        K.esp=not K.esp
        notify("ESP",K.esp and "ON" or "OFF",
            K.esp and C.ok or C.sb)
    end
end)

local minimized=false
MINB.MouseButton1Click:Connect(function()
    minimized=not minimized
    T:Create(MN,TweenInfo.new(0.25,
    Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
        {Size=minimized and UDim2.fromOffset(660,56)
            or UDim2.fromOffset(660,460)}):Play()
    SB.Visible=not minimized
    CT.Visible=not minimized
    DB.Visible=not minimized
end)

sel("main")
getgenv().Serenity={gui=G,config=K,notify=notify,
    closestTarget=closestTarget,reopen=reopen,discord=DISCORD}
notify("Serenity Hub","v7 loaded  |  discord.gg/8XbXfAQkMm",C.disc)
notify("Silent Aim",hookOK and "hook active" or "hook unavailable",
    hookOK and C.ok or C.sb)
print("[Serenity Hub] v7 loaded -- "..DISCORD)

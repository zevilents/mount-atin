-- ===============================
-- FULL LOCALSCRIPT: WELCOME + TELEPORT GUI
-- ===============================

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ===============================
-- TELEPORT GUI (FRAME + BUTTONS)
-- ===============================

-- Hapus GUI lama
if playerGui:FindFirstChild("TeleportGUI") then
	playerGui.TeleportGUI:Destroy()
end

-- ScreenGui Teleport
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame utama
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 280)
frame.Position = UDim2.new(0, 20, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Visible = false -- awalnya hidden
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🚀 Teleport Menu"
title.TextColor3 = Color3.fromRGB(200, 230, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Tombol minimize
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -30, 0, 5)
minimizeButton.Text = "–"
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 18
minimizeButton.Parent = frame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeButton

-- Scroll area
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -45)
scroll.Position = UDim2.new(0, 5, 0, 40)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.Parent = frame

-- Layout otomatis
local layout = Instance.new("UIListLayout")
layout.Parent = scroll
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end)

-- Floating open button (icon-only)
local openButton = Instance.new("ImageButton")
openButton.Size = UDim2.new(0, 40, 0, 40)
openButton.Position = frame.Position
openButton.Image = "rbxassetid://6034283386" -- icon roket
openButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
openButton.Visible = false
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 8)
openCorner.Parent = openButton

-- Tween animasi
local tweenIn = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local tweenOut = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

-- Variabel posisi terakhir
local lastFramePos = frame.Position

-- Fungsi open/minimize GUI
local function openGUI()
	frame.Visible = true
	openButton.Visible = false
	TweenService:Create(frame, tweenIn, {Position = lastFramePos}):Play()
end

local function minimizeGUI()
	lastFramePos = frame.Position
	TweenService:Create(frame, tweenOut, {Position = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset - 220, frame.Position.Y.Scale, frame.Position.Y.Offset)}):Play()
	frame.Visible = false
	openButton.Position = lastFramePos
	openButton.Visible = true
end

minimizeButton.MouseButton1Click:Connect(minimizeGUI)
openButton.MouseButton1Click:Connect(openGUI)

-- Keybind G
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.G then
		if frame.Visible then
			minimizeGUI()
		else
			openGUI()
		end
	end
end)

-- Fungsi teleport
local function teleportTo(position)
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")
	hrp.CFrame = CFrame.new(position)
end

-- Fungsi buat tombol
local function createButton(text, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -10, 0, 35)
	button.Text = text
	button.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
	button.TextColor3 = Color3.new(1,1,1)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 16
	button.Parent = scroll

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8)
	btnCorner.Parent = button

	if callback then
		button.MouseButton1Click:Connect(callback)
	end
end

-- Daftar lokasi BARU
local locations = {
	{"BASECAMP", Vector3.new(-244, 122, 203)},
	{"POS 1", Vector3.new(-134, 421, -220)},
	{"POS 2", Vector3.new(-4, 950, -1055)},
	{"POS 3", Vector3.new(110, 1202, -1361)},
	{"POS 4", Vector3.new(108, 1466, -1809)},
	{"POS 5", Vector3.new(298, 1862, -2332)},
	{"POS 6", Vector3.new(558, 2086, -2558)},
	{"POS 7", Vector3.new(752, 2186, -2498)},
	{"POS 8", Vector3.new(795, 2330, -2640)},
	{"POS 9", Vector3.new(969, 2518, -2633)},
	{"POS 10", Vector3.new(1243, 2694, -2800)},
	{"POS 11", Vector3.new(1615, 3058, -2753)},
	{"POS 12", Vector3.new(1813, 3578, -3247)},
	{"POS 13", Vector3.new(2810, 4422, -4796)},
	{"POS 14", Vector3.new(3471, 4858, -4185)},
	{"POS 15", Vector3.new(3481, 5106, -4279)},
	{"POS 16", Vector3.new(3979, 5666, -3973)},
	{"POS 17", Vector3.new(4499, 5898, -3793)},
	{"POS 18", Vector3.new(5064, 6370, -2978)},
	{"POS 19", Vector3.new(5537, 6590, -2494)},
	{"POS 20", Vector3.new(5551, 6874, -1051)},
	{"POS 21", Vector3.new(4330, 7642, 132)},
	{"POS 22", Vector3.new(3457, 7710, 938)},
	{"PUNCAK", Vector3.new(3042, 7878, 1038)},
}

-- Generate tombol lokasi
for _, data in ipairs(locations) do
	local name, pos = data[1], data[2]
	createButton(name, function()
		teleportTo(pos)
	end)
end

-- Tambahkan tombol Server Hop dan Rejoin setelah semua tombol lokasi
createButton("🔄 Server Hop", function()
	local placeId = game.PlaceId
	local servers = {}
	local cursor = ""
	local function listServers()
		local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100&cursor="..cursor
		local response = game:HttpGet(url)
		local data = HttpService:JSONDecode(response)
		return data
	end
	local success, data = pcall(listServers)
	if success and data and data.data then
		for _, server in ipairs(data.data) do
			if server.playing < server.maxPlayers and server.id ~= game.JobId then
				table.insert(servers, server.id)
			end
		end
	end
	if #servers > 0 then
		local randomServer = servers[math.random(1,#servers)]
		TeleportService:TeleportToPlaceInstance(placeId, randomServer, player)
	else
		warn("Tidak ada server lain ditemukan!")
	end
end)

createButton("🔁 Rejoin Server", function()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)

-- ===============================================
-- WELCOME SCREEN
-- ===============================================
local welcomeGui = Instance.new("ScreenGui")
welcomeGui.Name = "WelcomeScreen"
welcomeGui.ResetOnSpawn = false
welcomeGui.Parent = playerGui

-- Background
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(20,20,30)
bg.Parent = welcomeGui

-- Judul
local welcomeTitle = Instance.new("TextLabel")
welcomeTitle.Size = UDim2.new(1,0,0,100)
welcomeTitle.Position = UDim2.new(0,0,0,150)
welcomeTitle.BackgroundTransparency = 1
welcomeTitle.Text = "🚀 Welcome to the Game!"
welcomeTitle.TextColor3 = Color3.fromRGB(200,230,255)
welcomeTitle.Font = Enum.Font.GothamBold
welcomeTitle.TextSize = 36
welcomeTitle.TextTransparency = 1
welcomeTitle.Parent = bg

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1,0,0,50)
subtitle.Position = UDim2.new(0,0,0,270)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Prepare for adventure!"
subtitle.TextColor3 = Color3.fromRGB(180,180,200)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 24
subtitle.TextTransparency = 1
subtitle.Parent = bg

-- Continue button
local continueBtn = Instance.new("TextButton")
continueBtn.Size = UDim2.new(0,200,0,50)
continueBtn.Position = UDim2.new(0.5,-100,0.7,0)
continueBtn.BackgroundColor3 = Color3.fromRGB(70,130,255)
continueBtn.Text = "Continue"
continueBtn.TextColor3 = Color3.new(1,1,1)
continueBtn.Font = Enum.Font.GothamBold
continueBtn.TextSize = 22
continueBtn.TextTransparency = 1
continueBtn.Parent = bg

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0,12)
btnCorner.Parent = continueBtn

-- Fade-in animasi
for i = 0,1,0.02 do
	welcomeTitle.TextTransparency = 1 - i
	subtitle.TextTransparency = 1 - i
	continueBtn.TextTransparency = 1 - i
	wait(0.02)
end

-- Fungsi close welcome
local function closeWelcome()
	for i = 1,10 do
		bg.BackgroundTransparency = bg.BackgroundTransparency + 0.1
		welcomeTitle.TextTransparency = welcomeTitle.TextTransparency + 0.1
		subtitle.TextTransparency = subtitle.TextTransparency + 0.1
		continueBtn.TextTransparency = continueBtn.TextTransparency + 0.1
		wait(0.03)
	end
	welcomeGui:Destroy()
	openGUI() -- tampilkan teleport GUI setelah welcome screen
end

continueBtn.MouseButton1Click:Connect(closeWelcome)

-- ===============================================
-- DRAG SUPPORT FRAME
-- ===============================================
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(
		startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y
	)
	lastFramePos = frame.Position
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- DRAG SUPPORT OPEN BUTTON
local draggingOpen, dragInputOpen, dragStartOpen, startPosOpen
openButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingOpen = true
		dragStartOpen = input.Position
		startPosOpen = openButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingOpen = false
			end
		end)
	end
end)

openButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInputOpen = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInputOpen and draggingOpen then
		local delta = input.Position - dragStartOpen
		openButton.Position = UDim2.new(
			startPosOpen.X.Scale, startPosOpen.X.Offset + delta.X,
			startPosOpen.Y.Scale, startPosOpen.Y.Offset + delta.Y
		)
		lastFramePos = openButton.Position
	end
end)

-- CatGui.lua
-- Place this as a LocalScript inside StarterGui (or StarterPlayerScripts).

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Teleport locations
local SHOTGUN_POSITION = Vector3.new(-104, 23, 355)
local AK_POSITION = Vector3.new(-59, 35, 398)
local ARMOR_POSITION = Vector3.new(-75, 36, 402)
local MINIGUN_POSITION = Vector3.new(216, -6, 759)
local BREAK_OUT_POSITION = Vector3.new(222, 11, -45)
local YARD_POSITION = Vector3.new(115, 9, 97)
local BANK_POSITION = Vector3.new(7, 35, 650)

-- Default humanoid stats (used by Reset Stats)
local DEFAULT_WALKSPEED = 16
local DEFAULT_JUMPPOWER = 50

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CatGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Outer frame (fixed height, draggable via title bar)
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 220, 0, 320)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Title bar (drag handle)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 8)
titleBarCorner.Parent = titleBar

local titleBarFix = Instance.new("Frame")
titleBarFix.Size = UDim2.new(1, 0, 0, 10)
titleBarFix.Position = UDim2.new(0, 0, 1, -10)
titleBarFix.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBarFix.BorderSizePixel = 0
titleBarFix.ZIndex = 0
titleBarFix.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "Cat Gui"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = titleBar

-- Dragging logic (title bar moves the whole panel)
local dragging = false
local dragStart
local startPos

titleBar.InputBegan:Connect(function(input)
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

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

-- Scrolling container for buttons
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ButtonList"
scrollFrame.Size = UDim2.new(1, 0, 1, -30)
scrollFrame.Position = UDim2.new(0, 0, 0, 30)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = frame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

local listPadding = Instance.new("UIPadding")
listPadding.PaddingTop = UDim.new(0, 10)
listPadding.PaddingBottom = UDim.new(0, 10)
listPadding.Parent = scrollFrame

-- Teleport function
local function teleportPlayer(position)
	local character = player.Character or player.CharacterAdded:Wait()
	local rootPart = character:WaitForChild("HumanoidRootPart")
	rootPart.CFrame = CFrame.new(position)
end

-- Stat-setting function
local function setHumanoidStat(statName, value)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	humanoid[statName] = value
end

-- ===== Slider popup (shown on right-click of Jump/Speed buttons) =====
local sliderPopup = Instance.new("Frame")
sliderPopup.Name = "SliderPopup"
sliderPopup.Size = UDim2.new(0, 190, 0, 70)
sliderPopup.Position = UDim2.new(1, 10, 0, 30)
sliderPopup.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
sliderPopup.BorderSizePixel = 0
sliderPopup.Visible = false
sliderPopup.ZIndex = 10
sliderPopup.Parent = frame

local sliderPopupCorner = Instance.new("UICorner")
sliderPopupCorner.CornerRadius = UDim.new(0, 8)
sliderPopupCorner.Parent = sliderPopup

local popupLabel = Instance.new("TextLabel")
popupLabel.Size = UDim2.new(1, 0, 0, 25)
popupLabel.Position = UDim2.new(0, 0, 0, 5)
popupLabel.BackgroundTransparency = 1
popupLabel.Text = "Stat: 0"
popupLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
popupLabel.Font = Enum.Font.GothamBold
popupLabel.TextSize = 14
popupLabel.ZIndex = 11
popupLabel.Parent = sliderPopup

local track = Instance.new("Frame")
track.Name = "Track"
track.Size = UDim2.new(1, -20, 0, 6)
track.Position = UDim2.new(0, 10, 0, 42)
track.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
track.BorderSizePixel = 0
track.ZIndex = 11
track.Parent = sliderPopup

local trackCorner = Instance.new("UICorner")
trackCorner.CornerRadius = UDim.new(0, 3)
trackCorner.Parent = track

local fill = Instance.new("Frame")
fill.Name = "Fill"
fill.Size = UDim2.new(0, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
fill.BorderSizePixel = 0
fill.ZIndex = 12
fill.Parent = track

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 3)
fillCorner.Parent = fill

local knob = Instance.new("Frame")
knob.Name = "Knob"
knob.Size = UDim2.new(0, 16, 0, 16)
knob.AnchorPoint = Vector2.new(0.5, 0.5)
knob.Position = UDim2.new(0, 0, 0.5, 0)
knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
knob.ZIndex = 13
knob.Parent = track

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = knob

local currentStat = { name = nil, min = 0, max = 0 }
local knobDragging = false

local function setSliderValue(percent)
	percent = math.clamp(percent, 0, 1)
	fill.Size = UDim2.new(percent, 0, 1, 0)
	knob.Position = UDim2.new(percent, 0, 0.5, 0)

	local value = math.floor(currentStat.min + percent * (currentStat.max - currentStat.min))
	popupLabel.Text = currentStat.name .. ": " .. value
	setHumanoidStat(currentStat.name, value)
end

local function percentFromInputX(inputX)
	local trackPos = track.AbsolutePosition.X
	local trackWidth = track.AbsoluteSize.X
	return (inputX - trackPos) / trackWidth
end

knob.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		knobDragging = true
	end
end)

track.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		setSliderValue(percentFromInputX(input.Position.X))
		knobDragging = true
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if knobDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		setSliderValue(percentFromInputX(input.Position.X))
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		knobDragging = false
	end
end)

local function openSliderPopup(statName, min, max, default)
	if sliderPopup.Visible and currentStat.name == statName then
		sliderPopup.Visible = false
		return
	end

	currentStat = { name = statName, min = min, max = max }
	sliderPopup.Visible = true
	setSliderValue((default - min) / (max - min))
end

-- ===== Fly =====
local FLY_SPEED = 50
local flying = false
local flyBodyVelocity, flyBodyGyro
local flyButtonRef

local function stopFly()
	flying = false
	if flyBodyVelocity then
		flyBodyVelocity:Destroy()
		flyBodyVelocity = nil
	end
	if flyBodyGyro then
		flyBodyGyro:Destroy()
		flyBodyGyro = nil
	end

	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.PlatformStand = false
		end
	end

	if flyButtonRef then
		flyButtonRef.Text = "Fly (Off)"
	end
end

local function startFly()
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	local humanoid = character:WaitForChild("Humanoid")

	flying = true
	humanoid.PlatformStand = true

	flyBodyVelocity = Instance.new("BodyVelocity")
	flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
	flyBodyVelocity.Parent = humanoidRootPart

	flyBodyGyro = Instance.new("BodyGyro")
	flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	flyBodyGyro.P = 1e4
	flyBodyGyro.CFrame = humanoidRootPart.CFrame
	flyBodyGyro.Parent = humanoidRootPart

	if flyButtonRef then
		flyButtonRef.Text = "Fly (On)"
	end
end

local function toggleFly()
	if flying then
		stopFly()
	else
		startFly()
	end
end

RunService.Heartbeat:Connect(function()
	if not flying then
		return
	end

	local character = player.Character
	if not character then
		return
	end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart or not flyBodyVelocity or not flyBodyGyro then
		return
	end

	local camera = workspace.CurrentCamera
	local moveVector = Vector3.new(0, 0, 0)

	if UserInputService:IsKeyDown(Enum.KeyCode.W) then
		moveVector = moveVector + camera.CFrame.LookVector
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then
		moveVector = moveVector - camera.CFrame.LookVector
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then
		moveVector = moveVector - camera.CFrame.RightVector
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then
		moveVector = moveVector + camera.CFrame.RightVector
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
		moveVector = moveVector + Vector3.new(0, 1, 0)
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
		moveVector = moveVector - Vector3.new(0, 1, 0)
	end

	if moveVector.Magnitude > 0 then
		moveVector = moveVector.Unit * FLY_SPEED
	end

	flyBodyVelocity.Velocity = moveVector
	flyBodyGyro.CFrame = camera.CFrame
end)

-- ===== Noclip =====
local noclip = false
local noclipButtonRef

local function setCharacterCollisions(canCollide)
	local character = player.Character
	if not character then
		return
	end
	for _, part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = canCollide
		end
	end
end

local function toggleNoclip()
	noclip = not noclip
	if noclipButtonRef then
		noclipButtonRef.Text = noclip and "Noclip (On)" or "Noclip (Off)"
	end
	if not noclip then
		setCharacterCollisions(true)
	end
end

RunService.Stepped:Connect(function()
	if not noclip then
		return
	end
	local character = player.Character
	if not character then
		return
	end
	for _, part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") and part.CanCollide then
			part.CanCollide = false
		end
	end
end)

-- ===== Infinite Jump =====
local infiniteJumpEnabled = false
local infiniteJumpButtonRef

local function toggleInfiniteJump()
	infiniteJumpEnabled = not infiniteJumpEnabled
	if infiniteJumpButtonRef then
		infiniteJumpButtonRef.Text = infiniteJumpEnabled and "Infinite Jump (On)" or "Infinite Jump (Off)"
	end
end

UserInputService.JumpRequest:Connect(function()
	if not infiniteJumpEnabled then
		return
	end
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- ===== God Mode (auto-heal on damage) =====
local godModeEnabled = false
local godModeButtonRef
local godModeConnection

local function toggleGodMode()
	godModeEnabled = not godModeEnabled
	if godModeButtonRef then
		godModeButtonRef.Text = godModeEnabled and "God Mode (On)" or "God Mode (Off)"
	end

	if godModeConnection then
		godModeConnection:Disconnect()
		godModeConnection = nil
	end

	if godModeEnabled then
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.Health = humanoid.MaxHealth
		godModeConnection = humanoid.HealthChanged:Connect(function(newHealth)
			if godModeEnabled and newHealth < humanoid.MaxHealth then
				humanoid.Health = humanoid.MaxHealth
			end
		end)
	end
end

player.CharacterAdded:Connect(function(character)
	-- Re-arm god mode on respawn if it was left on
	if godModeEnabled then
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.Health = humanoid.MaxHealth
		if godModeConnection then
			godModeConnection:Disconnect()
		end
		godModeConnection = humanoid.HealthChanged:Connect(function(newHealth)
			if godModeEnabled and newHealth < humanoid.MaxHealth then
				humanoid.Health = humanoid.MaxHealth
			end
		end)
	end

	-- Reset fly/noclip state on respawn
	flying = false
	flyBodyVelocity = nil
	flyBodyGyro = nil
	if flyButtonRef then
		flyButtonRef.Text = "Fly (Off)"
	end
	noclip = false
	if noclipButtonRef then
		noclipButtonRef.Text = "Noclip (Off)"
	end
end)

-- ===== ESP (highlight other players through walls) =====
local espEnabled = false
local espButtonRef
local highlights = {}

local function addHighlight(otherPlayer)
	if otherPlayer == player then
		return
	end
	local character = otherPlayer.Character
	if not character or highlights[otherPlayer] then
		return
	end

	local highlight = Instance.new("Highlight")
	highlight.FillColor = Color3.fromRGB(255, 0, 0)
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.FillTransparency = 0.5
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Parent = character

	highlights[otherPlayer] = highlight
end

local function removeHighlight(otherPlayer)
	local highlight = highlights[otherPlayer]
	if highlight then
		highlight:Destroy()
		highlights[otherPlayer] = nil
	end
end

local function toggleESP()
	espEnabled = not espEnabled
	if espButtonRef then
		espButtonRef.Text = espEnabled and "ESP (On)" or "ESP (Off)"
	end

	if espEnabled then
		for _, otherPlayer in pairs(Players:GetPlayers()) do
			addHighlight(otherPlayer)
		end
	else
		for otherPlayer in pairs(highlights) do
			removeHighlight(otherPlayer)
		end
	end
end

Players.PlayerAdded:Connect(function(otherPlayer)
	otherPlayer.CharacterAdded:Connect(function()
		if espEnabled then
			addHighlight(otherPlayer)
		end
	end)
end)

for _, otherPlayer in pairs(Players:GetPlayers()) do
	otherPlayer.CharacterAdded:Connect(function()
		if espEnabled then
			addHighlight(otherPlayer)
		end
	end)
end

-- ===== Reset Stats =====
local function resetStats()
	setHumanoidStat("WalkSpeed", DEFAULT_WALKSPEED)
	setHumanoidStat("JumpPower", DEFAULT_JUMPPOWER)
end

-- ===== Loadout (teleport to Armor + boosted speed/jump in one click) =====
local function runLoadout()
	teleportPlayer(ARMOR_POSITION)
	setHumanoidStat("WalkSpeed", 200)
	setHumanoidStat("JumpPower", 100)
end

-- Helper to create a button inside the scroll list
local function createButton(name, text, order, onClick)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(0, 180, 0, 40)
	button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 16
	button.LayoutOrder = order
	button.Parent = scrollFrame

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 6)
	buttonCorner.Parent = button

	button.MouseButton1Click:Connect(onClick)

	return button
end

createButton("ShotgunButton", "Shotgun", 1, function()
	teleportPlayer(SHOTGUN_POSITION)
end)

createButton("AkButton", "Ak", 2, function()
	teleportPlayer(AK_POSITION)
end)

createButton("ArmorButton", "Armor", 3, function()
	teleportPlayer(ARMOR_POSITION)
end)

createButton("MinigunButton", "Minigun", 4, function()
	teleportPlayer(MINIGUN_POSITION)
end)

-- Jump Power button: left click = snap to 100, right click = open slider (0-300)
local jumpButton = createButton("JumpButton", "Jump Power 100", 5, function()
	setHumanoidStat("JumpPower", 100)
end)

jumpButton.MouseButton2Click:Connect(function()
	openSliderPopup("JumpPower", 0, 300, 100)
end)

-- Speed button: left click = snap to 200, right click = open slider (0-500)
local speedButton = createButton("SpeedButton", "Speed 200", 6, function()
	setHumanoidStat("WalkSpeed", 200)
end)

speedButton.MouseButton2Click:Connect(function()
	openSliderPopup("WalkSpeed", 0, 500, 200)
end)

createButton("BreakOutButton", "Break Out", 7, function()
	teleportPlayer(BREAK_OUT_POSITION)
end)

createButton("YardButton", "Yard", 8, function()
	teleportPlayer(YARD_POSITION)
end)

createButton("BankButton", "Bank", 9, function()
	teleportPlayer(BANK_POSITION)
end)

flyButtonRef = createButton("FlyButton", "Fly (Off)", 10, toggleFly)
noclipButtonRef = createButton("NoclipButton", "Noclip (Off)", 11, toggleNoclip)
infiniteJumpButtonRef = createButton("InfiniteJumpButton", "Infinite Jump (Off)", 12, toggleInfiniteJump)
godModeButtonRef = createButton("GodModeButton", "God Mode (Off)", 13, toggleGodMode)
espButtonRef = createButton("EspButton", "ESP (Off)", 14, toggleESP)

createButton("ResetStatsButton", "Reset Stats", 15, resetStats)
createButton("LoadoutButton", "Loadout (Armor+Buffs)", 16, runLoadout)

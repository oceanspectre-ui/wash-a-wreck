--!strict
-- SpeedometerController
-- Shows a speed dial (mph) and an RPM dial while the local player sits in a VehicleSeat.
--
-- Why the needle stays pinned to the centre:
--   Roblox rotates a GuiObject around its OWN centre. So the needle sits inside a
--   square "Pivot" frame whose centre is the dial's hub. The needle fills the top
--   half of that square, from its tip down to the hub. Rotating the Pivot swings the
--   tip around the scale while the base never leaves the hub.
--
-- Place in: StarterPlayer.StarterPlayerScripts.Controllers (ModuleScript)
-- Main client script calls: SpeedometerController.Init() then SpeedometerController.Start()
-- Client-only display. Reads the seat's velocity; sends nothing to the server.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local SpeedometerController = {}

-- Balance / look numbers. Move to a Shared config module when the drive system is final.
local CONFIG = {
	StudsPerSecToMph = 0.626, -- Roblox convention: 1 stud = 0.28 m
	MaxMph = 160,
	MphMajorStep = 20,
	MphMinorStep = 10,
	MaxRpm = 8, -- x1000
	RedlineRpm = 6.5, -- x1000
	IdleRpm = 0.8, -- x1000
	Gears = 5,
	SweepDegrees = 240, -- total arc, centred on straight up (0 sits lower-left, max lower-right)
	NeedleSmoothing = 12, -- higher = snappier
}

local COLORS = {
	Face = Color3.fromRGB(10, 10, 12),
	Rim = Color3.fromRGB(70, 110, 30),
	Tick = Color3.fromRGB(240, 240, 240),
	MinorTick = Color3.fromRGB(150, 200, 40),
	Number = Color3.fromRGB(255, 255, 255),
	Needle = Color3.fromRGB(255, 50, 20),
	Hub = Color3.fromRGB(230, 200, 40), -- yellow centre point
	Redline = Color3.fromRGB(230, 40, 30),
}

type Gauge = {
	Frame: Frame,
	Pivot: Frame,
	Max: number,
	Value: number,
}

local player = Players.LocalPlayer
local gui: ScreenGui? = nil
local speedGauge: Gauge? = nil
local rpmGauge: Gauge? = nil
local readout: TextLabel? = nil
local stepConn: RBXScriptConnection? = nil
local charConns: { RBXScriptConnection } = {}

local function valueToAngle(value: number, max: number): number
	local frac = math.clamp(value / max, 0, 1)
	return -CONFIG.SweepDegrees / 2 + frac * CONFIG.SweepDegrees
end

-- Point on the dial at a given angle (0 = up, clockwise) and radius (0..0.5 of dial size).
local function polar(angleDeg: number, radius: number): UDim2
	local r = math.rad(angleDeg)
	return UDim2.fromScale(0.5 + math.sin(r) * radius, 0.5 - math.cos(r) * radius)
end

local function addTick(parent: Frame, angle: number, length: number, thickness: number, color: Color3)
	local tick = Instance.new("Frame")
	tick.AnchorPoint = Vector2.new(0.5, 0.5)
	tick.Size = UDim2.fromScale(thickness, length)
	tick.Position = polar(angle, 0.46 - length / 2)
	tick.Rotation = angle
	tick.BackgroundColor3 = color
	tick.BorderSizePixel = 0
	tick.Parent = parent
end

local function addNumber(parent: Frame, angle: number, text: string, color: Color3)
	local label = Instance.new("TextLabel")
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Size = UDim2.fromScale(0.18, 0.1)
	label.Position = polar(angle, 0.31)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.TextColor3 = color
	label.Text = text
	label.Parent = parent
end

local function makeGauge(parent: Instance, name: string, max: number, major: number, minor: number, unit: string, redline: number?): Gauge
	local face = Instance.new("Frame")
	face.Name = name
	face.BackgroundColor3 = COLORS.Face
	face.BorderSizePixel = 0
	face.Parent = parent
	Instance.new("UIAspectRatioConstraint").Parent = face
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.5, 0)
	corner.Parent = face
	local rim = Instance.new("UIStroke")
	rim.Color = COLORS.Rim
	rim.Thickness = 2
	rim.Parent = face

	-- Scale: minor ticks, major ticks, numbers
	local v = 0
	while v <= max + 1e-6 do
		local angle = valueToAngle(v, max)
		local isMajor = math.abs((v / major) - math.round(v / major)) < 1e-6
		local inRed = redline ~= nil and v >= redline
		if isMajor then
			addTick(face, angle, 0.09, 0.025, if inRed then COLORS.Redline else COLORS.Tick)
			addNumber(face, angle, tostring(math.round(v)), if inRed then COLORS.Redline else COLORS.Number)
		else
			addTick(face, angle, 0.05, 0.015, if inRed then COLORS.Redline else COLORS.MinorTick)
		end
		v += minor
	end

	local unitLabel = Instance.new("TextLabel")
	unitLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	unitLabel.Size = UDim2.fromScale(0.3, 0.07)
	unitLabel.Position = UDim2.fromScale(0.5, 0.72)
	unitLabel.BackgroundTransparency = 1
	unitLabel.Font = Enum.Font.Gotham
	unitLabel.TextScaled = true
	unitLabel.TextColor3 = COLORS.MinorTick
	unitLabel.Text = unit
	unitLabel.Parent = face

	-- Pivot: a transparent square centred exactly on the hub. Rotating it swings the needle.
	local pivot = Instance.new("Frame")
	pivot.Name = "Pivot"
	pivot.AnchorPoint = Vector2.new(0.5, 0.5)
	pivot.Position = UDim2.fromScale(0.5, 0.5)
	pivot.Size = UDim2.fromScale(0.84, 0.84) -- needle length = half of this
	pivot.BackgroundTransparency = 1
	pivot.Rotation = valueToAngle(0, max)
	pivot.Parent = face

	-- Needle: runs from the top edge of the pivot (tip) down to its centre (the hub).
	local needle = Instance.new("Frame")
	needle.Name = "Needle"
	needle.AnchorPoint = Vector2.new(0.5, 0)
	needle.Position = UDim2.fromScale(0.5, 0)
	needle.Size = UDim2.fromScale(0.035, 0.5)
	needle.BackgroundColor3 = COLORS.Needle
	needle.BorderSizePixel = 0
	needle.Parent = pivot
	local needleCorner = Instance.new("UICorner")
	needleCorner.CornerRadius = UDim.new(0.5, 0)
	needleCorner.Parent = needle

	-- Yellow hub drawn on top so the needle's base is hidden under it.
	local hub = Instance.new("Frame")
	hub.Name = "Hub"
	hub.AnchorPoint = Vector2.new(0.5, 0.5)
	hub.Position = UDim2.fromScale(0.5, 0.5)
	hub.Size = UDim2.fromScale(0.09, 0.09)
	hub.BackgroundColor3 = COLORS.Hub
	hub.BorderSizePixel = 0
	hub.ZIndex = 3
	hub.Parent = face
	local hubCorner = Instance.new("UICorner")
	hubCorner.CornerRadius = UDim.new(0.5, 0)
	hubCorner.Parent = hub

	return { Frame = face, Pivot = pivot, Max = max, Value = 0 }
end

local function buildGui()
	local screen = Instance.new("ScreenGui")
	screen.Name = "SpeedometerGui"
	screen.ResetOnSpawn = false
	screen.Enabled = false
	screen.IgnoreGuiInset = true

	-- Bottom centre, clear of the mobile thumbstick (left) and jump/drive buttons (right).
	local holder = Instance.new("Frame")
	holder.Name = "Holder"
	holder.AnchorPoint = Vector2.new(0.5, 1)
	holder.Position = UDim2.new(0.5, 0, 1, -12)
	holder.Size = UDim2.fromScale(0.36, 0.26)
	holder.BackgroundTransparency = 1
	holder.Parent = screen
	local ratio = Instance.new("UIAspectRatioConstraint")
	ratio.AspectRatio = 2.1
	ratio.Parent = holder
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	layout.Padding = UDim.new(0.03, 0)
	layout.Parent = holder

	local rpm = makeGauge(holder, "Rpm", CONFIG.MaxRpm, 1, 0.5, "RPM x1000", CONFIG.RedlineRpm)
	rpm.Frame.Size = UDim2.fromScale(0.4, 0.8)
	rpm.Frame.LayoutOrder = 1

	local speed = makeGauge(holder, "Speed", CONFIG.MaxMph, CONFIG.MphMajorStep, CONFIG.MphMinorStep, "mph", nil)
	speed.Frame.Size = UDim2.fromScale(0.5, 1)
	speed.Frame.LayoutOrder = 2

	local label = Instance.new("TextLabel")
	label.Name = "Readout"
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Size = UDim2.fromScale(0.4, 0.1)
	label.Position = UDim2.fromScale(0.5, 0.86)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Code
	label.TextScaled = true
	label.TextColor3 = COLORS.Tick
	label.Text = "0"
	label.Parent = speed.Frame

	screen.Parent = player:WaitForChild("PlayerGui")
	gui, speedGauge, rpmGauge, readout = screen, speed, rpm, label
end

-- Fake engine RPM from speed: climbs through each gear, drops on the shift.
local function rpmFromSpeed(mph: number, throttle: number): number
	local gearSpan = CONFIG.MaxMph / CONFIG.Gears
	local gearFrac = (mph % gearSpan) / gearSpan
	if mph >= CONFIG.MaxMph then
		gearFrac = 1
	end
	local base = CONFIG.IdleRpm + gearFrac * (CONFIG.RedlineRpm - CONFIG.IdleRpm)
	return base + math.abs(throttle) * 0.4
end

local function setNeedle(g: Gauge, target: number, dt: number)
	local alpha = 1 - math.exp(-CONFIG.NeedleSmoothing * dt)
	g.Value += (target - g.Value) * alpha
	g.Pivot.Rotation = valueToAngle(g.Value, g.Max)
end

local function stopDriving()
	if stepConn then
		stepConn:Disconnect()
		stepConn = nil
	end
	if gui then
		gui.Enabled = false
	end
	if speedGauge and rpmGauge then
		speedGauge.Value, rpmGauge.Value = 0, 0
		setNeedle(speedGauge, 0, 1)
		setNeedle(rpmGauge, 0, 1)
	end
end

local function startDriving(seat: VehicleSeat)
	stopDriving()
	if not (gui and speedGauge and rpmGauge and readout) then
		return
	end
	local speed, rpm, label = speedGauge, rpmGauge, readout
	gui.Enabled = true
	-- Light work only: one velocity read and three property writes per frame, only while seated.
	stepConn = RunService.RenderStepped:Connect(function(dt: number)
		if not seat.Parent then
			stopDriving()
			return
		end
		local forward = seat.CFrame.LookVector
		local mph = math.abs(seat.AssemblyLinearVelocity:Dot(forward)) * CONFIG.StudsPerSecToMph
		setNeedle(speed, mph, dt)
		setNeedle(rpm, rpmFromSpeed(mph, seat.ThrottleFloat), dt)
		label.Text = string.format("%d", math.round(mph))
	end)
end

local function onCharacter(character: Model)
	for _, c in charConns do
		c:Disconnect()
	end
	table.clear(charConns)
	stopDriving()

	local humanoid = character:WaitForChild("Humanoid", 10) :: Humanoid?
	if not humanoid then
		return
	end
	table.insert(charConns, humanoid.Seated:Connect(function(active: boolean, seatPart: BasePart?)
		if active and seatPart and seatPart:IsA("VehicleSeat") then
			startDriving(seatPart)
		else
			stopDriving()
		end
	end))
	table.insert(charConns, humanoid.Died:Connect(stopDriving))
end

function SpeedometerController.Init()
	buildGui()
end

function SpeedometerController.Start()
	if player.Character then
		task.spawn(onCharacter, player.Character)
	end
	player.CharacterAdded:Connect(onCharacter)
end

return SpeedometerController

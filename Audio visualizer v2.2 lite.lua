local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local Sound = Instance.new("Sound")
Sound.Parent = root
Sound.Volume = 3
Sound.Looped = false
Sound.RollOffMode = Enum.RollOffMode.Inverse
Sound.PlayOnRemove = false

local startSound = Instance.new("Sound")
startSound.Parent = root
startSound.SoundId = "rbxassetid://2547598538"
startSound.Volume = 2
startSound.Looped = false
startSound.RollOffMode = Enum.RollOffMode.Inverse
startSound.PlayOnRemove = false

local gui = Instance.new("ScreenGui")
gui.Name = "MusicGui"
gui.Parent = player.PlayerGui

local main = Instance.new("Frame")
main.Parent = gui
main.BackgroundColor3 = Color3.new(0,0,0)
main.BackgroundTransparency = 0.35
main.BorderSizePixel = 5
main.Position = UDim2.new(-0.4,0,0.35,0)
main.Size = UDim2.new(0.25,0,0.35,0)

local openBtn = Instance.new("TextButton")
openBtn.Parent = gui
openBtn.Position = UDim2.new(0,0,0.35,0)
openBtn.Size = UDim2.new(0.02,0,0.3,0)
openBtn.Text = ">"

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = main
closeBtn.Position = UDim2.new(0.95,0,0,0)
closeBtn.Size = UDim2.new(0.05,0,1,0)
closeBtn.Text = "<"

local idBox = Instance.new("TextBox")
idBox.Parent = main
idBox.Position = UDim2.new(0.1,0,0.25,0)
idBox.Size = UDim2.new(0.7,0,0.1,0)
idBox.Text = "ID"

local play = Instance.new("TextButton")
play.Parent = main
play.Position = UDim2.new(0.82,0,0.25,0)
play.Size = UDim2.new(0.1,0,0.1,0)
play.Text = "Play"

local pause = Instance.new("TextButton")
pause.Parent = main
pause.Position = UDim2.new(0.425,0,0.7,0)
pause.Size = UDim2.new(0.1,0,0.1,0)
pause.Text = "Pause"

local resume = Instance.new("TextButton")
resume.Parent = main
resume.Position = UDim2.new(0.55,0,0.7,0)
resume.Size = UDim2.new(0.1,0,0.1,0)
resume.Text = "Play"

local volText = Instance.new("TextLabel")
volText.Parent = main
volText.Position = UDim2.new(0.7,0,0.7,0)
volText.Size = UDim2.new(0.1,0,0.1,0)
volText.Text = "3"

local volUp = Instance.new("TextButton")
volUp.Parent = main
volUp.Position = UDim2.new(0.8,0,0.7,0)
volUp.Size = UDim2.new(0.05,0,0.1,0)
volUp.Text = "+"

local volDown = Instance.new("TextButton")
volDown.Parent = main
volDown.Position = UDim2.new(0.675,0,0.7,0)
volDown.Size = UDim2.new(0.05,0,0.1,0)
volDown.Text = "-"

local function tween(o,p,t)
	TweenService:Create(o,TweenInfo.new(t,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=p}):Play()
end

openBtn.MouseButton1Click:Connect(function()
	tween(main,UDim2.new(0,0,0.35,0),1)
	tween(openBtn,UDim2.new(-0.2,0,0.35,0),1)
end)

closeBtn.MouseButton1Click:Connect(function()
	tween(main,UDim2.new(-0.4,0,0.35,0),1)
	tween(openBtn,UDim2.new(0,0,0.35,0),1)
end)

volUp.MouseButton1Click:Connect(function()
	Sound.Volume += 1
	startSound.Volume = Sound.Volume
	volText.Text = Sound.Volume
end)

volDown.MouseButton1Click:Connect(function()
	Sound.Volume = math.max(0,Sound.Volume-1)
	startSound.Volume = Sound.Volume
	volText.Text = Sound.Volume
end)

local COUNT = 45
local BASE_RADIUS = 6.2
local Bounce = 3.5
local PULSE_POWER = 3.5
local MAX_PULSE = 3.3
local SMOOTH = 0.33

local BASE_MESH_SCALE = Vector3.new(0.5,0.6,0.1)
local MAX_MESH_BOOST = 1.6
local MESH_SMOOTH = 0.35

local parts = {}
local meshes = {}
local currentRadius = BASE_RADIUS
local rainbow = false
local hue = 0
local hidden = false

for i = 1, COUNT do
	local p = Instance.new("Part")
	p.Anchored = true
	p.CanCollide = false
	p.Material = Enum.Material.Neon
	p.Color = Color3.new(1,1,1)
	p.Size = Vector3.new(0.1,0.1,0.1)
	p.Parent = workspace

	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = "rbxassetid://9756362"
	mesh.Scale = BASE_MESH_SCALE
	mesh.Parent = p

	local light = Instance.new("PointLight")
	light.Range = 3.3
	light.Brightness = 2
	light.Color = Color3.new(1,1,1)
	light.Parent = p

	table.insert(parts,p)
	table.insert(meshes,mesh)
end

local function setWhite(show)
	for _,p in ipairs(parts) do
		p.Color = Color3.new(1,1,1)
		p.PointLight.Color = Color3.new(1,1,1)
		p.Transparency = show and 0 or 1
	end
	hidden = not show
end

local function enableRainbow()
	rainbow = true
	hidden = false
end

local function disableRainbow()
	rainbow = false
	setWhite(true)
end

startSound.Loaded:Wait()
startSound:Play()
enableRainbow()

startSound.Ended:Connect(function()
	disableRainbow()
end)

play.MouseButton1Click:Connect(function()
	local id = tonumber(idBox.Text)
	if id then
		Sound:Stop()
		Sound.SoundId = "rbxassetid://"..id
		Sound.TimePosition = 0
		Sound.Loaded:Wait()
		Sound:Play()
		enableRainbow()
	end
end)

pause.MouseButton1Click:Connect(function()
	if Sound.IsPlaying then
		Sound:Pause()
	end
	disableRainbow()
end)

resume.MouseButton1Click:Connect(function()
	if Sound.TimePosition > 0 then
		Sound:Resume()
		enableRainbow()
	end
end)

Sound.Ended:Connect(function()
	disableRainbow()
end)

RunService.RenderStepped:Connect(function(dt)
	if hidden then return end

	local loudness = 0
	if Sound.IsPlaying then
		loudness = Sound.PlaybackLoudness
	elseif startSound.IsPlaying then
		loudness = startSound.PlaybackLoudness
	end

	local pulse = math.clamp(loudness / 420,0,MAX_PULSE)
	local target = BASE_RADIUS + pulse * PULSE_POWER * Bounce
	currentRadius += (target - currentRadius) * SMOOTH

	if rainbow then
		hue = (hue + dt*0.45) % 1
	end

	local meshPulse = math.clamp(loudness / 350,0,MAX_MESH_BOOST)

	for i,p in ipairs(parts) do
		local a = (i / COUNT) * math.pi * 2
		local offset = Vector3.new(math.cos(a)*currentRadius,0,math.sin(a)*currentRadius)
		p.CFrame = CFrame.new(root.Position + offset, root.Position)

		local targetScale = BASE_MESH_SCALE * (1 + meshPulse)
		meshes[i].Scale = meshes[i].Scale:Lerp(targetScale, MESH_SMOOTH)

		if rainbow then
			local c = Color3.fromHSV((hue + i/COUNT)%1,1,1)
			p.Color = c
			p.PointLight.Color = c
		end
	end
end)

player.CharacterAdded:Connect(function()
	Sound:Stop()
	startSound:Stop()
	for _,p in ipairs(parts) do
		p:Destroy()
	end
end)
-- Audio visual v2.2 lite Remake by Noobd0lan

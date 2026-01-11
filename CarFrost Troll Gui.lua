--!strict
local CarFrost = loadstring(game:HttpGet("https://raw.githubusercontent.com/Minh1234ngudot/OhioSigma-UI/refs/heads/main/CarFrost%20UI"))()

-- Create Main Window
local CarFrostWindow = CarFrost:CreateWindow({
	Name = "CarFrost Troll GUI",
	KeySystem = false -- Key system disabled
})

-- Create Tab
local mainTab = CarFrostWindow:CreateTab("Main")
local trollTab = CarFrostWindow:CreateTab("Troll")
local musicTab = CarFrostWindow:CreateTab("Music")

-- Utility
local Players, RunService, UserInputService = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService")
local lp = Players.LocalPlayer

local function getHumanoid()
	local char = lp.Character
	return char and char:FindFirstChildOfClass("Humanoid")
end

-- WalkSpeed
local walkSpeedValue, walkSpeedEnabled = 16, false
CarFrost:CreateToggleButton(mainTab, "Enable WalkSpeed", function(state)
	walkSpeedEnabled = state
	local hum = getHumanoid()
	if hum then hum.WalkSpeed = state and walkSpeedValue or 16 end
end)
CarFrost:CreateSlider(mainTab, "WalkSpeed", 0, 250, 16, function(value)
	walkSpeedValue = value
	if walkSpeedEnabled then
		local hum = getHumanoid()
		if hum then hum.WalkSpeed = value end
	end
end)

-- JumpPower
local jumpPowerValue, jumpPowerEnabled = 50, false
CarFrost:CreateToggleButton(mainTab, "Enable JumpPower", function(state)
	jumpPowerEnabled = state
	local hum = getHumanoid()
	if hum then hum.JumpPower = state and jumpPowerValue or 50 end
end)
CarFrost:CreateSlider(mainTab, "JumpPower", 0, 500, 50, function(value)
	jumpPowerValue = value
	if jumpPowerEnabled then
		local hum = getHumanoid()
		if hum then hum.JumpPower = value end
	end
end)

-- Fly
local flySpeed, flyEnabled = 50, false
local flyController = nil
CarFrost:CreateToggleButton(mainTab, "Enable Fly", function(state)
	flyEnabled = state

	local character = lp.Character or lp.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	if flyController then pcall(flyController.stop) flyController = nil end

	if state then
		local bg = Instance.new("BodyGyro", hrp)
		bg.P = 9e4
		bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.CFrame = hrp.CFrame

		local bv = Instance.new("BodyVelocity", hrp)
		bv.Velocity = Vector3.zero
		bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)

		local flying = true

		local function flyLoop()
			while flying and bv and bg do
				local cam = workspace.CurrentCamera
				local move = Vector3.zero
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
				bv.Velocity = move.Magnitude > 0 and move.Unit * flySpeed or Vector3.zero
				bg.CFrame = cam.CFrame
				RunService.RenderStepped:Wait()
			end
		end

		flyController = {
			stop = function()
				flying = false
				bg:Destroy()
				bv:Destroy()
			end
		}
		task.spawn(flyLoop)
	end
end)
CarFrost:CreateSlider(mainTab, "Fly Speed", 0, 500, 50, function(value)
	flySpeed = value
end)

-- Noclip
local noclipEnabled = false
CarFrost:CreateToggleButton(mainTab, "Enable Noclip", function(state)
	noclipEnabled = state
end)
RunService.Stepped:Connect(function()
	if noclipEnabled then
		local char = lp.Character
		if char then
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end
end)

-- Infinity Jump
local ijump = false
CarFrost:CreateToggleButton(mainTab, "Enable Infinity Jump", function(state)
	ijump = state
end)
UserInputService.JumpRequest:Connect(function()
	if ijump then
		local char = lp.Character
		if char and char:FindFirstChildOfClass("Humanoid") then
			char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
		end
	end
end)

-- Utility: Get All Player Characters
local Players = game:GetService("Players")

local function getPlayerCharacters()
	local chars = {}
	for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
		if plr.Character then
			table.insert(chars, plr.Character)
		end
	end
	return chars
end

CarFrost:CreateButton(trollTab, "Kill All", function()
	for _, player in pairs(game.Players:GetPlayers()) do
		local character = player.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.Health = 0
			end
		end
	end
end)

-- Toggle: Set Custom Sky
CarFrost:CreateToggleButton(trollTab, "Set Sky", function(state)
	local lighting = game:GetService("Lighting")
	for _, v in pairs(lighting:GetChildren()) do
		if v:IsA("Sky") then v:Destroy() end
	end
	if state then
		local sky = Instance.new("Sky")
		sky.SkyboxBk = "rbxthumb://type=Avatar&id=8705840973&w=420&h=420"
		sky.SkyboxDn, sky.SkyboxFt, sky.SkyboxLf = sky.SkyboxBk, sky.SkyboxBk, sky.SkyboxBk
		sky.SkyboxRt, sky.SkyboxUp = sky.SkyboxBk, sky.SkyboxBk
		sky.Name = "SkibidiSky"
		sky.Parent = lighting
	end
end)

CarFrost:CreateButton(trollTab, "Kick All", function()
	for _, player in pairs(Players:GetPlayers()) do
		player:Kick()
	end
end)

-- Toggle: Music
local music = Instance.new("Sound", workspace)
music.Name = "CarFrostMusic"
music.SoundId = "rbxassetid://118939739460633"
music.Looped = true
music.Volume = 1

CarFrost:CreateToggleButton(trollTab, "Music", function(state)
	if state then music:Play() else music:Stop() end
end)

-- Button: Explode All Players
CarFrost:CreateButton(trollTab, "Explode All", function()
	for _, char in ipairs(getPlayerCharacters()) do
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			local ex = Instance.new("Explosion")
			ex.Position, ex.BlastRadius, ex.BlastPressure = hrp.Position, 10, 500000
			ex.Parent = workspace
		end
	end
end)

-- Toggle: Fire Effect on All Players
CarFrost:CreateToggleButton(trollTab, "Fire All", function(state)
	for _, char in ipairs(getPlayerCharacters()) do
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			if state then
				if not hrp:FindFirstChildOfClass("Fire") then
					local fire = Instance.new("Fire")
					fire.Size, fire.Heat = 100, 50
					fire.Parent = hrp
				end
			else
				for _, obj in ipairs(hrp:GetChildren()) do
					if obj:IsA("Fire") then obj:Destroy() end
				end
			end
		end
	end
end)

-- Button: Show Notification
CarFrost:CreateButton(trollTab, "Show Notification", function()
	local notif = Instance.new("TextLabel")
	notif.Name = "NotificationLabel"
	notif.Size = UDim2.new(0, 360, 0, 70)
	notif.Position = UDim2.new(0.5, 0, 0.05, 0)
	notif.AnchorPoint = Vector2.new(0.5, 0)
	notif.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	notif.BackgroundTransparency = 0.15
	notif.Text = "Team CarFrost Join Today!"
	notif.Font = Enum.Font.GothamBlack
	notif.TextSize, notif.TextColor3 = 24, Color3.new(1,1,1)
	notif.TextStrokeTransparency, notif.TextStrokeColor3 = 0.65, Color3.new(0,0,0)
	notif.TextWrapped, notif.ZIndex = true, 10000
	notif.ClipsDescendants = true
	notif.Parent = CarFrostWindow._screenGui

	Instance.new("UICorner", notif).CornerRadius = UDim.new(0,12)
	local grad = Instance.new("UIGradient", notif)
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,255))
	}

	local tweenService = game:GetService("TweenService")
	notif.TextTransparency, notif.BackgroundTransparency = 1, 1
	tweenService:Create(notif, TweenInfo.new(0.3), {
		TextTransparency = 0, BackgroundTransparency = 0.15
	}):Play()

	task.delay(3, function()
		if notif then
			tweenService:Create(notif, TweenInfo.new(0.5), {
				TextTransparency = 1, BackgroundTransparency = 1
			}):Play()
			task.wait(0.5)
			notif:Destroy()
		end
	end)
end)

-- Toggle: Freeze All Players
CarFrost:CreateToggleButton(trollTab, "Freeze All", function(state)
	for _, char in ipairs(getPlayerCharacters()) do
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then hrp.Anchored = state end
	end
end)

-- Button: Summon Baseplate
CarFrost:CreateButton(trollTab, "Create Baseplate", function()
	local char = game.Players.LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local base = Instance.new("Part")
		base.Name, base.Anchored, base.Size = "SummonedBaseplate", true, Vector3.new(1000,10,1000)
		base.Position = char.HumanoidRootPart.Position - Vector3.new(0, char.HumanoidRootPart.Size.Y/2 + 5, 0)
		base.Color, base.Material = Color3.fromRGB(80,80,80), Enum.Material.Concrete
		base.Parent = workspace
	end
end)

-- Button: Ohio Mode (Big Size)
CarFrost:CreateButton(trollTab, "Ohio Mode", function()
	local char = game.Players.LocalPlayer.Character
	if char and char:FindFirstChild("Humanoid") then
		for _, part in ipairs(char:GetChildren()) do
			if part:IsA("BasePart") then part.Size = part.Size * 4 end
		end
		char.Humanoid.HipHeight *= 4
	end
end)

-- Button: Launch Player to Sky
CarFrost:CreateButton(trollTab, "Launch Sky", function()
	local char = game.Players.LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local bv = Instance.new("BodyVelocity")
		bv.Velocity, bv.MaxForce, bv.P = Vector3.new(0,1000,0), Vector3.new(0,math.huge,0), 10000
		bv.Parent = char.HumanoidRootPart
		game.Debris:AddItem(bv,1.5)
	end
end)

-- Toggle: Invisibility (Player)
CarFrost:CreateToggleButton(trollTab, "Invisibility", function(state)
	local char = game.Players.LocalPlayer.Character
	if char then
		for _, obj in ipairs(char:GetDescendants()) do
			if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
				obj.Transparency = state and 1 or 0
			elseif obj:IsA("Decal") then
				obj.Transparency = state and 1 or 0
			end
		end
	end
end)

-- Toggle: Rain Bombs
local raining = false
local bombFolder = Instance.new("Folder", workspace)
bombFolder.Name = "RainBombFolder"

local function spawnBomb()
	local bomb = Instance.new("Part")
	bomb.Size, bomb.Shape, bomb.Material = Vector3.new(1.5,1.5,1.5), Enum.PartType.Ball, Enum.Material.Neon
	bomb.Color = Color3.fromRGB(255,50,50)
	bomb.Position = Vector3.new(math.random(-100,100),100,math.random(-100,100))
	bomb.Anchored, bomb.CanCollide, bomb.Name = false,true,"RainBomb"
	bomb:SetAttribute("Exploded", false)
	bomb.Parent = bombFolder

	bomb.Touched:Connect(function(hit)
		if bomb:GetAttribute("Exploded") then return end
		local hum = hit.Parent:FindFirstChildOfClass("Humanoid")
		if hum then hum.Health = 0 end
		bomb:SetAttribute("Exploded", true)
		local ex = Instance.new("Explosion")
		ex.Position, ex.BlastRadius, ex.BlastPressure = bomb.Position,8,500000
		ex.Parent = workspace
		bomb:Destroy()
	end)
end

CarFrost:CreateToggleButton(trollTab, "Rain Bomb", function(state)
	raining = state
	if raining then
		task.spawn(function()
			while raining do spawnBomb() task.wait(0.25) end
		end)
	else
		for _, b in ipairs(bombFolder:GetChildren()) do b:Destroy() end
	end
end)

-- Toggle: Spin All Players
local spinning, spinConnections = false, {}

CarFrost:CreateToggleButton(trollTab, "Spin All", function(state)
	spinning = state
	if spinning then
		for _, char in ipairs(getPlayerCharacters()) do
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if hrp then
				local conn; conn = game:GetService("RunService").Heartbeat:Connect(function()
					if hrp.Parent then
						hrp.CFrame *= CFrame.Angles(0, math.rad(20), 0)
					else conn:Disconnect() end
				end)
				spinConnections[char] = conn
			end
		end
	else
		for _, c in pairs(spinConnections) do c:Disconnect() end
		spinConnections = {}
	end
end)

-- Toggle: Clownify Faces
CarFrost:CreateToggleButton(trollTab, "Clownify All", function(state)
	for _, char in ipairs(getPlayerCharacters()) do
		local head = char:FindFirstChild("Head")
		if head then
			local face = head:FindFirstChild("face")
			if face then face:Destroy() end
			local newFace = Instance.new("Decal")
			newFace.Name, newFace.Face = "face", Enum.NormalId.Front
			newFace.Texture = state and "rbxassetid://74403105687374" or "rbxasset://textures/face.png"
			newFace.Parent = head
		end
	end
end)

-- Button: Black Hole (Gravity + Explosion)
CarFrost:CreateButton(trollTab, "Black Hole", function()
	local char = game.Players.LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local hole = Instance.new("Part")
	hole.Anchored, hole.CanCollide = true, false
	hole.Shape, hole.Size, hole.Position = Enum.PartType.Ball, Vector3.new(20,20,20), hrp.Position
	hole.Color, hole.Material = Color3.new(0,0,0), Enum.Material.Neon
	hole.Name, hole.Parent = "BlackHole", workspace

	local sfx = Instance.new("Sound", hole)
	sfx.SoundId, sfx.Looped, sfx.Volume = "rbxassetid://138186576", true, 3
	sfx:Play()

	local life, t = 6, 0
	local conn; conn = game:GetService("RunService").Heartbeat:Connect(function(dt)
		t += dt
		for _, char in ipairs(getPlayerCharacters()) do
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if hrp then
				local dir = (hole.Position - hrp.Position).Unit
				if (hole.Position - hrp.Position).Magnitude < 100 then
					hrp.Velocity = dir * 50
				end
			end
		end
		if t > life - 2 then hole.Size -= Vector3.new(0.5,0.5,0.5) end
		if t >= life then
			conn:Disconnect()
			local ex = Instance.new("Explosion")
			ex.Position, ex.BlastRadius, ex.BlastPressure = hole.Position,30,100000
			ex.Parent = workspace
			sfx:Stop() hole:Destroy()
		end
	end)
end)

-- Button: Lightning Strike
CarFrost:CreateButton(trollTab, "Lightning Strike", function()
	for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
		local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local bolt = Instance.new("Part")
			bolt.Size, bolt.Position = Vector3.new(1,20,1), hrp.Position + Vector3.new(0,20,0)
			bolt.Anchored, bolt.Material, bolt.BrickColor = true, Enum.Material.Neon, BrickColor.new("New Yeller")
			bolt.Parent = workspace

			local ex = Instance.new("Explosion")
			ex.Position, ex.BlastRadius, ex.BlastPressure = hrp.Position,5,100000
			ex.Parent = workspace

			game:GetService("Debris"):AddItem(bolt,0.2)
		end
	end
end)

-- Toggle: Gravity Flip
CarFrost:CreateToggleButton(trollTab, "Gravity Flip", function(state)
	workspace.Gravity = state and -196 or 196
end)

-- Toggle: Trap All Players
local trapFolder = Instance.new("Folder", workspace)
trapFolder.Name = "PlayerTraps"

CarFrost:CreateToggleButton(trollTab, "Trap All", function(state)
	if state then
		for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
			local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				local trap = Instance.new("Part")
				trap.Size, trap.Position = Vector3.new(10,20,10), hrp.Position + Vector3.new(0,10,0)
				trap.Anchored, trap.BrickColor, trap.Material, trap.CanCollide = true, BrickColor.new("Bright red"), Enum.Material.ForceField, true
				trap.Parent = trapFolder
			end
		end
	else
		for _, trap in ipairs(trapFolder:GetChildren()) do trap:Destroy() end
	end
end)

-- Toggle: Shrink All Players
CarFrost:CreateToggleButton(trollTab, "Shrink All", function(state)
	for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
		if plr.Character then
			plr.Character:SetPrimaryPartCFrame(plr.Character:GetPrimaryPartCFrame())
			plr.Character:ScaleTo(state and 0.4 or 1)
		end
	end
end)

CarFrost:CreateToggleButton(trollTab, "Decal Spam", function(state)
	local decalId = "rbxthumb://type=Avatar&id=8705840973&w=420&h=420"
	local faces = {
		Enum.NormalId.Front,
		Enum.NormalId.Back,
		Enum.NormalId.Left,
		Enum.NormalId.Right,
		Enum.NormalId.Top,
		Enum.NormalId.Bottom
	}
	if state then
		for _, part in ipairs(workspace:GetDescendants()) do
			if part:IsA("BasePart") then
				for _, face in ipairs(faces) do
					local decal = Instance.new("Decal")
					decal.Texture = decalId
					decal.Face = face
					decal.Name = "CarFrostDecal"
					decal.Parent = part
				end
			end
		end
	else
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("Decal") and obj.Name == "CarFrostDecal" then
				obj:Destroy()
			end
		end
	end
end)

CarFrost:CreateButton(trollTab, "Jumpscare", function()
	local player = game.Players.LocalPlayer
	local screenGui = Instance.new("ScreenGui")
	screenGui.Parent = player:WaitForChild("PlayerGui")

	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(1, 0, 1, 0)
	imageLabel.Position = UDim2.new(0, 0, 0, 0)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = "rbxthumb://type=Avatar&id=8705840973&w=420&h=420"
	imageLabel.Parent = screenGui

	-- Xoá GUI sau vài giây
	task.delay(3, function()
		screenGui:Destroy()
	end)
end)

local function playMusicAll(state)
    for _, plr in ipairs(game.Players:GetPlayers()) do
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local existing = hrp:FindFirstChild("CarFrostMusic")

            if state then
                if not existing then
                    local sound = Instance.new("Sound")
                    sound.Name = "CarFrostMusic"
                    sound.SoundId = "rbxassetid://142376088"
                    sound.Looped = true
                    sound.Volume = 10
                    sound.Parent = hrp
                    sound:Play()
                end
            else
                if existing then existing:Destroy() end
            end
        end
    end
end

CarFrost:CreateToggleButton(musicTab, "Raining Tacos", function(state)
    playMusicAll(state)
end)

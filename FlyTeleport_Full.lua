
-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Player & Character
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- GUI Root
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyTeleportUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- State
local flying = false
local speed = 100
local verticalVelocity = 0
local flyConnection = nil
local trail = nil
local teleportOpen = false

-- Color Palette
local colors = {
	Color3.fromRGB(255,85,85),
	Color3.fromRGB(85,170,255),
	Color3.fromRGB(85,255,127),
	Color3.fromRGB(255,170,0),
	Color3.fromRGB(255,255,85),
	Color3.fromRGB(170,85,255),
	Color3.fromRGB(0,255,255),
}

-- Helper: Draggable
local function makeDraggable(frame)
	local dragging, dragInput, startPos, inputStart
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragInput = input
			inputStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - inputStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- Helper: Click Animation
local function applyClickEffect(button)
	button.MouseButton1Click:Connect(function()
		button.BackgroundTransparency = 0.5
		wait(0.1)
		button.BackgroundTransparency = 0
	end)
end

-- Create Button
local function createButton(name, text, pos, color)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0, 100, 0, 40)
	btn.Position = pos
	btn.Text = text
	btn.BackgroundColor3 = color or Color3.fromRGB(50, 50, 200)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextScaled = true
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = true
	btn.Active = true
	btn.AnchorPoint = Vector2.new(0.5, 0.5)
	btn.BackgroundTransparency = 0
	btn.ClipsDescendants = false
	btn.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn

	makeDraggable(btn)
	applyClickEffect(btn)

	return btn
end

-- Trail Setup
local function createTrail()
	if trail then trail:Destroy() end
	trail = Instance.new("Trail")
	trail.Color = ColorSequence.new(Color3.new(1, 1, 0), Color3.new(1, 0, 0))
	trail.Lifetime = 0.4
	local att0 = Instance.new("Attachment", hrp)
	local att1 = Instance.new("Attachment", hrp)
	att1.Position = Vector3.new(0, 0, 2)
	trail.Attachment0 = att0
	trail.Attachment1 = att1
	trail.Parent = hrp
end

-- Toggle Flight
local function toggleFly()
	flying = not flying
	humanoid.PlatformStand = flying
	if flying then
		verticalVelocity = 0
		createTrail()
		if flyConnection then flyConnection:Disconnect() flyConnection = nil end

		flyConnection = RunService.RenderStepped:Connect(function()
			local controlModule = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()
			local moveVector = controlModule:GetMoveVector()

			if moveVector.Magnitude > 0 then
				local cam = workspace.CurrentCamera
				local camCFrame = cam.CFrame
				local forward = Vector3.new(camCFrame.LookVector.X, 0, camCFrame.LookVector.Z).Unit
				local right = Vector3.new(camCFrame.RightVector.X, 0, camCFrame.RightVector.Z).Unit
				local direction = (forward * (-moveVector.Z) + right * moveVector.X).Unit * speed
				hrp.Velocity = Vector3.new(direction.X, verticalVelocity, direction.Z)
			else
				hrp.Velocity = Vector3.new(0, verticalVelocity, 0)
			end
		end)
	else
		if flyConnection then flyConnection:Disconnect() flyConnection = nil end
		hrp.Velocity = Vector3.zero
	end
end

-- (中略：與之前相同 UI 建立和速度輸入)

-- 修改後的傳送列表按鈕建立內部，額外支援長按持續傳送
-- 插入於 btn.MouseButton1Click 之後
btn.MouseButton1Click:Connect(function()
	if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
		hrp.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(2, 2, 2)
	end
end)

local teleporting = false
local teleportLoop
btn.MouseButton1Down:Connect(function()
	teleporting = true
	teleportLoop = coroutine.create(function()
		while teleporting do
			if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				hrp.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(2, 2, 2)
			end
			wait(0.2)
		end
	end)
	coroutine.resume(teleportLoop)
end)
btn.MouseButton1Up:Connect(function()
	teleporting = false
end)

-- CharacterAdded: 飛行功能重啟
player.CharacterAdded:Connect(function(char)
	character = char
	hrp = character:WaitForChild("HumanoidRootPart")
	humanoid = character:WaitForChild("Humanoid")

	if flying then
		humanoid.PlatformStand = true
		createTrail()
	end
end)

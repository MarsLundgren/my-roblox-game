-- Client: a coin counter on screen, plus spinning/bobbing animation for coins.
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Config = require(ReplicatedStorage.Shared.Config)

local player = Players.LocalPlayer

-- HUD ----------------------------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "CoinDashHud"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local label = Instance.new("TextLabel")
label.AnchorPoint = Vector2.new(0.5, 0)
label.Position = UDim2.new(0.5, 0, 0, 16)
label.Size = UDim2.fromOffset(220, 50)
label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
label.BackgroundTransparency = 0.3
label.TextColor3 = Color3.fromRGB(255, 220, 60)
label.Font = Enum.Font.FredokaOne
label.TextSize = 30
label.Text = "Coins: 0"
label.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = label

local scale = Instance.new("UIScale")
scale.Parent = label

local coins = player:WaitForChild("leaderstats"):WaitForChild("Coins")

local function updateLabel()
	label.Text = `Coins: {coins.Value}`
	-- Little "pop" each time the number changes.
	scale.Scale = 1.25
	TweenService:Create(scale, TweenInfo.new(0.25, Enum.EasingStyle.Back), { Scale = 1 }):Play()
end

coins.Changed:Connect(updateLabel)

-- Coin animation -----------------------------------------------------------
-- Coins are anchored on the server; we only move them locally for looks.
-- Touch detection still happens on the server at the coin's original spot.

local animated: { [BasePart]: Vector3 } = {}

local function track(instance: Instance)
	if instance:IsA("BasePart") then
		animated[instance] = instance.Position
	end
end

CollectionService:GetInstanceAddedSignal(Config.COIN_TAG):Connect(track)
CollectionService:GetInstanceRemovedSignal(Config.COIN_TAG):Connect(function(instance)
	animated[instance :: BasePart] = nil
end)
for _, instance in CollectionService:GetTagged(Config.COIN_TAG) do
	track(instance)
end

RunService.RenderStepped:Connect(function()
	local t = os.clock()
	for part, origin in animated do
		local bob = Vector3.new(0, math.sin(t * 2) * 0.5, 0)
		part.CFrame = CFrame.new(origin + bob) * CFrame.Angles(0, t * 3, 0)
	end
end)

-- Spawns coins, awards points on touch, and keeps the coin count topped up.
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Config = require(ReplicatedStorage.Shared.Config)

local CoinService = {}

local rng = Random.new()
local coinsFolder: Folder

local function randomPosition(): Vector3
	local half = Config.ARENA_SIZE / 2 - 4 -- stay clear of the edges
	return Vector3.new(rng:NextNumber(-half, half), Config.COIN_HEIGHT, rng:NextNumber(-half, half))
end

local function award(player: Player, amount: number)
	local leaderstats = player:FindFirstChild("leaderstats")
	local coins = leaderstats and leaderstats:FindFirstChild("Coins")
	if coins then
		coins.Value += amount
	end
end

local function spawnCoin()
	local isGold = rng:NextNumber() < Config.GOLD_CHANCE

	local coin = Instance.new("Part")
	coin.Name = if isGold then "GoldCoin" else "Coin"
	coin.Shape = Enum.PartType.Cylinder -- axis runs along X, so it stands up like a coin
	coin.Size = Vector3.new(0.4, 3, 3)
	coin.Anchored = true
	coin.CanCollide = false
	coin.Material = Enum.Material.Neon
	coin.Color = if isGold then Color3.fromRGB(255, 200, 0) else Color3.fromRGB(255, 240, 120)
	coin.Position = randomPosition()
	coin:SetAttribute("Value", if isGold then Config.GOLD_VALUE else Config.COIN_VALUE)

	local collected = false
	coin.Touched:Connect(function(hit)
		if collected then
			return
		end
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		if not player then
			return
		end

		collected = true
		award(player, coin:GetAttribute("Value"))
		coin:Destroy()

		task.delay(Config.RESPAWN_DELAY, spawnCoin)
	end)

	CollectionService:AddTag(coin, Config.COIN_TAG)
	coin.Parent = coinsFolder
end

local function setUpLeaderstats(player: Player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats" -- Roblox shows this folder's values on the player list

	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = 0
	coins.Parent = leaderstats

	leaderstats.Parent = player
end

function CoinService.start()
	coinsFolder = Instance.new("Folder")
	coinsFolder.Name = "Coins"
	coinsFolder.Parent = Workspace

	Players.PlayerAdded:Connect(setUpLeaderstats)
	for _, player in Players:GetPlayers() do
		setUpLeaderstats(player)
	end

	for _ = 1, Config.COIN_COUNT do
		spawnCoin()
	end
end

return CoinService

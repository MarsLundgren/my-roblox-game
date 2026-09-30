-- Builds the arena floor and spawn point, since the place file starts empty.
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)

local World = {}

function World.build()
	local floor = Instance.new("Part")
	floor.Name = "Floor"
	floor.Anchored = true
	floor.Size = Vector3.new(Config.ARENA_SIZE, 1, Config.ARENA_SIZE)
	floor.Position = Vector3.new(0, -0.5, 0) -- top surface sits at y = 0
	floor.Material = Enum.Material.Grass
	floor.Color = Color3.fromRGB(91, 154, 76)
	floor.Parent = Workspace

	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "Spawn"
	spawn.Anchored = true
	spawn.Position = Vector3.new(0, 0.5, 0)
	spawn.Parent = Workspace
end

return World

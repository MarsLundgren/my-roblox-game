-- Tunable numbers for Coin Dash. Shared so server and client agree.
return {
	ARENA_SIZE = 120, -- width/depth of the square floor, in studs
	COIN_COUNT = 30, -- coins alive at any time
	COIN_HEIGHT = 3, -- how high coins float above the floor
	COIN_VALUE = 1,
	GOLD_CHANCE = 0.1, -- chance a new coin is gold
	GOLD_VALUE = 5,
	RESPAWN_DELAY = 2, -- seconds before a collected coin is replaced
	COIN_TAG = "Coin", -- CollectionService tag the client uses to animate coins
}

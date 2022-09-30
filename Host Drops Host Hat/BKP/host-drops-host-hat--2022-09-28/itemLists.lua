local game = Game()
local ItemLists = {}

ItemLists.selfDamageActives = {
	CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK, -- 65
	CollectibleType.COLLECTIBLE_KAMIKAZE,           -- 40
}

ItemLists.actives = {
	CollectibleType.COLLECTIBLE_MR_BOOM,          -- 37
	CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD, -- 42
	CollectibleType.COLLECTIBLE_REMOTE_DETONATOR, -- 137
	CollectibleType.COLLECTIBLE_MAMA_MEGA,        -- 483
}

ItemLists.selfDamagePassives = {
	CollectibleType.COLLECTIBLE_DR_FETUS,           -- 52
	CollectibleType.COLLECTIBLE_EPIC_FETUS,         -- 168
	CollectibleType.COLLECTIBLE_CURSE_OF_THE_TOWER, -- 371
	CollectibleType.COLLECTIBLE_BOBS_BRAIN,         -- 273
	CollectibleType.COLLECTIBLE_NUMBER_TWO,         -- 378
	CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR,    -- 583
}

ItemLists.passives = {
	CollectibleType.COLLECTIBLE_BOBS_CURSE,      -- 140
	CollectibleType.COLLECTIBLE_BOOM,            -- 19
	CollectibleType.COLLECTIBLE_MR_MEGA,         -- 106

	CollectibleType.COLLECTIBLE_BLOOD_BOMBS,     -- 614
	CollectibleType.COLLECTIBLE_BOGO_BOMBS,      -- 250
	CollectibleType.COLLECTIBLE_BOMB_BAG,        -- 131
	CollectibleType.COLLECTIBLE_BOMBER_BOY,      -- 353
	CollectibleType.COLLECTIBLE_BRIMSTONE_BOMBS, -- 646
	CollectibleType.COLLECTIBLE_BUTT_BOMBS,      -- 209
	CollectibleType.COLLECTIBLE_FAST_BOMBS,      -- 517
	CollectibleType.COLLECTIBLE_GHOST_BOMBS,     -- 727
	CollectibleType.COLLECTIBLE_GLITTER_BOMBS,   -- 432
	CollectibleType.COLLECTIBLE_HOT_BOMBS,       -- 256
	CollectibleType.COLLECTIBLE_NANCY_BOMBS,     -- 563
	CollectibleType.COLLECTIBLE_SAD_BOMBS,       -- 220
	CollectibleType.COLLECTIBLE_SCATTER_BOMBS,   -- 366
	CollectibleType.COLLECTIBLE_STICKY_BOMBS,    -- 367
}

ItemLists.trinkets = {
	TrinketType.TRINKET_BLASTING_CAP,    -- 73
	TrinketType.TRINKET_MATCH_STICK,     -- 41
	TrinketType.TRINKET_RING_CAP,        -- 164
	TrinketType.TRINKET_SAFETY_SCISSORS, -- 63
	TrinketType.TRINKET_SHORT_FUSE,      -- 133
	TrinketType.TRINKET_BOBS_BLADDER,    -- 71
}

ItemLists.cards = {
	Card.CARD_TOWER, -- 17
}

--@todo: EID Support
ItemLists.eidCards = {
	[Card.CARD_TOWER] = {
		Name = "XVI - The Tower", -- @todo: UNUSED
		Desc = "+0.1% chance for Host to drop Host Hat"
	}
}

return ItemLists

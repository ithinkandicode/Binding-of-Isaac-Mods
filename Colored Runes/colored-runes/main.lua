local ColoredRunes = RegisterMod("Colored Runes", 1)
local game = Game()

function ColoredRunes:onUpdate()
	-- local player = Isaac.GetPlayer(0)
	-- local currentRoom = Game():GetRoom()

	--check for entities in the room
	for _, entity in pairs(Isaac.GetRoomEntities()) do
		-- local data = entity:GetData()
		local sprite = entity:GetSprite()

		-- Key/value: Entity ID/Animation filename
		local runesData = {
			[Card.RUNE_HAGALAZ] = "1-Hagalaz.anm2", -- 32
			[Card.RUNE_JERA]    = "2-Jera.anm2",    -- 33
			[Card.RUNE_EHWAZ]   = "3-Ehwaz.anm2",   -- 34
			[Card.RUNE_DAGAZ]   = "4-Dagaz.anm2",   -- 35
			[Card.RUNE_ANSUZ]   = "5-Ansuz.anm2",   -- 36
			[Card.RUNE_PERTHRO] = "6-Perthro.anm2", -- 37
			[Card.RUNE_BERKANO] = "7-Berkano.anm2", -- 38
			[Card.RUNE_ALGIZ]   = "8-Algiz.anm2",   -- 39
			-- Card.RUNE_BLANK -- 40 [unused]
			-- Card.RUNE_BLACK -- 41 [unused]
		}

		--[[
		EntityType.ENTITY_PICKUP = 5
		PickupVariant.PICKUP_TAROTCARD = 300 (also used by runes)
		entity.SubType: 32 - 39 ("Card" enum)
		]]

		-- Is rune?
		if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_TAROTCARD then

			for subType, anm2Filename in pairs( runesData ) do
				-- if the card entity matches the current ID (eg. Card.RUNE_HAGALAZ), AND the animation file hasn't been swapped yet...
				if entity.SubType == subType and sprite:GetFilename() ~= anm2Filename then -- 32
					if sprite:IsPlaying("Appear") then
						sprite:Load(anm2Filename, true)
						sprite:LoadGraphics()
						sprite:Play("Appear",true)
						sprite:Update()
					elseif sprite:IsPlaying("Idle") then
						sprite:Load(anm2Filename, true)
						sprite:LoadGraphics()
						sprite:Play("Idle",true)
						sprite:Update()
					end
				end
			end

			--[[
			-- Long-form example (1: Hagalaz)
			if entity.SubType == Card.RUNE_HAGALAZ and sprite:GetFilename() ~= "1-Hagalaz.anm2" then -- 32
				if sprite:IsPlaying("Appear") then
					sprite:Load("1-Hagalaz.anm2", true)
					sprite:LoadGraphics()
					sprite:Play("Appear",true)
					sprite:Update()
				elseif sprite:IsPlaying("Idle") then
					sprite:Load("1-Hagalaz.anm2", true)
					sprite:LoadGraphics()
					sprite:Play("Idle",true)
					sprite:Update()
				end
			end
			]]

		end

	end
end

ColoredRunes:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ColoredRunes.onUpdate)

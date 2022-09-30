-- EID Support

-- !! NOT IMPLEMENTED YET!

local game = Game()
local ItemLists = require("itemLists.lua") -- lists of items to loop over

if EID then
	local bonusInfo = {
		["65"] = {Name = "Anarchist Cookbook", Desc = "+2.5%"},
	}

	-- The descObj contains all informations about the currently described
	-- entity. It's passed automatically
	local function myModifierCondition(descObj)
		-- ObjType:    Always 5 for all collectibles
		-- ObjVariant: Items (active/passive) = 100 / Trinkets = 350 / Card = 300
		-- ObjSubType: Depends on the item (eg Host Hat is 375). See the enums in itemLists.lua

		-- COLLECTIBLE
		if ( descObj.ObjType == EntityType.ENTITY_PICKUP ) then -- 5
			-- ITEM
			if ( descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE ) then -- 100
				--Loop over items from itemLists.lua

			-- TRINKET
			elseif ( descObj.ObjVariant == PickupVariant.PICKUP_TRINKET ) then -- 350
				--Loop over items from itemLists.lua

			-- CARD
			elseif ( descObj.ObjVariant == PickupVariant.PICKUP_TAROTCARD ) then -- 300
				if ( descObj.ObjSubType == Card.CARD_TOWER ) --@todo: temp test
					return true
				end
			end
		end

		--[[
		--EXAMPLE
		--if entity is Sad onion returns true. This will execute the callback
		if ( descObj.ObjType == 5 and descObj.ObjVariant == 100 and descObj.ObjSubType == 1 ) then
			return true
		end
		]]
	end

	local function myModifierCallback(descObj)
		EID:appendToDescription(descObj, "#Host Hat Drop Chance: ")
		local itemSubType = descObj.ObjSubType
		-- itemSubType = tostring(itemSubType)
		-- local bonusDesc = trinketInfo[itemSubType].Desc

		local list = ItemLists[eidCards]
		local bonusDesc = list[itemSubType].Desc
		EID:appendToDescription(descObj, bonusDesc)

		return descObj
	end

	-- Register the modifier with a unique name
	EID:addDescriptionModifier("Host Drops Host Hat", myModifierCondition, myModifierCallback)
end

return EIDUpdates

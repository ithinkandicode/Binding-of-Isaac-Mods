local HDHH = RegisterMod("Host Drops Host Hat", 1)
local game = Game()
local ItemLists = require("itemLists.lua") -- lists of items to loop over
local json = require("json") -- needed for options save/load
-- local EIDUpdates = require("eidUpdates.lua") -- all EID stuff is handled in here

-- @todo: Only spawn ONCE?
-- @todo: Support for Mod Config Menu
-- @todo: Add EID bonus drop chances

-- host-drops-host-hat_2866530077

HDHH.CONFIG = {
	addItemBonus = true,  -- False if you don't want the bonus chance from items
	alwaysDrop   = false, -- Sets the drop chance to 100%, forcing the Host Hat to always drop
	debugLog     = true,  -- True to log to the debug console & log.txt
	debugNewLine = false, -- Add newline when loggin to debug console, fixes merged lines when using Quick Kill debug

	--@todo:
	onlySpawnOnce = false, -- Don't spawn if the player already has Host Hat
}

HDHH.MULTIPLIERS = {
	baseChance = 0.01,
	luckMulti  = 0.01,

	-- Bonuses for explosion-related items
	-- ESD = Explosive self-damage potential
	dmgActive  = 2.5, -- Actives ESD / Kamikaze, Anarchist Cookbook
	active     = 1.0, -- Actives     / Mr Boom, Bob's Rotten Head, Remote Detonator, Mama Mega
	dmgPassive = 2.0, -- Passive ESD / Dr. Fetus, Epic Fetus, Curse of the Tower, Bob's Brain, Number Two, Rocket in a Jar, Ipecac (bonus for Dr. Fetus + My Reflection)
	passive    = 0.5, -- Passives    / (All other bomb items)
	trinket    = 0.5, -- Trinkets    / Blasting Cap, Match Stick, Ring Cap, Safety Scissors, Short Fuse, Bobs Bladder
	card       = 1.0, -- Cards       / The Tower
}


--[[
MAIN
===============================================================================
]]


function HDHH:MaybeSpawnItem(NPC)
	local willDrop = HDHH:CanDrop( NPC )

	if ( willDrop ) then
		Isaac.Spawn(
			EntityType.ENTITY_PICKUP,
			PickupVariant.PICKUP_COLLECTIBLE,
			CollectibleType.COLLECTIBLE_HOST_HAT, -- 375
			NPC.Position,
			Vector(0, 0),
			nil
		)
	end
end


--[[
DROP CHANCE
===============================================================================
]]

---@param NPC Entity
---@return boolean
function HDHH:CanDrop( NPC )
	local willDrop     = false
	local rng          = NPC:GetDropRNG()
	local rngFloat     = rng:RandomFloat() -- random number between 0 and 1
	local chanceObj    = HDHH:GetDropChance()
	local dropChance   = chanceObj.dropChance
	local luckMod      = chanceObj.luckMod
	local bonusChance  = chanceObj.bonusChance
	local debugStrings = { successStr = "", operator = "" }

	-- MAIN
	if ( rngFloat <= dropChance ) then
		willDrop = true
		debugStrings.successStr = "YES"
		debugStrings.operator   = "<="
	else
		willDrop = false
		debugStrings.successStr = "NO"
		debugStrings.operator   = ">"
	end

	-- Debug logging
	if ( HDHH.CONFIG.debugLog ) then
		local debugMsg     = ""
		local rngRoundStr  = tostring( HDHH:Round( rngFloat, 4 ) )
		local debugNewLine = HDHH:IfElse( HDHH.CONFIG.debugNewLine, "\n", "" )
		local bonusStr     = string.format( "(+%s)", HDHH:GetBonusChance() )

		-- Add 0 for alignment
		rngRoundStr = HDHH:AddTrailingZeroes( rngRoundStr, 6 )
		-- rngRoundStr = HDHH:IfElse( string.len( rngRoundStr) < 4, rngRoundStr .. "0", rngRoundStr )
		-- rngRoundStr = HDHH:IfElse( string.len( rngRoundStr) < 5, rngRoundStr .. "0", rngRoundStr )
		-- rngRoundStr = HDHH:IfElse( string.len( rngRoundStr) < 6, rngRoundStr .. "0", rngRoundStr )

		-- Hide bonus chance if disabled
		bonusStr    = HDHH:IfElse( HDHH.CONFIG.addItemBonus, bonusStr, "" )

		debugMsg = string.format(
			-- Example: "Host: NO, rng/chance(bonus)= 0.4713 > 0.001 (+0.0)"
			"Host: %s, rng/chance(bonus)= %s %s %s %s",
			debugStrings.successStr,
			rngRoundStr,
			debugStrings.operator,
			dropChance,
			bonusStr
		)

		Isaac.DebugString( debugMsg )
		Isaac.ConsoleOutput( debugNewLine .. debugMsg )
	end

	return willDrop
end


-- Returns a chance object, with: dropChance, luckMod, bonusChance
function HDHH:GetDropChance()
	local player = Isaac.GetPlayer(0)

	-- Base chance: 0.1% (1/1000)
	local baseDropChance = ( HDHH.MULTIPLIERS.baseChance / 100 ) -- eg. 0.1% = 0.001

	-- Luck modifier (chance = 0.1 * LUCK)
	--    1 LCK =  +0.1% chance (0.2% total)
	--    5 LCK =  +0.5%
	--   10 LCK =  +1%
	--   50 LCK =  +5%
	--  100 LCK = +10%
	--  500 LCK = +50% (max)
	local luckMod = player.Luck * ( HDHH.MULTIPLIERS.luckMulti / 100 )

	-- Get bonus chance from items
	local bonusChance = HDHH:IfElse( HDHH.CONFIG.addItemBonus, HDHH:GetBonusChance(), 0 )

	-- ACTUAL DROP CHANCE (base + luck)
	local dropChance = baseDropChance + luckMod + bonusChance

	-- Cap at 50% chance
	if ( dropChance > 0.5 ) then
		dropChance = 0.5
	end

	-- Always drop Host Hat (used for debugging)
	if ( HDHH.CONFIG.alwaysDrop ) then
		dropChance = 1
	end

	local chanceObj = {
		dropChance = dropChance,
		luckMod = luckMod,
		bonusChance = bonusChance
	}

	-- return dropChance
	return chanceObj
end


function HDHH:GetBonusChance()
	local bonusChance = 0

	-- Division gives us the required percentage value (eg 0.1% = 0.001)
	local active1  = (HDHH.MULTIPLIERS.dmgActive  / 100) * HDHH:GetSelfDamageActiveBonus()
	local active2  = (HDHH.MULTIPLIERS.active     / 100) * HDHH:GetActiveBonus()
	local passive1 = (HDHH.MULTIPLIERS.dmgPassive / 100) * HDHH:GetSelfDamagePassiveBonus()
	local passive2 = (HDHH.MULTIPLIERS.passive    / 100) * HDHH:GetPassiveBonus()
	local trinket  = (HDHH.MULTIPLIERS.trinket    / 100) * HDHH:GetTrinketBonus()
	local card     = (HDHH.MULTIPLIERS.card       / 100) * HDHH:GetCardBonus()

	bonusChance = active1 + active2 + passive1 + passive2 + trinket + card

	return bonusChance
end


--[[
BONUS MODIFIERS
===============================================================================
These increase the chance by various amounts, depending on your items.
Chance modifier values aren't set here, these functions only return bonus
values as ints, with each item giving +1 bonus value for that func
]]

-- ACTIVE: explosive self damage potential (high bonus)
---@return integer
function HDHH:GetSelfDamageActiveBonus()
	local bonus     = 0
	local player    = Isaac.GetPlayer(0)
	local itemSlot1 = player:GetActiveItem( ActiveSlot.SLOT_PRIMARY )
	local itemSlot2 = player:GetActiveItem( ActiveSlot.SLOT_SECONDARY ) -- schoolbag

	-- Loop over items
	for index, itemID in ipairs( ItemLists.selfDamageActives ) do
		if ( itemSlot1 == itemID ) then
			bonus = bonus + 1
		end

		if ( itemSlot2 == itemID ) then
			bonus = bonus + 1
		end
	end

	return bonus
end

-- ACTIVE: bomb-related (smaller bonus)
---@return integer
function HDHH:GetActiveBonus()
	local bonus     = 0
	local player    = Isaac.GetPlayer(0)
	local itemSlot1 = player:GetActiveItem( ActiveSlot.SLOT_PRIMARY )
	local itemSlot2 = player:GetActiveItem( ActiveSlot.SLOT_SECONDARY ) -- schoolbag

	-- Loop over items
	for index, itemID in ipairs( ItemLists.actives ) do
		if ( itemSlot1 == itemID ) then
			bonus = bonus + 1
		end

		if ( itemSlot2 == itemID ) then
			bonus = bonus + 1
		end
	end

	return bonus
end


-- PASSIVE: explosive self-damage potential (high bonus)
---@return integer
function HDHH:GetSelfDamagePassiveBonus()
	local bonus  = 0
	local player = Isaac.GetPlayer(0)

	-- Loop over items
	for index, itemID in ipairs( ItemLists.selfDamagePassives ) do
		if ( player:HasCollectible( itemID ) ) then
			bonus = bonus + 1
		end
	end

	-- Bonus chance if you have My Reflection + Dr. Fetus/Ipecac
	local hasDrFetus = player:HasCollectible( CollectibleType.COLLECTIBLE_DR_FETUS )
	local hasMyRefl  = player:HasCollectible( CollectibleType.COLLECTIBLE_MY_REFLECTION )
	local hasIpecac  = player:HasCollectible( CollectibleType.COLLECTIBLE_IPECAC )

	if ( hasMyRefl ) then
		if ( hasDrFetus ) then
			bonus = bonus + 1
		elseif ( hasIpecac ) then
			bonus = bonus + 1
		end
	end

	return bonus
end


-- PASSIVE: bomb-related (smaller bonus)
---@return integer
function HDHH:GetPassiveBonus()
	local bonus  = 0
	local player = Isaac.GetPlayer(0)

	-- Loop over items
	for index, itemID in ipairs( ItemLists.passives ) do
		if ( player:HasCollectible( itemID ) ) then
			bonus = bonus + 1
		end
	end

	return bonus
end


-- TRINKET: bomb-related
---@return integer
function HDHH:GetTrinketBonus()
	local bonus    = 0
	local player   = Isaac.GetPlayer(0)
	local trinket1 = player:GetTrinket(0)
	local trinket2 = player:GetTrinket(1)

	-- Loop over items
	for index, itemID in ipairs( ItemLists.trinkets ) do
		if ( trinket1 == itemID ) then
			bonus = bonus + 1
		end
	end

	return bonus
end


-- CARD: holding "The Tower"
---@return integer
function HDHH:GetCardBonus()
	local bonus  = 0
	local player = Isaac.GetPlayer(0)
	local card1  = player:GetCard(0)
	local card2  = player:GetCard(1)

	-- Loop over items
	for index, itemID in ipairs( ItemLists.cards ) do
		if ( card1 == itemID ) then
			bonus = bonus + 1
		end

		if ( card2 == itemID ) then
			bonus = bonus + 1
		end
	end

	return bonus
end


--[[
UTILITY
=============================================================================
]]

---@param number   integer  The integer to round
---@param decimals integer  Number of decimal places required
---@return integer
function HDHH:Round( number, decimals )
    local power = 10^decimals
    return math.floor(number * power) / power
end


function HDHH:IfElse( check, ifTrue, ifFalse )
	if ( check == nil ) then
		return ifFalse
	end

	if ( check ) then
		return ifTrue
	else
		return ifFalse
	end
end


-- Add a trailing zeros to a number
-- Warning: Converts integer to string
---@param number    integer  The integer to add trailing zeros to
---@param minLength integer  Minimum int string length, zeros are added if it is below this
---@return string
function HDHH:AddTrailingZeroes( number, minLength )
	local numStr = tostring( number )

	while ( string.len( numStr ) < minLength ) do
		numStr = numStr .. "0"
	end

	return numStr
end


--[[
SETTINGS
=============================================================================
]]

---@param isContinued boolean True if started from a savestate
function HDHH:OnGameStart( isContinued )
    --Loading moddata
    if HDHH:HasData() then
        HDHH.CONFIG = json.decode( HDHH:LoadData() )
    end
end


function HDHH:preGameExit( shouldSave )
  local jsonString = json.encode( HDHH.CONFIG )
  HDHH:SaveData( jsonString )
end


--[[
MCM (Mod Config Menu)
=============================================================================
]]

-- Docs: https://github.com/Zamiell/isaac-mod-config-menu
-- Reference: extra scared hearts_2559137447/esh_mcm.lua
-- Reference: extra scared hearts_2559137447/main.lua

-- HDHH.CONFIG.addItemBonus = true,  -- False if you don't want the bonus chance from items
-- HDHH.CONFIG.alwaysDrop   = false, -- Sets the drop chance to 100%, forcing the Host Hat to always drop
-- HDHH.CONFIG.debugLog     = true,  -- True to log to the debug console & log.txt
-- HDHH.CONFIG.debugNewLine = false, -- Add newline when loggin to debug console, fixes merged lines when using Quick Kill debug

if ModConfigMenu then
	local modName = "Host Drops Host Hat";

	-- Add a tab for this mod
    ModConfigMenu.UpdateCategory(modName, {
		Info = {
			"View settings for " .. modName .. ".",
		}
	});

	-- Add option: addItemBonus
    ModConfigMenu.AddSetting(modName, "Settings", {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function()
            return HDHH.CONFIG.addItemBonus;
        end,
        Display = function()
            local toggle = "off";
            if HDHH.CONFIG.addItemBonus then
                toggle = "ON";
            end
            return "Explosive items give bonus chance: " .. toggle;
        end,
        OnChange = function(currentBool)
            HDHH.CONFIG.addItemBonus = currentBool;
            --HDHH:UNUSED_OnSettingsChange(); -- func does not exist atm, here for future ref
        end,
        Info = function()
            if HDHH.CONFIG.addItemBonus then
                return "ON: Explosive items give you a bonus chance";
            else
				return "OFF: No bonus from items";
            end
        end
    });
end



--[[
INIT
=============================================================================
]]

-- https://moddingofisaac.com/docs/rep/enums/ModCallbacks.html

-- On Host death
HDHH:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, HDHH.MaybeSpawnItem, EntityType.ENTITY_HOST)

-- Load settings
HDHH:AddCallback( ModCallbacks.MC_POST_GAME_STARTED, HDHH.OnGameStart )

-- Save setting
HDHH:AddCallback( ModCallbacks.MC_PRE_GAME_EXIT, HDHH.preGameExit )

local Mod = RegisterMod("Host Drops Host Hat", 1)
local game = Game()

function Mod:MaybeSpawnItem(NPC)

	-- Host Hat ID: 375
	-- https://bindingofisaacrebirth.fandom.com/wiki/Host_Hat
	-- https://bindingofisaacrebirth.fandom.com/wiki/Host

	local debugLog    = false  -- @todo: Make this configurable
	local cheatMode   = false -- @todo: Make this configurable
	local hostHatID   = 375
	local player      = Isaac.GetPlayer(0)
	local rng         = NPC:GetDropRNG()
	local randomFloat = rng:RandomFloat() --random number between 0 and 1

	-- Base chance: 0.1% (1/1000)
	-- Note: This might be too high, esp. the luck bonus, but it needs
	--   to be low enough to see the effects of the mod eventually
	local baseDropChance = 0.001 -- 0.001 = 0.1%

	-- Luck modifier (chance = 0.1 * LUCK)
	--    1 LCK = +0.1% chance (0.2% total)
	--   10 LCK =  +1% chance
	--   50 LCK =  +5% chance
	--  100 LCK = +10% chance
	--  500 LCK = +50% chance (max)
	local luckMod = player.Luck * 0.001

	-- ACTUAL DROP CHANCE (base + luck)
	local dropChance = baseDropChance + luckMod

	-- Cap at 50% chance
	if ( dropChance > 0.5 ) then
		dropChance = 0.5
	end

	-- Cheat Mode (for debugging)
	if ( cheatMode ) then
		dropChance = 0.50 --50% chance
	end
	
	local debugStr = ""

	-- MAIN
	if ( randomFloat <= dropChance ) then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, hostHatID, NPC.Position, Vector(0, 0), nil)

		if ( debugLog ) then
			debugStr = "HostHat: SUCCESS (rolled/chance: "..randomFloat.." <= "..dropChance..")"
			Isaac.DebugString( debugStr ) -- logs to log.txt
			Isaac.ConsoleOutput( debugStr  ) -- logs to debug console, same as print(debugStr)
		end
	else
		if ( debugLog ) then
			debugStr = "HostHat: FAIL (rolled/chance: "..randomFloat.." > "..dropChance..")"
			Isaac.DebugString( debugStr )
			Isaac.ConsoleOutput( debugStr )
		end
	end
end

-- On Host death
Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, Mod.MaybeSpawnItem, EntityType.ENTITY_HOST)

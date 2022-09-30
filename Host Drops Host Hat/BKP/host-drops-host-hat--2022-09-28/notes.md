# Notes


## Docs & Reference

### Wiki

- https://bindingofisaacrebirth.fandom.com/wiki/Host
- https://bindingofisaacrebirth.fandom.com/wiki/Host_Hat
- https://bindingofisaacrebirth.fandom.com/wiki/Rocks#Skulls
- https://bindingofisaacrebirth.fandom.com/wiki/Category:Bomb_items

### Modding API

General:

- https://moddingofisaac.com/docs/rep/EntityPlayer.html#getactiveitem
- https://moddingofisaac.com/docs/rep/enums/ActiveSlot.html
- https://moddingofisaac.com/docs/rep/enums/CollectibleType.html#COLLECTIBLE_HOST_HAT
- https://moddingofisaac.com/docs/rep/enums/TrinketType.html
- https://moddingofisaac.com/docs/rep/RNG.html#randomfloat

Enums:

- https://moddingofisaac.com/docs/rep/enums/CollectibleType.html
- https://moddingofisaac.com/docs/rep/enums/Card.html
- https://moddingofisaac.com/docs/rep/enums/TrinketType.html

Related to EID:

- https://moddingofisaac.com/docs/rep/enums/EntityType.html
- https://moddingofisaac.com/docs/rep/enums/PickupVariant.html
- https://moddingofisaac.com/docs/rep/entities/Overview.html#type-variant-and-subtype
- https://moddingofisaac.com/docs/rep/faq/faq.html#how-do-you-tell-what-the-entity-type-variant-or-subtype-of-a-particular-entity-is

### EID

- https://github.com/wofsauge/External-Item-Descriptions/wiki/Description-Modifiers
- https://github.com/wofsauge/External-Item-Descriptions/wiki/Description-Modifiers#description-object-attributes

### Debug Commands

```
debug 3: "Infinite HP"
debug 4: "High Damage"
debug 9: "High Luck" - +50 luck
debug 10: "Quick Kill" - All enemies take constant and rapid damage

spawn 27.0
repeat 30

luamod host-drops-host-hat_2866530077

giveitem c51
^ Dr. Fetus

giveittem c40
^ Kamikaze

giveitem p18
^Luck Up

giveitem k17
^ Card: The Tower

https://steamcommunity.com/sharedfiles/filedetails/?id=1889162991
Luck +1
Luck 5
Luck 10
Luck 20
```

### QuickNotes


	if ( HDHH.CONFIG.debugLog ) then
		-- debugStr = "Host: YES, rng/chance(bonus)= " .. rFloatRounded .. " <= " .. dropChance .. "(+" .. bonusChance .. ")"
		-- Isaac.DebugString( debugStr ) -- logs to log.txt
		-- Isaac.ConsoleOutput( debugNewLine .. debugStr  ) -- logs to debug console, same as print(debugStr)
	end
	if ( HDHH.CONFIG.debugLog ) then
		-- debugStr = "Host: NO, rng/chance(bonus)= " .. rFloatRounded .. " > " .. dropChance .. "(+" .. bonusChance .. ")"
		-- Isaac.DebugString( debugStr )
		-- Isaac.ConsoleOutput( debugNewLine .. debugStr )
	end

execute as @e[type=minecraft:item_frame,tag=tpers.gateway] at @s run function teleporters:tick_gateway
execute as @e[type=minecraft:item,tag=!tpers.done] at @s if block ~ ~1 ~ minecraft:crying_obsidian if block ~ ~-1 ~ minecraft:crying_obsidian if block ~ ~ ~ minecraft:air if entity @s[nbt={Item:{id:"minecraft:compass",Count:1b,tag:{LodestoneTracked:1b}}}] run function teleporters:test_compass
schedule function teleporters:tick 1t
tellraw @s {"text":"Teleporting to world spawn...","color":"dark_aqua"}
scoreboard players operation @s spawn.delay = #delay spawn.config
execute store result score @s spawn.x run data get entity @s Pos[0] 10
execute store result score @s spawn.y run data get entity @s Pos[1] 10
execute store result score @s spawn.z run data get entity @s Pos[2] 10
scoreboard players set @s spawn 0
execute if score #percent mulSle.config matches 0 run tellraw @s [{"text":"1","color":"aqua"},{"text":" player in the overworld must sleep to skip the night and the rain.","color":"dark_aqua"}]
execute unless score #percent mulSle.config matches 0 run tellraw @s [{"score":{"name":"#percent","objective":"mulSle.config"},"color":"aqua"},{"text":"%","color":"aqua"},{"text":" of players in the overworld must sleep to skip the night and the rain.","color":"dark_aqua"}]
tellraw @s [{"text":"- [ ","color":"dark_aqua"},{"text":"Show Display Options","color":"aqua","clickEvent":{"action":"run_command","value":"/trigger mulSle set 3"},"hoverEvent":{"action":"show_text","contents":[{"text":"Click to show display options.","color":"dark_aqua"}]}},{"text":" ]","color":"dark_aqua"}]
tellraw @s [{"text":"- [ ","color":"dark_aqua"},{"text":"List Sleeping Players","color":"aqua","clickEvent":{"action":"run_command","value":"/trigger mulSle set 2"},"hoverEvent":{"action":"show_text","contents":[{"text":"Click to list sleeping players.","color":"dark_aqua"}]}},{"text":" ]","color":"dark_aqua"}]
tellraw @a {"text":"                                                                                ","color":"dark_gray","strikethrough":true}
tellraw @s ["                Multiplayer Sleep",{"text":" / ","color":"gray"},"Personal Settings                "]
tellraw @a {"text":"                                                                                ","color":"dark_gray","strikethrough":true}
execute if score @s mpSleep.config matches 0.. run function multiplayer_sleep:trigger/show_disabled_display_mode_default
execute unless score @s mpSleep.config matches 0.. run function multiplayer_sleep:trigger/show_enabled_display_mode_default
execute if score @s mpSleep.config matches 1 run tellraw @s ["",{"text":"[ ✔ ]","color":"green","clickEvent":{"action":"run_command","value":"/trigger mpSleep set 7"},"hoverEvent":{"action":"show_text","value":["",{"text":"Click to disable ","color":"red"},"Display Mode: Boss Bar",{"text":".","color":"red"}]}}," ",{"text":"[ ℹ ]","color":"gray","clickEvent":{"action":"run_command","value":"/trigger mpSleep set 4"},"hoverEvent":{"action":"show_text","value":["",{"text":"Click to preview ","color":"gray"},"Display Mode: Boss Bar",{"text":".\nThe boss bar preview's color may not be accurate.","color":"gray"}]}}," Display Mode: Boss Bar"]
execute unless score @s mpSleep.config matches 1 run tellraw @s ["",{"text":"[ ❌ ]","color":"red","clickEvent":{"action":"run_command","value":"/trigger mpSleep set 8"},"hoverEvent":{"action":"show_text","value":["",{"text":"Click to enable ","color":"green"},"Display Mode: Boss Bar",{"text":".","color":"green"}]}}," ",{"text":"[ ℹ ]","color":"gray","clickEvent":{"action":"run_command","value":"/trigger mpSleep set 4"},"hoverEvent":{"action":"show_text","value":["",{"text":"Click to preview ","color":"gray"},"Display Mode: Boss Bar",{"text":".\nThe boss bar preview's color may not be accurate.","color":"gray"}]}}," Display Mode: Boss Bar"]
execute if score @s mpSleep.config matches 2 run tellraw @s ["",{"text":"[ ✔ ]","color":"green","clickEvent":{"action":"run_command","value":"/trigger mpSleep set 7"},"hoverEvent":{"action":"show_text","value":["",{"text":"Click to disable ","color":"red"},"Display Mode: Action Bar",{"text":".","color":"red"}]}}," ",{"text":"[ ℹ ]","color":"gray","clickEvent":{"action":"run_command","value":"/trigger mpSleep set 5"},"hoverEvent":{"action":"show_text","value":["",{"text":"Click to preview ","color":"gray"},"Display Mode: Action Bar",{"text":".","color":"gray"}]}}," Display Mode: Action Bar"]
execute unless score @s mpSleep.config matches 2 run tellraw @s ["",{"text":"[ ❌ ]","color":"red","clickEvent":{"action":"run_command","value":"/trigger mpSleep set 9"},"hoverEvent":{"action":"show_text","value":["",{"text":"Click to enable ","color":"green"},"Display Mode: Action Bar",{"text":".","color":"green"}]}}," ",{"text":"[ ℹ ]","color":"gray","clickEvent":{"action":"run_command","value":"/trigger mpSleep set 5"},"hoverEvent":{"action":"show_text","value":["",{"text":"Click to preview ","color":"gray"},"Display Mode: Action Bar",{"text":".","color":"gray"}]}}," Display Mode: Action Bar"]
execute if score @s mpSleep.config matches 3 run tellraw @s ["",{"text":"[ ✔ ]","color":"green","clickEvent":{"action":"run_command","value":"/trigger mpSleep set 7"},"hoverEvent":{"action":"show_text","value":["",{"text":"Click to disable ","color":"red"},"Display Mode: Chat",{"text":".","color":"red"}]}}," ",{"text":"[ ℹ ]","color":"gray","clickEvent":{"action":"run_command","value":"/trigger mpSleep set 6"},"hoverEvent":{"action":"show_text","value":["",{"text":"Click to preview ","color":"gray"},"Display Mode: Chat",{"text":".","color":"gray"}]}}," Display Mode: Chat"]
execute unless score @s mpSleep.config matches 3 run tellraw @s ["",{"text":"[ ❌ ]","color":"red","clickEvent":{"action":"run_command","value":"/trigger mpSleep set 10"},"hoverEvent":{"action":"show_text","value":["",{"text":"Click to enable ","color":"green"},"Display Mode: Chat",{"text":".","color":"green"}]}}," ",{"text":"[ ℹ ]","color":"gray","clickEvent":{"action":"run_command","value":"/trigger mpSleep set 6"},"hoverEvent":{"action":"show_text","value":["",{"text":"Click to preview ","color":"gray"},"Display Mode: Chat",{"text":".","color":"gray"}]}}," Display Mode: Chat"]
tellraw @a {"text":"                                                                                ","color":"dark_gray","strikethrough":true}
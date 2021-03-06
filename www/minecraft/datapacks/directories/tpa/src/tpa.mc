function load {
	scoreboard objectives add tpa.config dummy "TPA Config"
	scoreboard objectives add tpa.pid dummy "Player ID"
	scoreboard objectives setdisplay list tpa.pid
	scoreboard objectives add tpa.target dummy
	scoreboard objectives add tpa.timeout dummy
	scoreboard objectives add tpa.cooldown dummy
	scoreboard objectives add tpa trigger
	scoreboard objectives add tpcancel trigger
	scoreboard objectives add tpaccept trigger
	scoreboard objectives add tpdeny trigger
	execute unless score #cooldown tpa.config matches 0.. run scoreboard players set #cooldown tpa.config 0
}
function uninstall {
	schedule clear tpa:tick
	schedule clear tpa:decrement_cooldowns
	scoreboard objectives remove tpa.config
	scoreboard objectives remove tpa.pid
	scoreboard objectives remove tpa.target
	scoreboard objectives remove tpa.timeout
	scoreboard objectives remove tpa.cooldown
	scoreboard objectives remove tpa
	scoreboard objectives remove tpcancel
	scoreboard objectives remove tpaccept
	scoreboard objectives remove tpdeny
}
clock 1t {
	name tick
	execute as @a unless score @s tpa.pid matches 1.. store result score @s tpa.pid run scoreboard players add #last tpa.pid 1
	scoreboard players add @a[scores={tpa.target=1..}] tpa.timeout 1
	execute as @a[scores={tpa.timeout=6000..}] run {
		name time_out_tpa
		tag @s add tpa.sender
		tellraw @s {"text":"Your teleport request has timed out after five minutes.","color":"red"}
		execute as @a if score @s tpa.pid = @a[tag=tpa.sender,limit=1] tpa.target run tellraw @s ["",{"selector":"@a[tag=tpa.sender]","color":"red"},{"text":"'s teleport request has timed out after five minutes.","color":"red"}]
		scoreboard players reset @s tpa.target
		scoreboard players reset @s tpa.timeout
		tag @s remove tpa.sender
	}
	execute as @a[scores={tpa=1..}] run {
		name trigger_tpa
		execute if score @s tpa.cooldown matches 1.. run tellraw @s [{"text":"Your TPA cooldown will end in ","color":"red"},{"score":{"name":"@s","objective":"tpa.cooldown"},"color":"red"},{"text":" seconds.","color":"red"}]
		execute unless score @s tpa.cooldown matches 1.. run {
			name send_tpa
			tag @s add tpa.sender
			execute as @a if score @s tpa.pid = @a[tag=tpa.sender,limit=1] tpa run tag @s add tpa.target
			execute unless entity @a[tag=tpa.target] run tellraw @s [{"text":"No player with PID ","color":"red"},{"score":{"name":"@s","objective":"tpa"},"color":"red"},{"text":" was found.","color":"red"}]
			execute if entity @s[tag=tpa.target] run tellraw @s {"text":"You cannot send a teleport request to yourself.","color":"red"}
			execute as @a[tag=!tpa.sender,tag=tpa.target,limit=1] run {
				name receive_tpa
				execute as @a[tag=tpa.sender] if score @s tpa.target matches 1.. run function tpa:cancel_tpa
				scoreboard players operation @a[tag=tpa.sender] tpa.target = @a[tag=tpa.sender] tpa
				tellraw @a[tag=tpa.sender] [{"text":"You have requested to teleport to ","color":"COLOR_1"},{"selector":"@s","color":"COLOR_2"},{"text":".\nTo cancel, ","color":"COLOR_1"},{"text":"enter","color":"COLOR_3"},{"text":" or ","color":"COLOR_1"},{"text":"click","color":"COLOR_3"},{"text":" on ","color":"COLOR_1"},{"text":"/trigger tpcancel","color":"COLOR_2","clickEvent":{"action":"run_command","value":"/trigger tpcancel"},"hoverEvent":{"action":"show_text","value":[{"text":"Click to run ","color":"COLOR_1"},{"text":"/trigger tpcancel","color":"COLOR_2"},{"text":".","color":"COLOR_1"}]}},{"text":".","color":"COLOR_1"}]
				tellraw @s ["",{"selector":"@a[tag=tpa.sender]","color":"COLOR_2"},{"text":" has requested to teleport to you.\nTo accept, ","color":"COLOR_1"},{"text":"enter","color":"COLOR_3"},{"text":" or ","color":"COLOR_1"},{"text":"click","color":"COLOR_3"},{"text":" on ","color":"COLOR_1"},{"text":"/trigger tpaccept","color":"COLOR_2","clickEvent":{"action":"run_command","value":"/trigger tpaccept"},"hoverEvent":{"action":"show_text","value":[{"text":"Click to run ","color":"COLOR_1"},{"text":"/trigger tpaccept","color":"COLOR_2"},{"text":".\nThe ","color":"COLOR_1"},{"text":"most recent","color":"red"},{"text":" active teleport request will be accepted.\nEnter ","color":"COLOR_1"},{"text":"/trigger tpaccept set <PID>","color":"COLOR_2"},{"text":" instead if this player's request is not the most recent.","color":"COLOR_1"}]}},{"text":".\nTo deny, ","color":"COLOR_1"},{"text":"enter","color":"COLOR_3"},{"text":" or ","color":"COLOR_1"},{"text":"click","color":"COLOR_3"},{"text":" on ","color":"COLOR_1"},{"text":"/trigger tpdeny","color":"COLOR_2","clickEvent":{"action":"run_command","value":"/trigger tpdeny"},"hoverEvent":{"action":"show_text","value":[{"text":"Click to run ","color":"COLOR_1"},{"text":"/trigger tpdeny","color":"COLOR_2"},{"text":".\nThe ","color":"COLOR_1"},{"text":"most recent","color":"red"},{"text":" active teleport request will be denied.\nEnter ","color":"COLOR_1"},{"text":"/trigger tpdeny set <PID>","color":"COLOR_2"},{"text":" instead if this player's request is not the most recent.","color":"COLOR_1"}]}},{"text":".","color":"COLOR_1"}]
			}
			tag @s remove tpa.sender
			tag @a[tag=tpa.target] remove tpa.target
		}
		scoreboard players set @s tpa 0
	}
	scoreboard players enable @a tpa
	execute as @a[scores={tpcancel=1}] run {
		name trigger_tpcancel
		execute unless score @s tpa.target matches 1.. run tellraw @s {"text":"You have no active teleport requests to cancel.","color":"red"}
		execute if score @s tpa.target matches 1.. run function tpa:cancel_tpa
	}
	scoreboard players enable @a tpcancel
	scoreboard players set @a tpcancel 0
	execute as @a[scores={tpaccept=0..}] run {
		name trigger_tpaccept
		tag @s add tpa.target
		execute as @a if score @s tpa.target = @a[tag=tpa.target,limit=1] tpa.pid run tag @s add tpa.sender
		execute unless score @s tpaccept matches 0 as @a unless score @s tpa.pid = @a[tag=tpa.target,limit=1] tpaccept run tag @s remove tpa.sender
		execute unless score @s tpaccept matches 0 unless entity @a[tag=tpa.sender] run tellraw @s [{"text":"You have no active teleport requests from a player with PID ","color":"red"},{"score":{"name":"@s","objective":"tpaccept"},"color":"red"},{"text":" to accept.","color":"red"}]
		execute if score @s tpaccept matches 0 unless entity @a[tag=tpa.sender] run tellraw @s {"text":"You have no active teleport requests to accept.","color":"red"}
		execute if score @s tpaccept matches 0 as @a[tag=tpa.sender] run function tpa:untag_older_senders
		execute as @a[tag=tpa.sender] run {
			name accept_tpa
			tellraw @a[tag=tpa.target] [{"text":"You have accepted ","color":"COLOR_1"},{"selector":"@s","color":"COLOR_2"},{"text":"'s teleport request.","color":"COLOR_1"}]
			tellraw @s ["",{"selector":"@a[tag=tpa.target]","color":"COLOR_2"},{"text":" has accepted your teleport request.","color":"COLOR_1"}]
			execute unless score #cooldown tpa.config matches 0 run scoreboard players operation @s tpa.cooldown = #cooldown tpa.config
			tp @s @a[tag=tpa.target,limit=1]
			scoreboard players reset @s tpa.target
			scoreboard players reset @s tpa.timeout
			tag @s remove tpa.sender
		}
		tag @s remove tpa.target
	}
	scoreboard players enable @a tpaccept
	scoreboard players set @a tpaccept -1
	execute as @a[scores={tpdeny=0..}] run {
		name trigger_tpdeny
		tag @s add tpa.target
		execute as @a if score @s tpa.target = @a[tag=tpa.target,limit=1] tpa.pid run tag @s add tpa.sender
		execute unless score @s tpdeny matches 0 as @a unless score @s tpa.pid = @a[tag=tpa.target,limit=1] tpdeny run tag @s remove tpa.sender
		execute unless score @s tpdeny matches 0 unless entity @a[tag=tpa.sender] run tellraw @s [{"text":"You have no active teleport requests from a player with PID ","color":"red"},{"score":{"name":"@s","objective":"tpdeny"},"color":"red"},{"text":" to deny.","color":"red"}]
		execute if score @s tpdeny matches 0 unless entity @a[tag=tpa.sender] run tellraw @s {"text":"You have no active teleport requests to deny.","color":"red"}
		execute if score @s tpdeny matches 0 as @a[tag=tpa.sender] run function tpa:untag_older_senders
		execute as @a[tag=tpa.sender] run {
			name deny_tpa
			tellraw @a[tag=tpa.target] [{"text":"You have denied ","color":"COLOR_1"},{"selector":"@s","color":"COLOR_2"},{"text":"'s teleport request.","color":"COLOR_1"}]
			tellraw @s ["",{"selector":"@a[tag=tpa.target]","color":"red"},{"text":" has denied your teleport request.","color":"red"}]
			scoreboard players reset @s tpa.target
			scoreboard players reset @s tpa.timeout
			tag @s remove tpa.sender
		}
		tag @s remove tpa.target
	}
	scoreboard players enable @a tpdeny
	scoreboard players set @a tpdeny -1
}
clock 1s {
	name decrement_cooldowns
	execute as @a[scores={tpa.cooldown=1..}] run {
		name decrement_cooldown
		scoreboard players remove @s tpa.cooldown 1
		scoreboard players reset @s[scores={tpa.cooldown=0}] tpa.cooldown
	}
}
function untag_older_senders {
	tag @s add tpa.self
	execute as @a[tag=tpa.sender] if score @s tpa.timeout > @a[tag=tpa.self,limit=1] tpa.timeout run tag @s remove tpa.sender
	tag @s remove tpa.self
}
function cancel_tpa {
	tag @s add tpa.cancelSender
	execute if entity @s[tag=tpa.sender] run tellraw @s {"text":"You have cancelled your previous teleport request.","color":"red"}
	execute unless entity @s[tag=tpa.sender] run tellraw @s {"text":"You have cancelled your teleport request.","color":"COLOR_1"}
	execute as @a if score @s tpa.pid = @a[tag=tpa.cancelSender,limit=1] tpa.target run tellraw @s ["",{"selector":"@a[tag=tpa.cancelSender]","color":"red"},{"text":" has cancelled their teleport request.","color":"red"}]
	scoreboard players reset @s tpa.target
	scoreboard players reset @s tpa.timeout
	tag @s remove tpa.cancelSender
}
function config {
	tellraw @s {"text":"                                                                                ","color":"dark_gray","strikethrough":true}
	tellraw @s ["                           TPA",{"text":" / ","color":"gray"},"Global Settings                           "]
	tellraw @s {"text":"                                                                                ","color":"dark_gray","strikethrough":true}
	tellraw @s ["",{"text":"[ ✎ ]","color":"gray","clickEvent":{"action":"suggest_command","value":"/scoreboard players set #cooldown tpa.config "},"hoverEvent":{"action":"show_text","value":["",{"text":"Click to enter the number of seconds required to wait between uses of the TPA command.","color":"gray"},{"text":"\nAccepts: whole numbers 0+\nDefault: 0","color":"dark_gray"}]}}," Cooldown ",{"text":"(Current: ","color":"gray"},{"score":{"name":"#cooldown","objective":"tpa.config"},"color":"gray"},{"text":")","color":"gray"}]
	tellraw @s {"text":"                                                                                ","color":"dark_gray","strikethrough":true}
	execute store result score #sendCommandFeedback tpa.config run gamerule sendCommandFeedback
	execute if score #sendCommandFeedback tpa.config matches 1 run {
		name hide_command_feedback
		gamerule sendCommandFeedback false
		schedule 1t replace {
			name restore_command_feedback
			gamerule sendCommandFeedback true
		}
	}
}

# This file was generated by Animated Java via MC-Build. It is not recommended to edit this file directly.
execute unless entity @s[type=item_display,tag=aj.rig_root] run return run \
	function animated_java:global/errors/function_not_executed_as_root_entity \
	{'function_path': 'animated_java:armor_stand_merge/animations/exit_sitting/stop'}
tag @s remove aj.armor_stand_merge.animation.exit_sitting.playing
execute store result storage aj:temp frame int 1 run scoreboard players set @s aj.frame 1
function animated_java:armor_stand_merge/animations/exit_sitting/zzz/frames/1
# This file was generated by Animated Java via MC-Build. It is not recommended to edit this file directly.
execute unless entity @s[type=item_display,tag=aj.rig_root] run return run \
	function animated_java:global/errors/function_not_executed_as_root_entity \
	{'function_path': 'animated_java:armor_stand_merge/variants/no_baseplate/apply'}
execute on passengers if entity @s[tag=aj.armor_stand_merge.bone.baseplate_pivot_a] run function animated_java:armor_stand_merge/variants/no_baseplate/zzz/2
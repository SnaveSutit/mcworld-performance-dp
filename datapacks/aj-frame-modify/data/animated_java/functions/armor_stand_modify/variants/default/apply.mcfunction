# This file was generated by Animated Java via MC-Build. It is not recommended to edit this file directly.
execute unless entity @s[type=item_display,tag=aj.rig_root] run return run \
	function animated_java:global/errors/function_not_executed_as_root_entity \
	{'function_path': 'animated_java:armor_stand_modify/variants/default/apply'}
execute on passengers if entity @s[tag=aj.armor_stand_modify.bone.baseplate_pivot_a] run function animated_java:armor_stand_modify/variants/default/zzz/2
execute on passengers if entity @s[tag=aj.armor_stand_modify.bone.head] run function animated_java:armor_stand_modify/variants/default/zzz/4
execute on passengers if entity @s[tag=aj.armor_stand_modify.bone.left_arm] run function animated_java:armor_stand_modify/variants/default/zzz/6
execute on passengers if entity @s[tag=aj.armor_stand_modify.bone.right_arm] run function animated_java:armor_stand_modify/variants/default/zzz/8
execute on passengers if entity @s[tag=aj.armor_stand_modify.bone.body] run function animated_java:armor_stand_modify/variants/default/zzz/10
execute on passengers if entity @s[tag=aj.armor_stand_modify.bone.right_leg2] run function animated_java:armor_stand_modify/variants/default/zzz/12
execute on passengers if entity @s[tag=aj.armor_stand_modify.bone.left_leg] run function animated_java:armor_stand_modify/variants/default/zzz/14
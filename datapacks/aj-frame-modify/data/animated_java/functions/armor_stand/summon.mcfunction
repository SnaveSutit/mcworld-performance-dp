# This file was generated by Animated Java via MC-Build. It is not recommended to edit this file directly.
#Args: {args:{variant: string, animation: string, frame: int, start_animation: boolean}}
# frame is ignored unless animation is specified.
data modify storage aj:temp args set value {variant:'', animation:'', frame: 0}
$execute store success score #success aj.i run data modify storage aj:temp args set value $(args)
summon minecraft:item_display ~ ~ ~ { \
	teleport_duration: 1, \
	interpolation_duration: 1, \
	Tags:['aj.new','aj.rig_entity','aj.rig_root','aj.armor_stand.root'], \
	Passengers:[{id:"minecraft:item_display",Tags:["aj.new","aj.rig_entity","aj.bone","aj.armor_stand.bone","aj.armor_stand.bone.baseplate_pivot_a"],transformation:[-1f,0f,1.2246467991473532e-16f,4.592425496802574e-17f,0f,1f,0f,0.0625f,-1.2246467991473532e-16f,0f,-1f,-0.375f,0f,0f,0f,1f],interpolation_duration:1,teleport_duration:1,item_display:"head",item:{id:"minecraft:white_dye",count:1,components:{"minecraft:custom_model_data":2}},height:100f,width:100f},{id:"minecraft:item_display",Tags:["aj.new","aj.rig_entity","aj.bone","aj.armor_stand.bone","aj.armor_stand.bone.head"],transformation:[-1f,0f,1.2246467991473532e-16f,0f,0f,1f,0f,1.4375f,-1.2246467991473532e-16f,0f,-1f,0f,0f,0f,0f,1f],interpolation_duration:1,teleport_duration:1,item_display:"head",item:{id:"minecraft:white_dye",count:1,components:{"minecraft:custom_model_data":3}},height:100f,width:100f},{id:"minecraft:item_display",Tags:["aj.new","aj.rig_entity","aj.bone","aj.armor_stand.bone","aj.armor_stand.bone.left_arm"],transformation:[-1f,0f,1.2246467991473532e-16f,0.375f,0f,1f,0f,1.4375f,-1.2246467991473532e-16f,0f,-1f,4.592425496802574e-17f,0f,0f,0f,1f],interpolation_duration:1,teleport_duration:1,item_display:"head",item:{id:"minecraft:white_dye",count:1,components:{"minecraft:custom_model_data":4}},height:100f,width:100f},{id:"minecraft:item_display",Tags:["aj.new","aj.rig_entity","aj.bone","aj.armor_stand.bone","aj.armor_stand.bone.right_arm"],transformation:[-1f,0f,1.2246467991473532e-16f,-0.375f,0f,1f,0f,1.4375f,-1.2246467991473532e-16f,0f,-1f,-4.592425496802574e-17f,0f,0f,0f,1f],interpolation_duration:1,teleport_duration:1,item_display:"head",item:{id:"minecraft:white_dye",count:1,components:{"minecraft:custom_model_data":5}},height:100f,width:100f},{id:"minecraft:item_display",Tags:["aj.new","aj.rig_entity","aj.bone","aj.armor_stand.bone","aj.armor_stand.bone.body"],transformation:[-1f,0f,1.2246467991473532e-16f,0f,0f,1f,0f,1.5f,-1.2246467991473532e-16f,0f,-1f,0f,0f,0f,0f,1f],interpolation_duration:1,teleport_duration:1,item_display:"head",item:{id:"minecraft:white_dye",count:1,components:{"minecraft:custom_model_data":6}},height:100f,width:100f},{id:"minecraft:item_display",Tags:["aj.new","aj.rig_entity","aj.bone","aj.armor_stand.bone","aj.armor_stand.bone.right_leg2"],transformation:[-1f,0f,1.2246467991473532e-16f,-0.125f,0f,1f,0f,0.75f,-1.2246467991473532e-16f,0f,-1f,-1.5308084989341915e-17f,0f,0f,0f,1f],interpolation_duration:1,teleport_duration:1,item_display:"head",item:{id:"minecraft:white_dye",count:1,components:{"minecraft:custom_model_data":7}},height:100f,width:100f},{id:"minecraft:item_display",Tags:["aj.new","aj.rig_entity","aj.bone","aj.armor_stand.bone","aj.armor_stand.bone.left_leg"],transformation:[-1f,0f,1.2246467991473532e-16f,0.125f,0f,1f,0f,0.75f,-1.2246467991473532e-16f,0f,-1f,1.5308084989341915e-17f,0f,0f,0f,1f],interpolation_duration:1,teleport_duration:1,item_display:"head",item:{id:"minecraft:white_dye",count:1,components:{"minecraft:custom_model_data":8}},height:100f,width:100f}] \
	}
execute as @e[type=item_display,tag=aj.new,limit=1,distance=..0.01] run function animated_java:armor_stand/zzz/24
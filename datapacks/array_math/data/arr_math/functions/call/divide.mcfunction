scoreboard players set error= arr_math.main 20
#writing from input
execute unless data storage arr_math:main dc run data modify storage arr_math:main v1 set from storage arr_math:in var1
data modify storage arr_math:main v2 set from storage arr_math:in var2
data modify storage arr_math:main out set value {num:[],dec:0,base:0,pol:1,rem:[]}

#checks to see if base values are the same for both numbers
execute store result score v1base= arr_math.main run data get storage arr_math:main v1.base
execute store result score v2base= arr_math.main run data get storage arr_math:main v2.base
execute unless score v1base= arr_math.main = v2base= arr_math.main run scoreboard players set error= arr_math.main 30
execute if score v1base= arr_math.main = v2base= arr_math.main run function arr_math:ops/div_check

data remove storage arr_math:main div
execute if score error= arr_math.main matches 20 run scoreboard players reset * arr_math.main
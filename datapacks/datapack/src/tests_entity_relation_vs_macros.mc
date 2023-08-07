dir a {
	function test {
		execute as c2e3ad20-c7e8-4596-8d86-ef13e810ccf7 on passengers on origin run scoreboard players set #x v 1
	}

	function setup {
		data merge storage a:test {}
		summon armor_stand ~ ~ ~ {UUID:[I;-1025266400,-941079146,-1920536813,-401552137],NoGravity:1b,Tags:["a.test"],Invisible:1b}
		LOOP(100,i) {
			execute summon armor_stand run {
				data merge entity @s {NoGravity:1b,Tags:["a.test"],Invisible:1b}
				data modify storage a:test UUID set from entity @s UUID
			}
			execute summon area_effect_cloud run {
				data merge entity @s {Tags:["a.test"],Age:-2147483648,Duration:-1,WaitTime:-2147483648}
				data modify entity @s Owner set from storage a:test UUID
				ride @s mount c2e3ad20-c7e8-4596-8d86-ef13e810ccf7
			}
		}
	}

	function cleanup {
		kill @e[tag=a.test]
		data remove storage a:test {}
	}
}

dir b {

	function test {
		execute store result storage b:test Index int 1 run scoreboard players set count b.test 1

		execute store result score size b.test if data storage b:test Targets[]

		data modify storage b:test CurrentTarget set from storage b:test Targets[0]

		function tests:b/test/recurse with storage b:test
	}

	dir test {
		function recurse {
			$execute as $(CurrentTarget) run scoreboard players set #x v 1
			execute store result storage b:test Index int 1 run scoreboard players add count b.test 1
			$data modify storage b:test CurrentTarget set from storage b:test Targets[$(Index)]

			execute unless score count b.test > size b.test run function $block with storage b:test
		}
	}

	function setup {
		data merge storage b:test {}
		LOOP(100,i) {
			execute summon armor_stand run {
				data merge entity @s {Tags:["b.test"],Invisible:1b}
				function string_uuid:string_uuid
				data modify storage b:test Targets append from storage string_uuid:output Text.hoverEvent.contents.id
			}
		}
	}

	function cleanup {
		kill @e[tag=b.test]
		scoreboard objectives remove b.test
		data remove storage b:test {}
	}
}
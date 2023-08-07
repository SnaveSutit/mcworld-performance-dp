dir a {
	function test {
		execute as c2e3ad20-c7e8-4596-8d86-ef13e810ccf7 on passengers on origin run say hi
	}

	function setup {
		data merge storage a:test {}
		scoreboard objectives add a.test dummy
		scoreboard players set 1000 a.test 1000
		scoreboard players set count a.test 0
		summon armor_stand ~ ~ ~ {UUID:[I;-1025266400,-941079146,-1920536813,-401552137],Tags:["a.test"]}
		{
			execute summon armor_stand run {
				data merge entity @s {Tags:["test.a"]}
				data modify storage a:test UUID set from entity @s UUID
			}
			execute summon snowball run {
				data merge entity @s {NoGravity:1b,Tags:["a.test"]}
				data modify entity @s Owner set from storage a:test UUID
				ride @s mount c2e3ad20-c7e8-4596-8d86-ef13e810ccf7
			}
			execute unless score count a.test > 1000 a.test run function $block
		}
	}

	function cleanup {
		kill @e[tag=a.test]
		scoreboard objectives remove a.test
		data remove storage a:test {}
	}
}
	
dir b {

	function test {
		execute store result storage b:test Index int 1 run scoreboard players set count b.test 1

		execute store result score size b.test if storage b:test Targets[]

		data modify storage b:test CurrentTarget set from storage b:test Targets[0]

		function tests:b/test/recurse with storage b:test
	}

	dir test {
		function recurse {
			$execute as $(CurrentTarget) run say hi
			execute store result storage b:test Index int 1 run scoreboard players add count b.test 1
			$data modify storage b:test CurrentTarget set from storage b:test Targets[$(Index)]

			execute unless score count b.test > size b.test run function $block with storage b:test
		}
	}

	function setup {
		data merge storage b:test {}
		scoreboard objectives add b.test dummy
		scoreboard players set 1000 a.test 1000
		scoreboard players set count b.test 0
		execute summon armor_stand run {
			data merge entity @s {Tags:["b.test"]}
			function string_uuid:string_uuid
			data modify storage b:test Targets append from storage string_uuid:output Text.hoverEvent.contents.id
			execute unless score count b.test > 1000 b.test run function $block
		}
	}

	function cleanup {
		kill @e[tag=b.test]
		scoreboard objectives remove b.test
		data remove storage b:test {}
	}
}
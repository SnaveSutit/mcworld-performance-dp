# BEFORE MAKING YOUR TEST, Please create a fork, and a branch on that fork called `test-<your-test-comparison>`.
# For example: `test-entity-relation-vs-macros`
# This way I can easily merge it into the main repo, and it will be easy to find and swap out for other users.

dir a {
	function test {
		execute summon marker run {
			function string_uuid:string_uuid
			execute as c2e3ad20-c7e8-4596-8d86-ef13e810ccf7 run function tests:a/target with storage string_uuid:output Text.hoverEvent.contents
			kill @s
		}
	}
	function target {
		$execute as $(id) run scoreboard players set #x v 1
	}
	function setup {
		data merge storage a:test {}
		summon marker ~ ~ ~ {UUID:[I;-1025266400,-941079146,-1920536813,-401552137]}
	}
	function cleanup {
		data remove storage a:test {}
		kill c2e3ad20-c7e8-4596-8d86-ef13e810ccf7
	}
}
dir b {
	function test {
		execute summon marker run {
			function gu:generate
			execute as c2e3ad20-c7e8-4596-8d86-ef13e810ccf7 run function tests:b/target with storage gu:main
			kill @s
		}
	}
	function target {
		$execute as $(out) run scoreboard players set #x v 1
	}
	function setup {
		data merge storage b:test {}
		summon marker ~ ~ ~ {UUID:[I;-1025266400,-941079146,-1920536813,-401552137]}
	}
	function cleanup {
		data remove storage b:test {}
		kill c2e3ad20-c7e8-4596-8d86-ef13e810ccf7
	}
}
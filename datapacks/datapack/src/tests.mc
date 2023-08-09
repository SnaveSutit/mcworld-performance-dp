# BEFORE MAKING YOUR TEST, Please create a fork, and a branch on that fork called `test-<your-test-comparison>`.
# For example: `test-entity-relation-vs-macros`
# This way I can easily merge it into the main repo, and it will be easy to find and swap out for other users.

function settings {
	# How many ticks to run the tests for. Higher values provide more accurate data, but take longer. (Default: 1200)
	# WARNING: Large values (higher than 1200) or really fast tests (with iteration counts > 20k) can cause the scoreboards values to overflow, making the results useless.
	# At 1200 (about 60 seconds per test at 50ms/t) there is a +-2% margin of error.
	# At 20 (about a second per test at 50ms/t) there is a +-3% margin of error.
	scoreboard players set .tick_count v 1200
	# Maximum time to use per tick (Default/Max 50).
	scoreboard players set .max_ms_per_tick v 50
	# The name of the first test. This is used to identify the test in the results.
	data modify storage perf_tool:ram test_a_name set value '{"text": "Mulv\'s UUID to string"}'
	# The name of the second test. This is used to identify the test in the results.
	data modify storage perf_tool:ram test_b_name set value '{"text": "Gibbs\'s UUID to string"}'
}

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
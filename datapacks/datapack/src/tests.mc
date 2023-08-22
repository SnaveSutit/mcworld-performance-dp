# BEFORE MAKING YOUR TEST, Please create a fork, and a branch on that fork called `test-<your-test-comparison>`.
# For example: `test-entity-relation-vs-macros`
# This way I can easily merge it into the main repo, and it will be easy to find and swap out for other users.

function settings {
	# How many ticks to run the tests for. Higher values provide more accurate data, but take longer. (Default: 1200)
	# At 1200 (about 60 seconds per test at 50ms/t) there is a +-0.01% margin of error.
	# At 20 (about a second per test at 50ms/t) there is a +-0.02% margin of error.
	scoreboard players set .tick_count v 1200
	# Maximum time to use per tick (Default/Max 50).
	scoreboard players set .max_ms_per_tick v 50
	# The name of the first test. This is used to identify the test in the results.
	data modify storage perf_tool:ram test_a_name set value '{"text": "Tag Branch Selection"}'
	# The name of the second test. This is used to identify the test in the results.
	data modify storage perf_tool:ram test_b_name set value '{"text": "Macro UUID list Selection"}'
}

dir a {
	function test {
		# Everything ran from this function will count towards the time spent on the test.
		execute as @e[type=marker,tag=test.a] at @s run function tests:a/test/branch
	}

	dir test {
		# Any extra functions required for test can be put here
		function branch {
			LOOP(50, i) {
				execute if entity @s[tag=tag.<%i%>] run scoreboard players add #x v 1
			}
		}
	}

	function setup {
		# This function will be run before the performance test begins.
		scoreboard players set #x v 0
		LOOP(50, i) {
			summon marker ~ ~ ~ {Tags:['test.a','tag.<%i%>']}
		}
	}

	function cleanup {
		# This function will be run after the performance test ends.
		kill @e[type=marker,tag=test.a]
	}
}

dir b {
	function test {
		# Everything ran from this function will count towards the time spent on the test.
		execute store result score #count v if data storage tests:b list[]
		data modify storage tests:b copy set from storage tests:b list
		function tests:b/test/iter
	}

	dir test {
		# Any extra functions required for test can be put here
		function iter {

			data modify storage tests:b_args uuid set from storage tests:b list[-1]
			data remove storage tests:b list[-1]

			function tests:b/test/select with storage tests:b_args

			scoreboard players remove #count v 1
			execute if score #count v matches 1.. run function $block
		}

		function select {
			$execute as $(uuid) run scoreboard players add #x v 1
		}
	}

	function setup {
		# This function will be run before the performance test begins.
		scoreboard players set #x v 0
		data modify storage tests:b list set value []
		LOOP(50, i) {
			execute summon marker run {
				tag @s add test.b
				function gu:generate
				data modify storage tests:b list append from storage gu:main out
			}
		}
	}

	function cleanup {
		# This function will be run after the performance test ends.
		kill @e[type=marker,tag=test.b]
	}
}

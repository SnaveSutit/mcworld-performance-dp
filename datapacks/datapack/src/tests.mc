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
	data modify storage perf_tool:ram test_a_name set value '{"text": "M.U.D. Macro UUID Directory"}'
	# The name of the second test. This is used to identify the test in the results.
	data modify storage perf_tool:ram test_b_name set value '{"text": "@e -> @s[tag=...]"}'
}

dir a {
	function test {
		#execute as @e[tag=item] run scoreboard players add x test 1

		#ticking known entities
		data modify storage mud:main tick set from storage mud:main tick_entries
		data remove storage mud:temp entity
		data modify storage mud:temp entity set from storage mud:main tick[-1]
		data remove storage mud:main tick[-1]
		execute if data storage mud:temp entity.uuid run function mud:__internal/tick_all

		#checking list
		execute if data storage mud:main tick_entries[0] run function mud:__internal/death_check

		#iterating fake gametime
		scoreboard players add gametime mud.time 1
	}

	function target {
		scoreboard players add #x v 1
	}

	function setup {
		scoreboard players set #x v 0
		LOOP(100,i){
			execute positioned 0 2 0 summon marker run function mud:register {"command":"function tests:a/target","setup":""}
			LOOP(10,x){
				summon marker 0 2 0 {Tags:["a.i"]}
			}
		}
	}

	function cleanup {
		kill @e[type=marker]
		scoreboard players set #x v 0
	}
}

dir b {
	function test {
		execute as @e run function tests:b/target
	}

	function target {
		execute if entity @s[tag=b.test] run scoreboard players add #x v 1
	}

	function setup {
		scoreboard players set #x v 0
		LOOP(100,i) {
			summon marker 0 2 0 {Tags:["b.test"]}
			LOOP(10,x){
				summon marker 0 2 0 {Tags:["b.i"]}
			}
		}
	}

	function cleanup {
		kill @e[type=marker]
		scoreboard players set #x v 0
	}
}
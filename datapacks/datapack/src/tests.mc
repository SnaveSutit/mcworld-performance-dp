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
	# The name of the comparison. This is used to identify the test in the results.
	data modify storage perf_tool:ram comparison_name set value '{"text": "A vs B"}'
	# The name of the first test. This is used to identify the test in the results.
	data modify storage perf_tool:ram test_a_name set value '{"text": "My Test A"}'
	# The name of the second test. This is used to identify the test in the results.
	data modify storage perf_tool:ram test_b_name set value '{"text": "My Test B"}'
}

dir a {
	function test {
		execute store result score #value v run random value 0..1023
		function tests:a/test/0_1023
		# LOOP(1000, i) {
		# 	execute if score #value v matches <%i%> run return run function tests:a/test/<%i%>
		# }
	}

	dir test {
		LOOP(config.functions, func) {
			function <%func.id%> {
				<%%
					emit(func.content.join('\n'))
				%%>
			}
		}
		# LOOP(1000, i) {
		# 	function <%i%> {
		# 		scoreboard players set #out v <%i%>
		# 	}
		# }
	}

	function setup {
	}

	function cleanup {
	}
}

dir b {

	function test {
		execute store result storage test:input #value int 1 run random value 1..1024
		function tests:b/test/choose with storage test:input
	}

	dir test {
		function choose {
			$function tests:b/test/$(value)
		}
		LOOP(1024, i) {
			function <%i%> {
				scoreboard players set #out v <%i%>
			}
		}
	}

	function setup {
	}

	function cleanup {
	}
}
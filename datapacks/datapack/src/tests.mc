
function settings {
	# How many ticks to run the tests for. Higher values provide more accurate data, but take longer. (Default: 1200)
	# WARNING: Large values (higher than 1200) or really fast tests (with iteration counts > 20k) can cause the scoreboards values to overflow, making the results useless.
	# At 1200 (about 60 seconds per test at 50ms/t) there is a +-2% margin of error.
	# At 20 (about a second per test at 50ms/t) there is a +-3% margin of error.
	scoreboard players set .tick_count v 1200
	# Maximum time to use per tick (Default/Max 50).
	scoreboard players set .max_ms_per_tick v 50
	# The name of the first test. This is used to identify the test in the results.
	data modify storage perf_tool:ram test_a_name set value '{"text": "Macro Dynamic Index List Iteration"}'
	# The name of the second test. This is used to identify the test in the results.
	data modify storage perf_tool:ram test_b_name set value '{"text": "Copy Reverse List Iteration"}'
}

dir a {
	function test {
		execute store result score #count v if data storage a:foo list[]
		execute store result storage a:foo input.index int 1 run scoreboard players set #index v 0
		function tests:a/test/iterate with storage a:foo input
	}

	dir test {
		function iterate {
			$data modify storage a:foo out set from storage a:foo list[$(index)]
			execute store result storage a:foo input.index int 1 run scoreboard players add #index v 1
			execute if score #index v < #count v run function $block with storage a:foo input
		}
	}

	function setup {
		<%%
			config.x = []
			for (let i=0; i<10000; i++) {
				config.x.push(config.crypto.randomUUID())
			}
		%%>
		data modify storage a:foo list set value [<%config.x.map(v => JSON.stringify(v))%>]
		data remove storage a:foo out
		data modify storage a:foo input.index set value -1
	}

	function cleanup {
	}
}

dir b {

	function test {
		execute store result score #count v if data storage b:foo list[]
		data modify storage b:foo copied_list set from storage b:foo list
		function tests:b/test/iterate
	}

	dir test {
		function iterate {
			data modify storage b:foo out set from storage b:foo copied_list[-1]
			data remove storage b:foo copied_list[-1]
			scoreboard players remove #count v 1
			execute if score #count v matches 1.. run function $block
		}
	}

	function setup {
		data modify storage b:foo list set value [<%config.x.map(v => JSON.stringify(v))%>]
		data remove storage b:foo copied_list
		data remove storage b:foo out
	}

	function cleanup {
	}
}

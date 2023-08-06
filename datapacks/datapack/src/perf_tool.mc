
function load {

	scoreboard objectives add i dummy
	scoreboard objectives add value dummy

	scoreboard players set -1 value -1
	scoreboard players set 100 value 100
	scoreboard players set #worldborder.sub value 59999968
	worldborder warning distance 0

	gamerule maxCommandChainLength 1000000000

	# For how many ticks to gather data before stopping. More ticks = more consistant data (Default: 1000)
	scoreboard players set .tick_count value 100
	# Maximum time to use per tick (Default 50)
	scoreboard players set .max_ms_per_tick value 50

	tellraw @a ["", {"text":"[","color":"dark_gray"},{"text":"- Reloaded! -","color":"aqua"},{"text":"]","color":"dark_gray"}]
}

function start_comparison {
	scoreboard players set .is_comparison value 1
	scoreboard players set .func_to_run value 0
	schedule function perf_tool:zzzstart_internal 1t
}

function zzzstart_internal {
	tellraw @a ["\n", {"text":"[","color":"dark_gray"},{"text":"----- Test A ------","color":"aqua"},{"text":"]","color":"dark_gray"}]
	tellraw @a [{"text":"|◘ ","color":"dark_gray"}, {"text":"Starting Setup...","color":"aqua"}]
	function tests:a/setup
	tellraw @a [{"text":"|◘ ","color":"dark_gray"}, {"text":"Setup Complete!","color":"green"}]
	function perf_tool:init_iter
	schedule function perf_tool:iter 1t
}

function start_single {
	scoreboard players set .is_comparison value 0
	scoreboard players set .func_to_run value 0
	schedule function perf_tool:zzzstart_internal 1t
}

function init_iter {
	scoreboard players set .total_ms value 0
	scoreboard players set .total_iter value 0

	scoreboard players set .min_ms value 2147483647
	scoreboard players set .max_ms value 0

	scoreboard players set .min_iter value 2147483647
	scoreboard players set .max_iter value 0

	scoreboard players operation .loop value = .tick_count value
	tellraw @a [{"text":"|◘ ","color":"dark_gray"}, {"text":"Running Test...","color":"aqua"}]
	data modify storage perf_tool:ram iterations set value []
}

function do_a {
	function perf_tool:worldborder/reset
	block {
		function tests:a/test

		function perf_tool:worldborder/get
		scoreboard players add .iter value 1

		execute unless score .delta value >= .max_ms_per_tick value run function $block
	}
}

function do_b {
	function perf_tool:worldborder/reset
	block {
		function tests:b/test

		function perf_tool:worldborder/get
		scoreboard players add .iter value 1

		execute unless score .delta value >= .max_ms_per_tick value run function $block
	}
}

function iter {

	scoreboard players set .iter value 0

	execute if score .func_to_run value matches 0 run function perf_tool:do_a
	execute if score .func_to_run value matches 1 run function perf_tool:do_b

	scoreboard players operation .total_ms value += .delta value
	scoreboard players operation .total_iter value += .iter value

	scoreboard players operation .max_ms value > .delta value
	scoreboard players operation .max_iter value > .iter value

	scoreboard players operation .min_ms value < .delta value
	scoreboard players operation .min_iter value < .iter value

	# data modify storage perf_tool:ram iterations append value { ms_delta:-1, iter_delta:-1 }
	# execute store result storage perf_tool:ram iterations[-1].ms int 1 run scoreboard players get .delta value
	# execute store result storage perf_tool:ram iterations[-1].iter int 1 run scoreboard players get .iter value

	title @a times 0 5 0
	title @a title ["", {"text":"Perf Tool Running...","color":"green"}]
	title @a actionbar ["", {"text":"Iter/t: ","color":"gray"}, {"score":{"name":".iter","objective":"value"},"color":"aqua"}, {"text":" | ","color":"dark_gray"}, {"text":"ms/t: ","color":"gray"}, {"score":{"name":".delta","objective":"value"},"color":"aqua"}, {"text":" | ","color":"dark_gray"}, {"text":"Total ms: ","color":"gray"}, {"score":{"name":".total_ms","objective":"value"},"color":"aqua"}, {"text":" | ","color":"dark_gray"}, {"text":"Total iter: ","color":"gray"}, {"score":{"name":".total_iter","objective":"value"},"color":"aqua"}, {"text":" | ","color":"dark_gray"}, {"text":"Ticks Remaining: ","color":"gray"}, {"score":{"name":".loop","objective":"value"},"color":"aqua"}]

	scoreboard players remove .loop value 1
	execute(if score .loop value matches 1..){
		schedule function $top 1t
	} else {
		#> Calculate averages
		# ms
		scoreboard players operation .avg_ms value = .total_ms value
		scoreboard players operation .avg_ms value /= .tick_count value
		# iter
		scoreboard players operation .avg_iter value = .total_iter value
		scoreboard players operation .avg_iter value /= .tick_count value

		execute(if score .is_comparison value matches 1){
			tellraw @a [{"text":"|◘ ","color":"dark_gray"}, {"text":"Test Complete!","color":"green"}]
			function perf_tool:save_readout
			function perf_tool:readout_single
			tellraw @a [{"text":"|◘ ","color":"dark_gray"}, {"text":"Starting Cleanup...","color":"aqua"}]
			function tests:a/cleanup
			tellraw @a [{"text":"'◘ ","color":"dark_gray"}, {"text":"Cleanup Complete!","color":"green"}]
			scoreboard players set .is_comparison value 2
			scoreboard players set .func_to_run value 1

			tellraw @a ["\n", {"text":"[","color":"dark_gray"},{"text":"----- Test B ------","color":"aqua"},{"text":"]","color":"dark_gray"}]
			tellraw @a [{"text":"|◘ ","color":"dark_gray"}, {"text":"Starting Setup...","color":"aqua"}]
			function tests:b/setup
			tellraw @a [{"text":"|◘ ","color":"dark_gray"}, {"text":"Setup Complete!","color":"green"}]
			function perf_tool:init_iter
			schedule function perf_tool:iter 1t

		}else execute(if score .is_comparison value matches 2){
			tellraw @a [{"text":"|◘ ","color":"dark_gray"}, {"text":"Test Complete!","color":"green"}]
			function perf_tool:readout_single
			tellraw @a [{"text":"|◘ ","color":"dark_gray"}, {"text":"Starting Cleanup...","color":"aqua"}]
			function tests:b/cleanup
			tellraw @a [{"text":"'◘ ","color":"dark_gray"}, {"text":"Cleanup Complete!","color":"green"}]
			function perf_tool:readout_comparison

		}else{
			tellraw @a [{"text":"|◘ ","color":"dark_gray"}, {"text":"Test Complete!","color":"green"}]
			function perf_tool:readout_single
			tellraw @a [{"text":"|◘ ","color":"dark_gray"}, {"text":"Starting Cleanup...","color":"aqua"}]
			function tests:a/cleanup
			tellraw @a [{"text":"'◘ ","color":"dark_gray"}, {"text":"Cleanup Complete!","color":"green"}]
		}
	}
}

function save_readout {
	data modify storage perf_tool:ram last_readout set value { total_ms:0, total_iter:0, max_ms:0, min_ms:0, max_iter:0, min_iter:0, avg_ms:0, avg_iter:0 }

	execute store result storage perf_tool:ram last_readout.total_ms int 1 run scoreboard players get .total_ms value
	execute store result storage perf_tool:ram last_readout.total_iter int 1 run scoreboard players get .total_iter value
	execute store result storage perf_tool:ram last_readout.min_ms int 1 run scoreboard players get .min_ms value
	execute store result storage perf_tool:ram last_readout.max_ms int 1 run scoreboard players get .max_ms value
	execute store result storage perf_tool:ram last_readout.min_iter int 1 run scoreboard players get .min_iter value
	execute store result storage perf_tool:ram last_readout.max_iter int 1 run scoreboard players get .max_iter value
	execute store result storage perf_tool:ram last_readout.avg_ms int 1 run scoreboard players get .avg_ms value
	execute store result storage perf_tool:ram last_readout.avg_iter int 1 run scoreboard players get .avg_iter value
}

function readout_single {
	# tellraw @a ""
	tellraw @a [{"text":"|","color":"dark_gray"}]
	tellraw @a [{"text":"|◘[","color":"dark_gray"},{"text":"----- Overview ------","color":"aqua"},{"text":"]","color":"dark_gray"}]
	tellraw @a [{"text":"| |◘ ","color":"dark_gray"}, {"text":"Ticks Spanned: ","color":"gray"}, {"score": {"name": ".tick_count","objective": "value"},"color":"aqua"}]
	tellraw @a [{"text":"| |","color":"dark_gray"}]
	tellraw @a [{"text":"| |◘[","color":"dark_gray"}, {"text": " Totals ", "color":"aqua"},{"text":"]","color":"dark_gray"}]
	tellraw @a [{"text":"| | |◘ ","color":"dark_gray"}, {"text": "ms: ","color":"gray"},{"score":{"name": ".total_ms","objective": "value"},"color":"aqua"}]
	tellraw @a [{"text":"| | '◘ ","color":"dark_gray"}, {"text": "Iterations: ","color":"gray"},{"score":{"name": ".total_iter","objective": "value"},"color":"aqua"}]
	#tellraw @a [{"text":"|◘","color":"dark_gray"}, {"text": "Total commands ran: ","color":"gray"},{"score":{"name": "#total.commands","objective": "value"},"color":"aqua"}]
	tellraw @a [{"text":"| |","color":"dark_gray"}]
	tellraw @a [{"text":"| |◘[","color":"dark_gray"}, {"text": " Averages ", "color":"aqua"},{"text":"]","color":"dark_gray"}]

	execute(if score .avg.ms value > .max_ms_per_tick value){
		tellraw @a [{"text":"| | |◘ ","color":"dark_gray"}, {"text": "ms/t: ","color":"gray"},{"score":{"name": ".avg_ms","objective": "value"},"color":"red"}]
	} else {
		tellraw @a [{"text":"| | |◘ ","color":"dark_gray"}, {"text": "ms/t: ","color":"gray"},{"score":{"name": ".avg_ms","objective": "value"},"color":"aqua"}]
	}
	#tellraw @a [{"text":"|◘ ","color":"dark_gray"}, {"text": "Avg Commands/t: ","color":"gray"},{"score":{"name": "#avg.commands","objective": "value"},"color":"aqua"}]
	tellraw @a [{"text":"| | '◘ ","color":"dark_gray"}, {"text": "Iterations/t: ","color":"gray"},{"score":{"name": ".avg_iter","objective": "value"},"color":"aqua"}]

	tellraw @a [{"text":"| |","color":"dark_gray"}]
	tellraw @a [{"text":"| '◘[","color":"dark_gray"}, {"text": " Min/Max ", "color":"aqua"},{"text":"]","color":"dark_gray"}]
	tellraw @a [{"text":"|   |◘ ","color":"dark_gray"}, {"text": "ms/t: ","color":"gray"},{"score":{"name": ".min_ms","objective": "value"},"color":"aqua"},{"text":"/","color":"gray"},{"score":{"name": ".max_ms","objective": "value"},"color":"aqua"}]
	tellraw @a [{"text":"|   '◘ ","color":"dark_gray"}, {"text": "Iterations/t: ","color":"gray"},{"score":{"name": ".min_iter","objective": "value"},"color":"aqua"},{"text":"/","color":"gray"},{"score":{"name": ".max_iter","objective": "value"},"color":"aqua"}]
	tellraw @a [{"text":"|","color":"dark_gray"}]

}

function readout_comparison {

	execute store result score .a.total_iter value run data get storage perf_tool:ram last_readout.total_iter
	scoreboard players operation .b.total_iter value = .total_iter value

	execute(if score .a.total_iter value >= .b.total_iter value){
		scoreboard players operation .b.total_iter value *= 100 value
		scoreboard players operation .total_iter_comp value = .b.total_iter value
		scoreboard players operation .total_iter_comp value /= .a.total_iter value
		# scoreboard players operation .total_iter_comp value *= 100 value
		# scoreboard players operation .total_iter_comp value -= 100 value

		scoreboard players set .output value 100
		scoreboard players operation .output value -= .total_iter_comp value
		tellraw @a ["", {"text":"Test B ran "}, {"score":{"name":".output","objective":"value"}}, {"text":"% slower than Test A"}]

	}else execute(if score .a.total_iter value < .b.total_iter value){
		scoreboard players operation .a.total_iter value *= 100 value
		scoreboard players operation .total_iter_comp value = .a.total_iter value
		scoreboard players operation .total_iter_comp value /= .b.total_iter value
		# scoreboard players operation .total_iter_comp value *= 100 value
		# scoreboard players operation .total_iter_comp value -= 100 value

		scoreboard players set .output value 100
		scoreboard players operation .output value -= .total_iter_comp value
		tellraw @a ["", {"text":"Test A ran "}, {"score":{"name":".output","objective":"value"}}, {"text":"% slower than Test B"}]
	}
}

dir worldborder {
	function get {
		execute store result score .delta value run worldborder get
		scoreboard players operation .delta value -= #worldborder.sub value
		execute if score .delta value matches ..-1 run scoreboard players operation .delta value *= -1 value
	}

	function reset {
		worldborder set 59999968
		worldborder set 59989968 10
	}
}


function load {

	scoreboard objectives add i dummy
	scoreboard objectives add v dummy

	scoreboard players set -1 v -1
	scoreboard players set 100 v 100
	scoreboard players set #worldborder.sub v 59999968
	worldborder warning distance 0

	# gamerule maxCommandChainLength 1000
	gamerule maxCommandChainLength 1000000000

	# For how many ticks to gather data before stopping. More ticks = more consistant data (Default: 1000)
	scoreboard players set .tick_count v 1000
	# Maximum time to use per tick (Default 50)
	scoreboard players set .max_ms_per_tick v 50

	bossbar add progress "Progress"
	bossbar set minecraft:progress players @a
	bossbar set minecraft:progress color purple
	bossbar set minecraft:progress value 0
	execute store result bossbar minecraft:progress max run scoreboard players get .tick_count v

	bossbar add iterations_per_tick {"text":"iter/t: ","color":"gray"}
	# bossbar set minecraft:iterations_per_tick players @a
	bossbar set minecraft:iterations_per_tick color pink
	bossbar set minecraft:iterations_per_tick value 0
	bossbar set minecraft:iterations_per_tick max 1

	bossbar add ms_per_tick {"text":"ms/t","color":"gray"}
	# bossbar set minecraft:ms_per_tick players @a
	bossbar set minecraft:ms_per_tick color green
	bossbar set minecraft:ms_per_tick value 0
	bossbar set minecraft:ms_per_tick max 1

	function perf_tool:reset

	tellraw @a ["", {"text":"[","color":"dark_gray"},{"text":"- Reloaded! -","color":"aqua"},{"text":"]","color":"dark_gray"}]
}

function reset {
	schedule clear perf_tool:iter
	bossbar set minecraft:progress name ["", {"text":"[Inactive]","color":"gray"}]
	bossbar set minecraft:iterations_per_tick players
	bossbar set minecraft:ms_per_tick players
}

function start_comparison {
	scoreboard players set .is_comparison v 1
	scoreboard players set .func_to_run v 0
	schedule function perf_tool:zzzstart_internal 1t
}

function zzzstart_internal {

	bossbar set minecraft:progress players @a
	bossbar set minecraft:iterations_per_tick players @a
	bossbar set minecraft:ms_per_tick players @a

	bossbar set minecraft:progress value 0
	execute store result bossbar minecraft:progress max run scoreboard players get .tick_count v

	bossbar set minecraft:iterations_per_tick value 0
	bossbar set minecraft:iterations_per_tick max 1

	bossbar set minecraft:ms_per_tick value 0
	bossbar set minecraft:ms_per_tick max 1

	bossbar set minecraft:ms_per_tick color green

	tellraw @a ["\n", {"text":"[","color":"dark_gray"},{"text":"----- Test A ------","color":"aqua"},{"text":"]","color":"dark_gray"}]
	tellraw @a [{"text":"|◘ ","color":"dark_gray"}, {"text":"Starting Setup...","color":"aqua"}]
	function tests:a/setup
	tellraw @a [{"text":"|◘ ","color":"dark_gray"}, {"text":"Setup Complete!","color":"green"}]
	function perf_tool:init_iter
	schedule function perf_tool:iter 1t
}

function start_single {
	scoreboard players set .is_comparison v 0
	scoreboard players set .func_to_run v 0
	schedule function perf_tool:zzzstart_internal 1t
}

function init_iter {
	scoreboard players set .total_ms v 0
	scoreboard players set .total_iter v 0

	scoreboard players set .min_ms v 2147483647
	scoreboard players set .max_ms v 0

	scoreboard players set .min_iter v 2147483647
	scoreboard players set .max_iter v 0

	scoreboard players operation .loop v = .tick_count v
	tellraw @a [{"text":"|◘ ","color":"dark_gray"}, {"text":"Running Test...","color":"aqua"}]
	data modify storage perf_tool:ram iterations set value []
}

function do_a {
	function perf_tool:worldborder/reset
	block {
		function tests:a/test

		function perf_tool:worldborder/get
		scoreboard players add .iter v 1

		execute unless score .delta v >= .max_ms_per_tick v run function $block
	}
}

function do_b {
	function perf_tool:worldborder/reset
	block {
		function tests:b/test

		function perf_tool:worldborder/get
		scoreboard players add .iter v 1

		execute unless score .delta v >= .max_ms_per_tick v run function $block
	}
}

function iter {

	scoreboard players set .iter v 0

	execute if score .func_to_run v matches 0 run function perf_tool:do_a
	execute if score .func_to_run v matches 1 run function perf_tool:do_b

	scoreboard players operation .total_ms v += .delta v
	scoreboard players operation .total_iter v += .iter v

	scoreboard players operation .max_ms v > .delta v
	scoreboard players operation .max_iter v > .iter v

	scoreboard players operation .min_ms v < .delta v
	scoreboard players operation .min_iter v < .iter v

	# data modify storage perf_tool:ram iterations append v { ms_delta:-1, iter_delta:-1 }
	# execute store result storage perf_tool:ram iterations[-1].ms int 1 run scoreboard players get .delta v
	# execute store result storage perf_tool:ram iterations[-1].iter int 1 run scoreboard players get .iter v

	scoreboard players set #loops v 1000
	scoreboard players operation #loops v -= .loop v
	execute store result bossbar minecraft:progress value run scoreboard players get #loops v

	execute store result bossbar minecraft:iterations_per_tick value run scoreboard players get .iter v
	execute store result bossbar minecraft:iterations_per_tick max run scoreboard players get .max_iter v

	(
		bossbar set minecraft:iterations_per_tick name ["",
			{"text":"iter/t","color":"gray"},
			{"text":" (","color":"dark_gray"},
			{"score":{"name":".min_iter", "objective":"v"},"color":"red"},
			{"text":"/","color":"dark_gray"},
			{"score":{"name":".iter", "objective":"v"},"color":"aqua"},
			{"text":"/","color":"dark_gray"},
			{"score":{"name":".max_iter", "objective":"v"},"color":"green"},
			{"text":")","color":"dark_gray"}
		]
	)

	execute store result bossbar minecraft:ms_per_tick value run scoreboard players get .delta v
	execute store result bossbar minecraft:ms_per_tick max run scoreboard players get .max_ms v
	(
		bossbar set minecraft:ms_per_tick name ["",
			{"text":"ms/t","color":"gray"},
			{"text":" (","color":"dark_gray"},
			{"score":{"name":".min_ms", "objective":"v"},"color":"green"},
			{"text":"/","color":"dark_gray"},
			{"score":{"name":".delta", "objective":"v"},"color":"aqua"},
			{"text":"/","color":"dark_gray"},
			{"score":{"name":".max_ms", "objective":"v"},"color":"red"},
			{"text":")","color":"dark_gray"}
		]
	)
	execute if score .delta v matches ..50 run {
		bossbar set minecraft:ms_per_tick color green
	}
	execute if score .delta v matches 51..100 run {
		bossbar set minecraft:ms_per_tick color yellow
	}
	execute if score .delta v matches 101..150 run {
		bossbar set minecraft:ms_per_tick color red
	}

	title @a times 0 5 0
	title @a title ["", {"text":"Perf Tool Running...","color":"green"}]
	execute if score .func_to_run v matches 0 run title @a subtitle ["", {"text":"Test A","color":"aqua"}]
	execute if score .func_to_run v matches 1 run title @a subtitle ["", {"text":"Test B","color":"aqua"}]
	bossbar set minecraft:progress name ["", {"text":"Total ms: ","color":"gray"}, {"score":{"name":".total_ms","objective":"v"},"color":"aqua"}, {"text":" | ","color":"dark_gray"}, {"text":"Total iter: ","color":"gray"}, {"score":{"name":".total_iter","objective":"v"},"color":"aqua"}]

	scoreboard players remove .loop v 1
	execute(if score .loop v matches 1..){
		schedule function $top 1t
	} else {
		#> Calculate averages
		# ms
		scoreboard players operation .avg_ms v = .total_ms v
		scoreboard players operation .avg_ms v /= .tick_count v
		# iter
		scoreboard players operation .avg_iter v = .total_iter v
		scoreboard players operation .avg_iter v /= .tick_count v

		execute(if score .is_comparison v matches 1){
			tellraw @a [{"text":"|◘ ","color":"dark_gray"}, {"text":"Test Complete!","color":"green"}]
			function perf_tool:save_readout
			function perf_tool:readout_single
			tellraw @a [{"text":"|◘ ","color":"dark_gray"}, {"text":"Starting Cleanup...","color":"aqua"}]
			function tests:a/cleanup
			tellraw @a [{"text":"'◘ ","color":"dark_gray"}, {"text":"Cleanup Complete!","color":"green"}]
			scoreboard players set .is_comparison v 2
			scoreboard players set .func_to_run v 1

			tellraw @a ["\n", {"text":"[","color":"dark_gray"},{"text":"----- Test B ------","color":"aqua"},{"text":"]","color":"dark_gray"}]
			tellraw @a [{"text":"|◘ ","color":"dark_gray"}, {"text":"Starting Setup...","color":"aqua"}]
			function tests:b/setup
			tellraw @a [{"text":"|◘ ","color":"dark_gray"}, {"text":"Setup Complete!","color":"green"}]
			function perf_tool:init_iter
			schedule function perf_tool:iter 1t

		}else execute(if score .is_comparison v matches 2){
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

	execute store result storage perf_tool:ram last_readout.total_ms int 1 run scoreboard players get .total_ms v
	execute store result storage perf_tool:ram last_readout.total_iter int 1 run scoreboard players get .total_iter v
	execute store result storage perf_tool:ram last_readout.min_ms int 1 run scoreboard players get .min_ms v
	execute store result storage perf_tool:ram last_readout.max_ms int 1 run scoreboard players get .max_ms v
	execute store result storage perf_tool:ram last_readout.min_iter int 1 run scoreboard players get .min_iter v
	execute store result storage perf_tool:ram last_readout.max_iter int 1 run scoreboard players get .max_iter v
	execute store result storage perf_tool:ram last_readout.avg_ms int 1 run scoreboard players get .avg_ms v
	execute store result storage perf_tool:ram last_readout.avg_iter int 1 run scoreboard players get .avg_iter v
}

function readout_single {
	# tellraw @a ""
	tellraw @a [{"text":"|","color":"dark_gray"}]
	tellraw @a [{"text":"|◘[","color":"dark_gray"},{"text":"----- Overview ------","color":"aqua"},{"text":"]","color":"dark_gray"}]
	tellraw @a [{"text":"| |◘ ","color":"dark_gray"}, {"text":"Ticks Spanned: ","color":"gray"}, {"score": {"name": ".tick_count","objective": "v"},"color":"aqua"}]
	tellraw @a [{"text":"| |","color":"dark_gray"}]
	tellraw @a [{"text":"| |◘[","color":"dark_gray"}, {"text": " Totals ", "color":"aqua"},{"text":"]","color":"dark_gray"}]
	tellraw @a [{"text":"| | |◘ ","color":"dark_gray"}, {"text": "ms: ","color":"gray"},{"score":{"name": ".total_ms","objective": "v"},"color":"aqua"}]
	tellraw @a [{"text":"| | '◘ ","color":"dark_gray"}, {"text": "Iterations: ","color":"gray"},{"score":{"name": ".total_iter","objective": "v"},"color":"aqua"}]
	#tellraw @a [{"text":"|◘","color":"dark_gray"}, {"text": "Total commands ran: ","color":"gray"},{"score":{"name": "#total.commands","objective": "v"},"color":"aqua"}]
	tellraw @a [{"text":"| |","color":"dark_gray"}]
	tellraw @a [{"text":"| |◘[","color":"dark_gray"}, {"text": " Averages ", "color":"aqua"},{"text":"]","color":"dark_gray"}]

	execute(if score .avg.ms v > .max_ms_per_tick v){
		tellraw @a [{"text":"| | |◘ ","color":"dark_gray"}, {"text": "ms/t: ","color":"gray"},{"score":{"name": ".avg_ms","objective": "v"},"color":"red"}]
	} else {
		tellraw @a [{"text":"| | |◘ ","color":"dark_gray"}, {"text": "ms/t: ","color":"gray"},{"score":{"name": ".avg_ms","objective": "v"},"color":"aqua"}]
	}
	#tellraw @a [{"text":"|◘ ","color":"dark_gray"}, {"text": "Avg Commands/t: ","color":"gray"},{"score":{"name": "#avg.commands","objective": "v"},"color":"aqua"}]
	tellraw @a [{"text":"| | '◘ ","color":"dark_gray"}, {"text": "Iterations/t: ","color":"gray"},{"score":{"name": ".avg_iter","objective": "v"},"color":"aqua"}]

	tellraw @a [{"text":"| |","color":"dark_gray"}]
	tellraw @a [{"text":"| '◘[","color":"dark_gray"}, {"text": " Min/Max ", "color":"aqua"},{"text":"]","color":"dark_gray"}]
	tellraw @a [{"text":"|   |◘ ","color":"dark_gray"}, {"text": "ms/t: ","color":"gray"},{"score":{"name": ".min_ms","objective": "v"},"color":"aqua"},{"text":"/","color":"gray"},{"score":{"name": ".max_ms","objective": "v"},"color":"aqua"}]
	tellraw @a [{"text":"|   '◘ ","color":"dark_gray"}, {"text": "Iterations/t: ","color":"gray"},{"score":{"name": ".min_iter","objective": "v"},"color":"aqua"},{"text":"/","color":"gray"},{"score":{"name": ".max_iter","objective": "v"},"color":"aqua"}]
	tellraw @a [{"text":"|","color":"dark_gray"}]

}

function readout_comparison {
	bossbar set minecraft:progress name ["", {"text":"[Inactive]","color":"gray"}]

	execute store result score .a.total_iter v run data get storage perf_tool:ram last_readout.total_iter
	scoreboard players operation .b.total_iter v = .total_iter v

	execute(if score .a.total_iter v >= .b.total_iter v){
		scoreboard players operation .b.total_iter v *= 100 v
		scoreboard players operation .total_iter_comp v = .b.total_iter v
		scoreboard players operation .total_iter_comp v /= .a.total_iter v
		# scoreboard players operation .total_iter_comp v *= 100 v
		# scoreboard players operation .total_iter_comp v -= 100 v

		scoreboard players set .output v 100
		scoreboard players operation .output v -= .total_iter_comp v
		tellraw @a ["", {"text":"Test B ran "}, {"score":{"name":".output","objective":"v"}}, {"text":"% slower than Test A"}]

	}else execute(if score .a.total_iter v < .b.total_iter v){
		scoreboard players operation .a.total_iter v *= 100 v
		scoreboard players operation .total_iter_comp v = .a.total_iter v
		scoreboard players operation .total_iter_comp v /= .b.total_iter v
		# scoreboard players operation .total_iter_comp v *= 100 v
		# scoreboard players operation .total_iter_comp v -= 100 v

		scoreboard players set .output v 100
		scoreboard players operation .output v -= .total_iter_comp v
		tellraw @a ["", {"text":"Test A ran "}, {"score":{"name":".output","objective":"v"}}, {"text":"% slower than Test B"}]
	}
	
	function perf_tool:reset
}

dir worldborder {
	function get {
		execute store result score .delta v run worldborder get
		scoreboard players operation .delta v -= #worldborder.sub v
		execute if score .delta v matches ..-1 run scoreboard players operation .delta v *= -1 v
	}

	function reset {
		worldborder set 59999968
		worldborder set 59989968 10
	}
}

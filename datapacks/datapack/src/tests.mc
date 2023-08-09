
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


dir a {
	function test {
		scoreboard players operation a i *= b i
	}

	function setup {
		scoreboard players set a i 2
		scoreboard players set b i 2
	}

	function cleanup {
		scoreboard players reset a i
		scoreboard players reset b i
	}
}

dir b {

	function test {
		scoreboard players set a i 2
	}

	function setup {
		# scoreboard players reset a i
	}

	function cleanup {
		scoreboard players reset a i
	}
}

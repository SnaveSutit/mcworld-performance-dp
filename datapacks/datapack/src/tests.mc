dir a {
	function test {
		execute store result score #value v run random value 1..1000
		LOOP(1000, i) {
			execute if score #value v matches <%i%> run return run function tests:a/test/<%i%>
		}
	}

	dir test {
		LOOP(1000, i) {
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

dir b {

	function test {
		execute store result storage test:input #value int 1 run random value 1..1000
		function tests:b/test/choose with storage test:input
	}

	dir test {
		function choose {
			$function tests:b/test/$(value)
		}
		LOOP(1000, i) {
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
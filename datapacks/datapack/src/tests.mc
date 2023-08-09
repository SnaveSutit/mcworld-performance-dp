# BEFORE MAKING YOUR TEST, Please create a fork, and a branch on that fork called `test-<your-test-comparison>`.
# For example: `test-entity-relation-vs-macros`
# This way I can easily merge it into the main repo, and it will be easy to find and swap out for other users.

dir a {
	function test {
		# Everything ran from this function will count towards the time spent on the test.
	}

	dir test {
		# Any extra functions required for test can be put here
	}

	function setup {
		# This function will be run before the performance test begins.
	}

	function cleanup {
		# This function will be run after the performance test ends.
	}
}

dir b {
	function test {
		# Everything ran from this function will count towards the time spent on the test.
	}

	dir test {
		# Any extra functions required for test can be put here
	}

	function setup {
		# This function will be run before the performance test begins.
	}

	function cleanup {
		# This function will be run after the performance test ends.
	}
}

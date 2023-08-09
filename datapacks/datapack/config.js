module.exports = {
	global: {
		onBuildSuccess: null,
	},
	mc: {
		dev: true,
		header: '# Developed by SnaveSutit\n# built using mc-build (https://github.com/mc-build/mc-build)',
		internalScoreboard: 'i',
		generatedDirectory: 'zzz',
		rootNamespace: null,
		// Crypto and treeGen are useful for generating UUIDs and optimized scoreboard trees respectively.
		// crypto: require('crypto'),
		functions: require('./treeGen'),
	},
}

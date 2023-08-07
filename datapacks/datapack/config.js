const crypto = require('crypto')

function generateSearchTree(items, trimmer) {
	const depth = () => Math.floor(Math.log(items.length) / Math.log(8))
	const remainingItems = [...items]
	let scoreIndex = 0
	function recurse(myDepth = 0) {
		const minScoreIndex = scoreIndex
		let maxScoreIndex = null
		const tree = []
		for (let i = 0; i < 8; i++) {
			if (remainingItems.length === 0) break
			if (myDepth < depth() && remainingItems.length >= 8 - i) {
				const item = recurse(myDepth + 1)
				if (trimmer && item) {
					if (trimmer(item)) tree.push(item)
				} else if (item) tree.push(item)
			} else {
				const item = {
					type: 'leaf',
					item: remainingItems.shift(),
					scoreIndex: scoreIndex,
				}
				if (trimmer && item) {
					if (trimmer(item)) tree.push(item)
				} else if (item) tree.push(item)
				scoreIndex++
			}
		}
		maxScoreIndex = scoreIndex - 1
		if (tree.length === 1) {
			if (trimmer && !trimmer(tree[0])) return
			return tree[0]
		}
		return { minScoreIndex, maxScoreIndex, items: tree, type: 'branch' }
	}
	return recurse()
}
let list = []
for (let i = 0; i < 100; i++) {
	list.push(i)
}
const tree = generateSearchTree(list)

const functions = []

function recurse(stick) {
	switch (stick.type) {
		case 'leaf':
			functions.push({
				id: stick.scoreIndex,
				content: [`scoreboard players set #x v ${stick.item}`],
			})
			break
		case 'branch':
			const content = []
			for (const item of item.items) {
				recurse(item)
				if (item.type === 'leaf') {
					content.push(
						`execute if score #x v matches ${item.scoreIndex} run function ${item.scoreIndex}`
					)
				} else {
					content.push(
						`execute if score #x v matches ${item.minScoreIndex}..${item.maxScoreIndex} run function ${item.minScoreIndex}_${item.maxScoreIndex}`
					)
				}
			}
			functions.push({ id: `${stick.minScoreIndex}_${stick.maxScoreIndex}`, content })
			break
	}
}

recurse(tree)

console.log(functions)

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
		crypto,
	},
}

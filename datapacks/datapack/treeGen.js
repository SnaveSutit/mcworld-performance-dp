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
for (let i = 0; i < 1024; i++) {
	list.push(i)
}
const tree = generateSearchTree(list)

const functions = []
function recurse(branch) {
	switch (branch.type) {
		case 'leaf':
			functions.push({
				id: branch.scoreIndex,
				content: [`scoreboard players set #x v ${branch.item}`],
			})
			break
		case 'branch':
			const content = []
			for (const item of branch.items) {
				recurse(item)
				if (item.type === 'leaf') {
					content.push(
						`execute if score #value v matches ${item.scoreIndex} run function tests:a/test/${item.scoreIndex}`
					)
				} else {
					content.push(
						`execute if score #value v matches ${item.minScoreIndex}..${item.maxScoreIndex} run function tests:a/test/${item.minScoreIndex}_${item.maxScoreIndex}`
					)
				}
			}
			functions.push({ id: `${branch.minScoreIndex}_${branch.maxScoreIndex}`, content })
			break
	}
}

recurse(tree)
// console.log(functions)

module.exports = functions

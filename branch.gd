## From the tutorial: https://jonoshields.com/post/bsp-dungeon

extends Node

class_name Branch

var left: Branch
var right: Branch
var position: Vector2i
var size: Vector2i

func _init(position_: Vector2i, size_: Vector2i):
	self.position = position_
	self.size = size_

func get_leaves() -> Array[Branch]:
	if not (left&&right):
		return [self]
	else:
		return left.get_leaves() + right.get_leaves()

func split(splits: int):
	if splits == 0:
		return
	
	var rng = RandomNumberGenerator.new()
	var split_percent: float = rng.randf_range(0.3, 0.7)

	if size.x > size.y:
		# vertical line split
		var left_width = int(size.x * split_percent)
		left = Branch.new(position, Vector2i(left_width, size.y))
		right = Branch.new(
			Vector2i(position.x + left_width, position.y),
			Vector2i(size.x - left_width, size.y)
		)
	else:
		# horizontal line split
		var left_height = int(size.y * split_percent)
		left = Branch.new(position, Vector2i(size.x, left_height))
		right = Branch.new(
			Vector2i(position.x, position.y + left_height),
			Vector2i(size.x, size.y - left_height)
		)
	
	left.split(splits - 1)
	right.split(splits - 1)

func center():
	return Vector2i(position.x + size.x / 2, position.y + size.y / 2)
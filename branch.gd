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

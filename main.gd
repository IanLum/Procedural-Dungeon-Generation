extends Node2D

const TILE_SIZE := 16
var root: Branch

func _ready():
	root = Branch.new(
		Vector2i(0, 0),
		Vector2i(60, 30)
	)
	queue_redraw()

func _draw():
	for leaf in root.get_leaves():
		draw_rect(
			Rect2(
				leaf.position.x * TILE_SIZE, # x
				leaf.position.y * TILE_SIZE, # y
				leaf.size.x * TILE_SIZE, # width
				leaf.size.y * TILE_SIZE # height
			),
			Color.GREEN,
			false
		)

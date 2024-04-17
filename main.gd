extends Node2D

const TILE_SIZE := 16

@onready var splits_selector = $CanvasLayer/NumSplits

var root: Branch

func _ready():
	root = Branch.new(
		Vector2i(0, 0),
		Vector2i(60, 30)
	)
	generate_rooms()

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

func generate_rooms():
	root.split(splits_selector.value)
	queue_redraw()

func _on_reroll_pressed():
	generate_rooms()

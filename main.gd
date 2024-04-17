extends Node2D

const TILE_SIZE := 16

@onready var tile_map = $TileMap
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
	place_room_tiles()
	queue_redraw()

func place_room_tiles():
	tile_map.clear()
	for leaf in root.get_leaves():
		for x in range(1, leaf.size.x - 1):
			for y in range(1, leaf.size.y - 1):
				tile_map.set_cell(
					0,
					Vector2i(x + leaf.position.x, y + leaf.position.y),
					1,
					Vector2i(0, 0)
				)

func _on_reroll_pressed():
	generate_rooms()

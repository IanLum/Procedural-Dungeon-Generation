extends Node2D

const TILE_SIZE := 16

@onready var tile_map = $TileMap

var root: Branch

func _ready():
	root = Branch.new(
		Vector2i(0, 0),
		Vector2i(60, 30)
	)
	full_generate()
#	tile_map.set_cell(0, Vector2i(0, 0), 0, Vector2i(0, 0))
#	tile_map.set_cells_terrain_connect(
#		0,
#		[Vector2i(0, 0)],
#		0,
#		0
#	)
#	tile_map.set_cells_terrain_path(
#		0,
#		[Vector2i(0, 2), Vector2i(1, 2), Vector2i(0, 3), Vector2i(1, 3)],
#		0,
#		0
#	)
#	tile_map.set_cells_terrain_connect(
#		0,
#		[Vector2i(0, -2), Vector2i(1, -2), Vector2i(0, -3), Vector2i(1, -3)],
#		0,
#		0
#	)

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

func full_generate():
	root.split(5)
	tile_map.clear()
	place_room_tiles()
	queue_redraw()

func place_terrain(tiles: Array[Vector2i]):
	tile_map.set_cells_terrain_connect(
		0, tiles, 0, 0
	)

func place_room_tiles():
	for leaf in root.get_leaves():
		print(leaf.position, leaf.size)
		var tiles: Array[Vector2i] = []
		for x in range(1, leaf.size.x - 1):
			for y in range(1, leaf.size.y - 1):
				tiles.append(Vector2i(x + leaf.position.x, y + leaf.position.y))
		place_terrain(tiles)

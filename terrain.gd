extends Node2D

const TILE_SIZE := 16

@onready var tile_map = $TileMap

func _ready():
	tile_map.set_cell(0, Vector2i(0, 0), 0, Vector2i(0, 0))
	tile_map.set_cells_terrain_path(
		0,
		[Vector2i(0, 2), Vector2i(1, 2), Vector2i(0, 3), Vector2i(1, 3)],
		0,
		0
	)
	tile_map.set_cells_terrain_connect(
		0,
		[Vector2i(0, -2), Vector2i(1, -2), Vector2i(0, -3), Vector2i(1, -3)],
		0,
		0
	)

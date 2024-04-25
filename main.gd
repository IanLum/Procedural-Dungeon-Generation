extends Node2D

const TILE_SIZE := 16
const PADDING := 1
const MIN_PARTITION_SIZE := 6	# This translates to a min room size of 2,
								# two tiles of padding, two tiles of walls,
								# then the last two tiles are the room

@onready var tile_map = $TileMap
@onready var splits_selector = $CanvasLayer/SpacePartitioning/NumSplits

var root: Branch

func _ready():
	root = Branch.new(
		Vector2i(0, 0),
		Vector2i(70, 50)
	)
	full_generate()

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
	root.split(splits_selector.value, MIN_PARTITION_SIZE)
	tile_map.clear()
	place_room_tiles()
	place_hallway_tiles()
	queue_redraw()

func place_terrain(tiles: Array[Vector2i]):
	tile_map.set_cells_terrain_connect(
		0, tiles, 0, 0
	)

func place_room_tiles():
	for leaf in root.get_leaves():
		var tiles: Array[Vector2i] = []
		for x in range(PADDING, leaf.size.x - PADDING):
			for y in range(PADDING, leaf.size.y - PADDING):
				tiles.append(Vector2i(x + leaf.position.x, y + leaf.position.y))
		place_terrain(tiles)

func place_hallway_tiles():
	var queue: Array[Branch] = [root]
	while not queue.is_empty():
		var curr: Branch = queue.pop_front()
		var left := curr.left
		var right := curr.right
		if not (left and right):
			continue
		
		queue.append_array([left, right])
		var left_center := left.center()
		var right_center := right.center()
		var tiles: Array[Vector2i] = []
		if left_center.x == right_center.x:
			# vertical hallway
			for y in range(right_center.y - left_center.y):
				for x in range(left_center.x - 1, left_center.x + 2):
					tiles.append(Vector2i(x, left_center.y + y))
		else:
			# horizontal hallway
			for x in range(right_center.x - left_center.x):
				for y in range(left_center.y - 1, left_center.y + 2):
					tiles.append(Vector2i(left_center.x + x, y))
		place_terrain(tiles)

## --- SPACE PARTITIONING BUTTONS ---

func _on_partition_pressed():
	root.split(splits_selector.value, MIN_PARTITION_SIZE)
	tile_map.clear()
	queue_redraw()


func _on_split_once_pressed():
	pass # Replace with function body.


func _on_reset_splits_pressed():
	pass # Replace with function body.


## --- TILE PLACING BUTTONS ---


func _on_place_rooms_pressed():
	place_room_tiles()


func _on_place_hallways_pressed():
	place_hallway_tiles()


func _on_reroll_pressed():
	full_generate()

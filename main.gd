extends Node2D

const TILE_SIZE := 16

const STARTING_PARAMS = {
	NUM_SPLITS = 5,
	WIDTH = 60,
	HEIGHT = 40,
	MIN_PARTITION_SIZE = 6, # This translates to a min room size of 2,
								# two tiles of padding, two tiles of walls,
								# then the last two tiles are the room
	ROOM_PADDING = 1,
	HALLWAY_WIDTH = 1,
}

@onready var tile_map = $TileMap
@onready var num_splits = $CanvasLayer/SpacePartitioning/NumSplits
@onready var width = $CanvasLayer/Advanced/Width
@onready var height = $CanvasLayer/Advanced/Height
@onready var min_partition_size = $CanvasLayer/Advanced/MinPartitionSize
@onready var room_padding = $CanvasLayer/Advanced/RoomPadding
@onready var hallway_width = $CanvasLayer/Advanced/HallwayWidth

var root: Branch

func _ready():
	num_splits.value = STARTING_PARAMS.NUM_SPLITS
	width.value = STARTING_PARAMS.WIDTH
	height.value = STARTING_PARAMS.HEIGHT
	min_partition_size.value = STARTING_PARAMS.MIN_PARTITION_SIZE
	room_padding.value = STARTING_PARAMS.ROOM_PADDING
	hallway_width.value = STARTING_PARAMS.HALLWAY_WIDTH
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

func reset_root():
	root = Branch.new(
		Vector2i(0, 0),
		Vector2i(width.value, height.value)
	)

func full_generate():
	reset_root()
	root.split(num_splits.value, min_partition_size.value)
	tile_map.clear()
	place_room_tiles()
	place_hallway_tiles()
	queue_redraw()

## --- TILE PLACING ---

func place_terrain(tiles: Array[Vector2i]):
	tile_map.set_cells_terrain_connect(
		0, tiles, 0, 0
	)

func place_room_tiles():
	var padding = room_padding.value
	for leaf in root.get_leaves():
		var tiles: Array[Vector2i] = []
		for x in range(padding, leaf.size.x - padding):
			for y in range(padding, leaf.size.y - padding):
				tiles.append(Vector2i(x + leaf.position.x, y + leaf.position.y))
		place_terrain(tiles)

func place_hallway_tiles():
	# +1 is to make space for walls
	var lower_padding = floor(float(hallway_width.value)/2) + 1
	var upper_padding = ceil(float(hallway_width.value)/2) + 1
	
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
				for x in range(left_center.x - lower_padding, left_center.x + upper_padding):
					tiles.append(Vector2i(x, left_center.y + y))
		else:
			# horizontal hallway
			for x in range(right_center.x - left_center.x):
				for y in range(left_center.y - lower_padding, left_center.y + upper_padding):
					tiles.append(Vector2i(left_center.x + x, y))
		place_terrain(tiles)

## --- SPACE PARTITIONING BUTTONS ---

func _on_partition_pressed():
	reset_root()
	root.split(num_splits.value, min_partition_size.value)
	tile_map.clear()
	queue_redraw()

func _on_split_once_pressed():
	for leaf in root.get_leaves():
		leaf.split(1, min_partition_size.value)
	tile_map.clear()
	queue_redraw()

func _on_reset_splits_pressed():
	reset_root()
	tile_map.clear()
	queue_redraw()

## --- TILE PLACING BUTTONS ---

func _on_place_rooms_pressed():
	place_room_tiles()

func _on_place_hallways_pressed():
	place_hallway_tiles()

func _on_clear_tiles_pressed():
	tile_map.clear()

func _on_reroll_pressed():
	full_generate()

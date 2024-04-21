extends Node2D

const TILE_SIZE := 16
const CSBranch: CSharpScript = preload("res://CSBranch.cs")

@onready var tile_map = $TileMap
@onready var splits_selector = $CanvasLayer/NumSplits

var root: Branch

func _ready():
	var node = CSBranch.new(Vector2i(0,0), Vector2i(2,2))
	print(node)
	root = Branch.new(
		Vector2i(0, 0),
		Vector2i(60, 30)
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
	root.split(splits_selector.value)
	tile_map.clear()
	place_room_tiles()
	place_hallway_tiles()
	queue_redraw()

func place_room_tiles():
	for leaf in root.get_leaves():
		for x in range(1, leaf.size.x - 1):
			for y in range(1, leaf.size.y - 1):
				place_tile(x + leaf.position.x, y + leaf.position.y)

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
		if left_center.x == right_center.x:
			# vertical hallway
			for y in range(right_center.y - left_center.y):
				place_tile(left_center.x, left_center.y + y)
		else:
			# horizontal hallway
			for x in range(right_center.x - left_center.x):
				place_tile(left_center.x + x, left_center.y)

func place_tile(x, y):
	tile_map.set_cell(0, Vector2i(x, y), 1, Vector2i(0, 0))

func _on_reroll_pressed():
	full_generate()


func _on_partition_pressed():
	root.split(splits_selector.value)
	tile_map.clear()
	queue_redraw()


func _on_place_rooms_pressed():
	place_room_tiles()


func _on_place_hallways_pressed():
	place_hallway_tiles()

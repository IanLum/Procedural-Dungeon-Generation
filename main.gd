extends Node2D

const TILE_SIZE := 16
const CSBranch: CSharpScript = preload ("res://CSBranch.cs")

@onready var tile_map = $TileMap
@onready var splits_selector = $CanvasLayer/NumSplits

var use_csharp = true
var root: Branch
var cs_root

func _ready():
	root = Branch.new(Vector2i(0, 0), Vector2i(60, 30))
	cs_root = CSBranch.new(Vector2i(0, 0), Vector2i(60, 30))
	full_generate()

func _draw():
	draw_regions()

func draw_regions():
	var leaves = cs_root.GetLeaves() if use_csharp else root.get_leaves()
	for leaf in leaves:
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
	partition()
	tile_map.clear()
	place_room_tiles()
	place_hallway_tiles()
	queue_redraw()

func partition():
	if use_csharp:
		cs_root.Split(splits_selector.value)
	else:
		root.split(splits_selector.value)

func place_room_tiles():
	var leaves = cs_root.GetLeaves() if use_csharp else root.get_leaves()
	for leaf in leaves:
		for x in range(1, leaf.size.x - 1):
			for y in range(1, leaf.size.y - 1):
				place_tile(x + leaf.position.x, y + leaf.position.y)

func place_hallway_tiles():
	var queue = [cs_root] if use_csharp else [root]
	while not queue.is_empty():
		var curr = queue.pop_front()
		var left = curr.left
		var right = curr.right
		if not (left and right):
			continue
		
		queue.append_array([left, right])
		var left_center: Vector2i = left.Center() if use_csharp else left.center()
		var right_center: Vector2i = right.Center() if use_csharp else right.center()
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
	partition()
	tile_map.clear()
	queue_redraw()

func _on_place_rooms_pressed():
	place_room_tiles()

func _on_place_hallways_pressed():
	place_hallway_tiles()


func _on_use_c_sharp_toggled(toggled_on):
	use_csharp = toggled_on

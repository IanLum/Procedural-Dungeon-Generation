extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _draw():
	draw_line(Vector2(-1000, 0), Vector2(1000, 0), Color.AQUA, 2)
	draw_line(Vector2(0, -1000), Vector2(0, 1000), Color.AQUA, 2)

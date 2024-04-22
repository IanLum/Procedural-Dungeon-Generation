extends Node

const CSBranch: CSharpScript = preload ("res://CSBranch.cs")
const loops = 5

func _ready():
	var gd_root = Branch.new(Vector2i(0, 0), Vector2i(100, 100))
	var cs_root = CSBranch.new(Vector2i(0, 0), Vector2i(100, 100))
	print("Splits \t GD (ms) \t C# (ms)")
	for splits in range(12, 18):
		var gd_time = 0
		var cs_time = 0
		for i in range(loops):
			var gd_start = Time.get_ticks_msec()
			gd_root.split(splits)
			gd_time += Time.get_ticks_msec() - gd_start
			var cs_start = Time.get_ticks_msec()
			cs_root.Split(splits)
			cs_time += Time.get_ticks_msec() - cs_start
		print("%d \t %d \t %d" % [splits, gd_time / loops, cs_time / loops])

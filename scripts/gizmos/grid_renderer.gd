extends Node

class_name GridRenderer

# customization
var size: int = 100
var spacing: float = 1.0
var showAxes: bool = true

func _init():
	name = 'grid'

func _process(delta):
	# draw grid
	Dbg3.draw_grid(Vector3.ZERO, 
		Vector3.RIGHT * size,
		Vector3.BACK * size,
		Vector2i(int(size / spacing), int(size / spacing)),
		Color.DIM_GRAY)
		
	# draw axes
	Dbg3.draw_line(Vector3.LEFT * (size / 2), Vector3.RIGHT * (size / 2), Color.RED) # X
	Dbg3.draw_line(Vector3.DOWN * (size / 2), Vector3.UP * (size / 2), Color.GREEN) # Y
	Dbg3.draw_line(Vector3.FORWARD * (size / 2), Vector3.BACK * (size / 2), Color.BLUE) # Z

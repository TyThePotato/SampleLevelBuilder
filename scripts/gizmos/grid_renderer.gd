class_name GridRenderer
extends MeshInstance3D

# customization
var size: int = 100
var spacing: float = 1.0
var showAxes: bool = true

var _surface_tool := SurfaceTool.new()

func _init():
	name = 'grid'
	
	_regenerate_mesh()

func _regenerate_mesh() -> void:
	_surface_tool.begin(Mesh.PRIMITIVE_LINES)

	_surface_tool.set_color(Color(0.75, 0.75, 0.75, 0.5))

	# Spacing Lines #
	for i in range(-size, size):
		# skip middle lines
		if i == 0: continue
		
		# Z
		_surface_tool.add_vertex(Vector3(i, 0, -size))
		_surface_tool.add_vertex(Vector3(i, 0, size))
		
		# X
		_surface_tool.add_vertex(Vector3(-size, 0, i))
		_surface_tool.add_vertex(Vector3(size, 0, i))
		
	# Axis Lines #
	
	# X
	_surface_tool.set_color(Color.RED)
	_surface_tool.add_vertex(Vector3(-size * 2, 0, 0))
	_surface_tool.add_vertex(Vector3(size * 2, 0, 0))

	# Y
	_surface_tool.set_color(Color.GREEN)
	_surface_tool.add_vertex(Vector3(0, -size * 2, 0))
	_surface_tool.add_vertex(Vector3(0, size * 2, 0))

	# Z
	_surface_tool.set_color(Color.BLUE)
	_surface_tool.add_vertex(Vector3(0, 0, -size * 2))
	_surface_tool.add_vertex(Vector3(0, 0, size * 2))
	
	# TODO: verify that this works multiple times
	#_surface_tool.commit(mesh)
	mesh = _surface_tool.commit()
	
	print('grid regenerated')
	
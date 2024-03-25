class_name LevelObject
extends MeshInstance3D

var id: int

var color: Color

func _init(properties: LevelObjectProperties):
	name = properties.name
	position = properties.position
	rotation_degrees = properties.rotation
	scale = properties.scale # global?
	color = properties.color
	
	mesh = BoxMesh.new()
	refresh_mesh()
	
func refresh_mesh(): # probably super unperformant...
	
	# convert mesh to arraymesh
	var arr_mesh := ArrayMesh.new()
	var st := SurfaceTool.new()
	st.create_from(mesh, 0)
	st.commit(arr_mesh)

	# change vtx colors
	var mdt := MeshDataTool.new()
	mdt.create_from_surface(arr_mesh, 0)
	for v in range(mdt.get_vertex_count()):
		mdt.set_vertex_color(v, color)
	
	arr_mesh.clear_surfaces()
	mdt.commit_to_surface(arr_mesh, 0)
	mesh = arr_mesh
	

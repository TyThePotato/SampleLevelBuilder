extends MeshInstance3D

class_name Terrain

# customiztion
var resolution: int = 32

func build():
    mesh = PlaneMesh.new()
    mesh.size = Vector2(resolution, resolution)
    mesh.subdivide_width = resolution - 1
    mesh.subdivide_depth = resolution - 1
    
    print('Terrain Built')

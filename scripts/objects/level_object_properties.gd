class_name LevelObjectProperties

var name := 'New Object'
var position := Vector3.ZERO
var rotation := Vector3.ZERO
var scale := Vector3.ONE

var id := -1 # -1 = unassigned/no preference

func from_level_object(object: LevelObject):
	name = object.name
	position = object.position
	rotation = object.rotation
	scale = object.scale
	id = object.id
	

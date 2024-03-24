class_name SelectionPropertiesUI
extends Control

# node refs
@export var _elements_root: Control

# prefabs
@export var _element_text_prefab: PackedScene

# script vars
var _current_view_mode: String = ''
var _elements: Array[BasePropertyElement]

func show_object_properties(objects: Array):
	if _current_view_mode != 'object':
		_current_view_mode = 'object'
		_remove_elements()

		# create elements
		_create_element('Name', _element_text_prefab, 'name')

	# set element values
	_elements[0].set_value(objects[-1].name) # Name

func show_terrains_properties(terrains: Array):
	if _current_view_mode != 'terrain':
		_current_view_mode = 'terrain'
		_remove_elements()

func show_level_properties():
	if _current_view_mode != 'level':
		_current_view_mode = 'level'
		_remove_elements()

func show_mixed():
	if _current_view_mode != 'mixed':
		_current_view_mode = 'mixed'
		_remove_elements()

func clear():
	_remove_elements()
	_current_view_mode = ''

func _create_element(name: String, type: PackedScene, tag: String):
	var elem := type.instantiate() as BasePropertyElement
	elem.set_label(name)
	elem.set_tag(tag)
	elem.value_updated.connect(_element_value_changed)
	
	_elements_root.add_child(elem)
	_elements.append(elem)

func _remove_elements():
	var children := _elements_root.get_children()

	for child in children:
		child.queue_free()
		
	_elements.clear()
	
func _element_value_changed(tag: String, value):
	property_element_value_changed.emit(tag, value)
	print(tag + ' - ' + str(value))
	
signal property_element_value_changed(tag: String, value)

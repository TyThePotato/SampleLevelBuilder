class_name SelectionPropertiesUI
extends Control

# node refs
@export var _elements_root: Control

# prefabs
@export var _element_text_prefab: PackedScene
@export var _element_int_prefab: PackedScene
@export var _element_float_prefab: PackedScene
@export var _element_vector_prefab: PackedScene
@export var _element_color_prefab: PackedScene
@export var _element_bool_prefab: PackedScene

# available properties
var _levelObjectProperties := {
								  'name': PROPERTY_TYPE.TEXT,
								  'position': PROPERTY_TYPE.VECTOR,
								  'rotation': PROPERTY_TYPE.VECTOR,
								  'scale': PROPERTY_TYPE.VECTOR,
								  'color': PROPERTY_TYPE.COLOR
							  }

var _levelRootProperties := {}

var _terrainProperties := {}

# script vars
var _current_view_mode: String = ''
var _elements: Array[BasePropertyElement]
var _targets: Array

func show_properties(nodes: Array):
	# determine properties type
	var view_mode := ''
	for node in nodes:
		if node is LevelObject:
			if view_mode == '' or view_mode == 'object':
				view_mode = 'object'
			else:
				view_mode = 'mixed'
				break
		elif node is Terrain:
			if view_mode == '' or view_mode == 'terrain':
				view_mode = 'terrain'
			else:
				view_mode = 'mixed'
				break
		elif node is LevelRoot:
			if view_mode == '' or view_mode == 'level':
				view_mode = 'level'
			else:
				view_mode = 'mixed'
				break
		else:
			view_mode = 'mixed'
			break
			
	var properties_table = _get_property_table(view_mode)		

	if view_mode != _current_view_mode:
		_remove_elements()
		
		# create property elements
		if properties_table != null:
			for property in properties_table:
				_create_element(property, properties_table[property])
		
	# modify property elements
	if properties_table != null:
		for property in properties_table:
			for element in _elements:
				if element.tag == property:
					element.set_value(nodes[-1].get(property))
		
	
func clear():
	_remove_elements()
	_current_view_mode = ''

func _create_all_elements(type: String) -> void:
	var table = _get_property_table(type)
		
	if table != null:
		for key in table:
			_create_element(key, table[key])

func _create_element(tag: String, type: PROPERTY_TYPE):
	var pfb: PackedScene
	match type:
		PROPERTY_TYPE.TEXT: pfb = _element_text_prefab
		PROPERTY_TYPE.INT: pfb = null
		PROPERTY_TYPE.FLOAT: pfb = null
		PROPERTY_TYPE.VECTOR: pfb = _element_vector_prefab
		PROPERTY_TYPE.COLOR: pfb = _element_color_prefab
		PROPERTY_TYPE.BOOL: pfb = null
	
	var elem := pfb.instantiate() as BasePropertyElement
	elem.set_label(tr(tag))
	elem.tag = tag
	elem.value_updated.connect(_element_value_changed)
	
	_elements_root.add_child(elem)
	_elements.append(elem)

func _remove_elements():
	var children := _elements_root.get_children()

	for child in children:
		child.queue_free()
		
	_elements.clear()
	
func _modify_element(tag: String, value) -> void:
	for element in _elements:
		if element.tag == tag:
			element.set_value(value)
			return

func _get_property_table(type: String):
	match type:
		'object': return _levelObjectProperties
		'terrain': return _terrainProperties
		'level': return _levelRootProperties
		_: return null
		
func _element_value_changed(tag: String, value):
	property_element_value_changed.emit(tag, value)
	
	# unfocus
	grab_focus()
	
enum PROPERTY_TYPE {TEXT, INT, FLOAT, VECTOR, COLOR, BOOL}

signal property_element_value_changed(property_tag: String, value)

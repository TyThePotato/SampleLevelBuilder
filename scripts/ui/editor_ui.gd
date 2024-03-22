class_name EditorUI
extends Node

# node references
@export var _sub_viewport: SubViewport
@export var _outliner_tree: Tree
@export var _properties: SelectionPropertiesUI

# texture assets
# TODO: dynamic type checking + icon dictionary?
@export var _outliner_icon_generic: Texture2D
@export var _outliner_icon_object: Texture2D
@export var _outliner_icon_terrain: Texture2D

# ui variables

# makeshift 2-way dictionary - access value using key and key using value
var _outliner_items := {} # Node3D | TreeItem
var _outliner_nodes := {} # TreeItem | Node3D

func _ready():
	# bind camera to subviewport
	request_camera_bind.emit(_sub_viewport)
	
	# set up outliner tree alignment (grr non-exported properties)
	#_outliner_tree.set_column_expand(0, false)

# MENU BUTTONS #
# TODO: better system...?

var _menu_btn_level_table: Array[Signal] = [
   Signal(),
   Signal(),
   Signal(),
   Signal(),
   btn_editor_exit,
   ]

var _menu_btn_edit_table: Array[Signal] = [
	btn_edit_new,
	btn_edit_delete,
	btn_edit_undo,
	btn_edit_redo,
	btn_ping
	]

var _menu_btn_view_table: Array[Signal] = [
	Signal()
	]

func _menu_btn_generic(signal_table: Array[Signal], id: int) -> void:
	if id > signal_table.size() - 1:
		print('UNIMPLEMENTED MENU BUTTON ' + str(id))
		return

	var sig := signal_table[id]
	
	if sig == null:
		print('UNIMPLEMENTED MENU BUTTON ' + str(id))
		return
		
	sig.emit()

func _menu_btn_level(id: int) -> void:
	_menu_btn_generic(_menu_btn_level_table, id)

func _menu_btn_edit(id: int) -> void:
	_menu_btn_generic(_menu_btn_edit_table, id)
 
func _menu_btn_view(id: int) -> void:
	_menu_btn_generic(_menu_btn_view_table, id)
	
# OUTLINER #

func add_nodes_to_outliner(nodes: Array) -> void:
	for node in nodes:
		if not node is Node3D: continue # ignore nodes that dont derive from node3d
		
		var tree_item := _outliner_tree.create_item()
		_outliner_items[node] = tree_item
		_outliner_nodes[tree_item] = node
		
		style_outliner_tree_node(node)
	
		print('added item')
	
func remove_nodes_from_outliner(nodes: Array) -> void:
	for node in nodes:
		if not node is Node3D: continue # ignore nodes that dont derive from node3d
		
		if _outliner_items.has(node):
			var tree_item = _outliner_items[node]
			_outliner_nodes.erase(tree_item) # remove from dict #2
			_outliner_items.erase(node) # remove from dict #1
			
			tree_item.free() # delete tree item

func style_outliner_tree_node(node: Node3D) -> void:
	if not _outliner_items.has(node): return
	var tree_item := _outliner_items[node] as TreeItem
	
	tree_item.set_icon_max_width(0, 16)
	tree_item.set_icon(0, get_node_icon(node))
	#tree_item.set_icon_modulate(0, Color(0, 0, 1))
	
	tree_item.set_text(0, node.name)

func _set_outliner_item_selected(item: TreeItem, column: int, selected: bool):
	var node := _outliner_nodes[item] as Node3D
	
	if selected:
		node_selected.emit(node)
	else:
		node_deselected.emit(node)

# PROPERTIES #

func set_properties_objects(objects: Array):
	_properties.show_object_properties(objects)
	
func set_properties_terrains(terrains: Array):
	_properties.show_terrains_properties(terrains)
	
func set_properties_level():
	_properties.show_level_properties()
	
func set_properties_mixed():
	_properties.show_mixed()

func set_properties_clear():
	_properties.clear()
	
# GENERAL #

func selection_updated(nodes: Array):
	# TODO: make sure outliner nodes are selected (and avoid recursion)
	
	var selection_type := ''
	
	for node: Node in nodes:
		if node is LevelObject:
			if selection_type == '':
				selection_type = 'object'
			elif selection_type != 'object':
				selection_type = 'mixed'
				break
			
		elif node is Terrain:
			if selection_type == '':
				selection_type = 'terrain'
			elif selection_type != 'terrain':
				selection_type = 'mixed'
				break
				
		elif node.name == 'Level':
			if selection_type == '':
				selection_type = 'level'
			elif selection_type != 'level':
				selection_type = 'mixed'
				break
		
	match selection_type:
		'object': set_properties_objects(nodes)
		'terrain': set_properties_terrains(nodes)
		'level': set_properties_level()
		'mixed': set_properties_mixed()
		'': set_properties_clear()

func get_node_icon(node: Node) -> Texture2D:
	if node is LevelObject:
		return _outliner_icon_object
	elif node is Terrain:
		return _outliner_icon_terrain
	
	
	return _outliner_icon_generic

# SIGNALS #

signal request_camera_bind(sub_viewport: SubViewport)

signal node_selected(node: Node3D)
signal node_deselected(node: Node3D)

# buttons
signal btn_editor_exit

signal btn_edit_new
signal btn_edit_delete

signal btn_edit_undo
signal btn_edit_redo

signal btn_ping

class_name EditorUI
extends Node

# node references
@export var _sub_viewport: SubViewport
@export var _outliner_tree: Tree

# texture assets
# TODO: dynamic type checking + icon dictionary?
@export var _outliner_icon_generic: Texture2D
@export var _outliner_icon_object: Texture2D
@export var _outliner_icon_terrain: Texture2D

# ui variables
var _outliner_items := {} # Node3D | TreeItem

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
		style_outliner_tree_node(node)
	
		print('added item')
	
func remove_nodes_from_outliner(nodes: Array) -> void:
	for node in nodes:
		if not node is Node3D: continue # ignore nodes that dont derive from node3d
		
		if _outliner_items.has(node):
			_outliner_items[node].free() # delete tree item
			_outliner_items.erase(node) # remove from dict

func style_outliner_tree_node(node: Node3D) -> void:
	if not _outliner_items.has(node): return
	var tree_item := _outliner_items[node] as TreeItem
	
	tree_item.set_icon_max_width(0, 16)
	tree_item.set_icon(0, get_node_icon(node))
	#tree_item.set_icon_modulate(0, Color(0, 0, 1))
	
	tree_item.set_text(0, node.name)

# GENERAL #

func get_node_icon(node: Node) -> Texture2D:
	if node is LevelObject:
		return _outliner_icon_object
	elif node is Terrain:
		return _outliner_icon_terrain
	
	
	return _outliner_icon_generic

# SIGNALS #

signal request_camera_bind(sub_viewport: SubViewport)

signal btn_editor_exit

signal btn_edit_new
signal btn_edit_delete

signal btn_edit_undo
signal btn_edit_redo

signal btn_ping

class_name OutlinerUI
extends Node

# node references
@export var _tree: Tree

# icon refs
@export var _icon_default: Texture2D
@export var _icon_object: Texture2D
@export var _icon_terrain: Texture2D

# 2-way dict - access value using key and key using value
var _items := {} # Node3D | TreeItem
var _nodes := {} # TreeItem | Node3D

func add_nodes(nodes: Array) -> void:
    for node in nodes:
        if not node is Node3D: continue
        
        var item := _tree.create_item()
        _items[node] = item
        _nodes[item] = node
        
        restyle_node(node)
    
func remove_nodes(nodes: Array) -> void:
    for node in nodes:
        if not node is Node3D: continue

        if _items.has(node):
            var item = _items[node]
            _nodes.erase(item)
            _items.erase(node)
    
            item.free() # delete tree item
    
func restyle_node(node: Node3D) -> void:
    if not _items.has(node): return
    
    var item := _items[node] as TreeItem

    item.set_icon_max_width(0, 16)
    item.set_icon(0, _get_icon(node))
    #item.set_icon_modulate(0, Color(0,0,1))

    item.set_text(0, node.name)
    
func _set_item_selected(item: TreeItem, column: int, selected: bool):
    var node := _nodes[item] as Node3D
    
    if selected:
        node_selected.emit(node)
    else:
        node_deselected.emit(node)
        
func _get_icon(node):
    if node is LevelObject:
        return _icon_object
    elif node is Terrain:
        return _icon_terrain
        
    return _icon_default
    
# Signals #
        
signal node_selected(node: Node3D)
signal node_deselected(node: Node3D)
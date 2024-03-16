extends Node

# node references
@export var _sub_viewport: SubViewport

func _ready():
    # bind camera to subviewport
    request_camera_bind.emit(_sub_viewport)

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

func add_objects_to_outliner(objects: Array[LevelObject]):
    return
    
func remove_objects_from_outliner(objects: Array[LevelObject]):
    return


# SIGNALS #

signal request_camera_bind(sub_viewport: SubViewport)

signal btn_editor_exit

signal btn_edit_new
signal btn_edit_delete

signal btn_edit_undo
signal btn_edit_redo

signal btn_ping
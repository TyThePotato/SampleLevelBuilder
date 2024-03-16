extends Node

# node references
@export var _menu_button_level: MenuButton
@export var _menu_button_edit: MenuButton
@export var _menu_button_view: MenuButton

func _ready():
    # bind signals
    _menu_button_level.get_popup().connect('id_pressed', _menu_btn_level)
    _menu_button_edit.get_popup().connect('id_pressed', _menu_btn_edit)
    _menu_button_view.get_popup().connect('id_pressed', _menu_btn_view)

# MENU BUTTONS #
# TODO: better system...?

var _menu_btn_level_table: PackedStringArray = PackedStringArray([
   'btn_level_new',
   'btn_level_open',
   'btn_level_save',
   'btn_level_save_as',
   '',
   'btn_editor_exit',
   ])

var _menu_btn_edit_table: PackedStringArray = PackedStringArray([
    'btn_edit_new',
    'btn_edit_delete',
    '',
    'btn_edit_undo',
    'btn_edit_redo',
    '',
    'btn_ping',
    ])

var _menu_btn_view_table: PackedStringArray = PackedStringArray([
    'btn_editor_about'
    ])

func _menu_btn_generic(table: PackedStringArray, id: int) -> void:
    if id > table.size() - 1:
        print('UNIMPLEMENTED MENU BUTTON ' + str(id))
        return

    var sig: String = table[id]
    
    if sig == '':
        print('UNIMPLEMENTED MENU BUTTON ' + str(id))
        return
        
    emit_signal(sig)

func _menu_btn_level(id: int) -> void:
    _menu_btn_generic(_menu_btn_level_table, id)

func _menu_btn_edit(id: int) -> void:
    _menu_btn_generic(_menu_btn_edit_table, id)
 
func _menu_btn_view(id: int) -> void:
    _menu_btn_generic(_menu_btn_view_table, id)
    

# SIGNALS #

signal btn_editor_exit

signal btn_edit_new
signal btn_edit_delete

signal btn_edit_undo
signal btn_edit_redo

signal btn_ping
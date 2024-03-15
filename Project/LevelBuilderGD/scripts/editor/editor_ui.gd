extends Node

# node references
@export var _menu_button_level: MenuButton
@export var _menu_button_edit: MenuButton
@export var _menu_button_view: MenuButton

func _ready():
    # bind signals
    _menu_button_level.get_popup().connect('id_pressed', menu_btn_level)
    _menu_button_edit.get_popup().connect('id_pressed', menu_btn_edit)
    _menu_button_view.get_popup().connect('id_pressed', menu_btn_view)

# MENU BUTTONS #

func menu_btn_level(id: int):
    return

func menu_btn_edit(id: int):
    match id:
        3: # Ping (DEBUG)
            emit_signal('btn_ping')
 
func menu_btn_view(id: int):
    return
    

# SIGNALS #
    
signal btn_ping
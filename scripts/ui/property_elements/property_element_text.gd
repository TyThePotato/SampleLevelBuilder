extends BasePropertyElement

# node refs #
@export var _line_edit: LineEdit

# internal #
var _value: String

# property data #

func get_value() -> String:
    return _value
    
func set_value(value):
    _value = value
    
    _line_edit.set_text(value)
    
# field functions #
func _line_edit_submitted(new_value: String):
    _value = new_value
    
    value_updated.emit(_tag, _value)
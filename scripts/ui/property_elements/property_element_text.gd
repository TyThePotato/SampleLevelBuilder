extends BasePropertyElement

# node refs #
@export var _line_edit: LineEdit

# config #
var content_filter_regex := '[A-Za-z0-9_\\s]' # TODO: Investigate Accented Characters?

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
    if new_value == '':
        _value = 'String'
    else:
        _value = new_value
    
    value_updated.emit(tag, _value)
    
func _line_edit_changed(new_value: String):
    # data validation
    var old_caret_position := _line_edit.get_caret_column()
    var new_contents := ''
    
    # TODO: precompile regex
    var regex := RegEx.new()
    regex.compile(content_filter_regex)
    for valid_char in regex.search_all(new_value):
        new_contents += valid_char.get_string()

    _line_edit.set_text(new_contents)
    _line_edit.set_caret_column(old_caret_position)

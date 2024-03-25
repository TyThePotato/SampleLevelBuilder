extends BasePropertyElement

# node refs #
@export var _spin_box_r: SpinBox
@export var _spin_box_g: SpinBox
@export var _spin_box_b: SpinBox

# internal #
var _value: Color

# property data #

func get_value() -> Color:
    return _value

func set_value(value):
    _value = value

    _spin_box_r.set_value_no_signal(round(_value.r * 255))
    _spin_box_g.set_value_no_signal(round(_value.g * 255))
    _spin_box_b.set_value_no_signal(round(_value.b * 255))

# field functions #
func _spin_box_r_changed(new_value: float):
    _value.r = new_value / 255
    value_updated.emit(tag, _value)

func _spin_box_g_changed(new_value: float):
    _value.g = new_value / 255
    value_updated.emit(tag, _value)

func _spin_box_b_changed(new_value: float):
    _value.b = new_value / 255
    value_updated.emit(tag, _value)
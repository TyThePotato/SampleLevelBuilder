extends BasePropertyElement

# node refs #
@export var _spin_box_x: SpinBox
@export var _spin_box_y: SpinBox
@export var _spin_box_z: SpinBox

# internal #
var _value: Vector3

# property data #

func get_value() -> Vector3:
    return _value

func set_value(value):
    _value = value
    
    _spin_box_x.set_value_no_signal(_value.x)
    _spin_box_y.set_value_no_signal(_value.y)
    _spin_box_z.set_value_no_signal(_value.z)

# field functions #
func _spin_box_x_changed(new_value: float):
    _value.x = new_value
    value_updated.emit(tag, _value)

func _spin_box_y_changed(new_value: float):
    _value.y = new_value
    value_updated.emit(tag, _value)

func _spin_box_z_changed(new_value: float):
    _value.z = new_value
    value_updated.emit(tag, _value)
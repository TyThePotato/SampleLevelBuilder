class_name BasePropertyElement
extends Control

# node refs #
@export var _label: Label

var tag: String

# element #

func set_label(text: String):
	_label.set_text(text)

# property data #

func get_value():
	return
	
func set_value(value):
	return

# signals #

signal value_updated(property_tag: String, value)

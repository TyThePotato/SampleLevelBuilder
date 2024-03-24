class_name BasePropertyElement
extends Control

# node refs #
@export var _label: Label
@export var _tag: String

# element #

func set_label(text: String):
	_label.set_text(text)
	
func set_tag(text: String):
	_tag = text

# property data #

func get_value():
	return
	
func set_value(value):
	return

# signals #

signal value_updated(tag: String, value)

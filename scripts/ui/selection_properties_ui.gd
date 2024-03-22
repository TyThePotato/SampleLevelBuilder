class_name SelectionPropertiesUI
extends Control

@export var properties_label: Label

func show_object_properties(objects: Array):
    properties_label.text = 'Objects (' + str(objects.size()) + ')'

func show_terrains_properties(terrains: Array):
    properties_label.text = 'Terrains (' + str(terrains.size()) + ')'

func show_level_properties():
    properties_label.text = 'Level'
    
func show_mixed():
    properties_label.text = 'Mixed Selection'
    
func clear():
    properties_label.text = ''
class_name BaseOption
extends Control

signal setting_changed(value)

@export var option_name : String :
	set(value):
		option_name = value
		%OptionLabel.text = option_name
		_config_key = option_name.to_pascal_case()
@export var editable : bool = true : set = set_editable
@export var type : Variant.Type = TYPE_BOOL

# Options always fall under a "Section"
# Sections have a "Root -> Container -> Option" structure, with the Root containing the label
#@onready var option_section : String = get_parent().get_parent().label

var default_value
var _config_key : String
var _connected_nodes : Array

func _on_setting_changed(value):
	#Config.set_config(section, key, value)
	setting_changed.emit(value)

func _get_setting(default : Variant = null) -> Variant:
	return
	#return Config.get_config(section, key, default)

func _connect_option_inputs(node):
	if node in _connected_nodes: return
	if node is Button:
		if node is OptionButton:
			node.item_selected.connect(_on_setting_changed)
		else:
			node.toggled.connect(_on_setting_changed)
		_connected_nodes.append(node)
	if node is Range:
		node.value_changed.connect(_on_setting_changed)
		_connected_nodes.append(node)

func set_value(value : Variant):
	if value == null:
		return
	for node in get_children():
		if node is Button:
			if node is OptionButton:
				node.select(value as int)
			else:
				node.button_pressed = value as bool
		if node is Range:
			node.value = value as float

func set_editable(value : bool = true):
	editable = value
	for node in get_children():
		if node is Button:
			node.disabled = !editable
		if node is Slider or node is SpinBox:
			node.editable = editable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_value(_get_setting(default_value))
	for child in get_children():
		_connect_option_inputs(child)
	child_entered_tree.connect(_connect_option_inputs)

func _set(property : StringName, value : Variant) -> bool:
	if property == "value":
		set_value(value)
		return true
	return false

func _get_property_list():
	return [
		{ "name": "value", "type": type, "usage": PROPERTY_USAGE_NONE},
		{ "name": "default_value", "type": type}
	]

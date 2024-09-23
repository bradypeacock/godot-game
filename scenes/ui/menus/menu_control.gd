# Handles Menu list items
# FIXME: Should this handle options in the options menu as well?
# It probably could be made more dynamic in order to do so.
class_name MenuControl
extends VBoxContainer

signal selected(item: Control)

@export var pointer : Node

func get_items() -> Array[Control]:
	var items : Array[Control] = []
	for child in get_children():
		if not child is MenuButtonControl:
			continue
		items.append(child)

	return items

func configure_focus() -> void:
	var items = get_items()
	for i in items.size():
		var item : Control = items[i]

		item.focus_mode = Control.FOCUS_ALL

		item.focus_neighbor_left = item.get_path()
		item.focus_neighbor_right = item.get_path()

		# First item in list. Give default focus.
		if i == 0:
			item.focus_neighbor_top = item.get_path()
			item.focus_previous = item.get_path()
			item.grab_focus()
		else:
			item.focus_neighbor_top = items[i - 1].get_path()
			item.focus_previous = items[i - 1].get_path()

		# Last item in list.
		if i == items.size() - 1:
			item.focus_neighbor_bottom = item.get_path()
			item.focus_next = item.get_path()
		else:
			item.focus_neighbor_bottom = items[i + 1].get_path()
			item.focus_next = items[i + 1].get_path()

		item.mouse_entered.connect(on_mouse_entered)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().gui_focus_changed.connect(_on_focus_changed)
	configure_focus()

func get_focused_item() -> Control:
	var item = get_viewport().gui_get_focus_owner()
	return item if item in get_children() else null

func update_selection() -> void:
	var item = get_focused_item()

	if is_instance_valid(item) and is_instance_valid(pointer) and visible:
		pointer.global_position = Vector2(item.global_position.x + item.size.x * 0.5, item.global_position.y + item.size.y * 0.5)

### Signals
# Change focus to the hovered option
func on_mouse_entered() -> void:
	var item = get_viewport().gui_get_hovered_control()
	item.grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if not visible: return

	get_viewport().set_input_as_handled()

	var item = get_focused_item()
	if is_instance_valid(item) and event.is_action_pressed(&"ui_accept"):
		selected.emit(item)

func _input(event: InputEvent) -> void:
	# FIXME: this could be more robust
	if event is InputEventKey:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_focus_changed(item: Control) -> void:
	if not item: return
	if not item in get_children(): return

	call_deferred("update_selection")

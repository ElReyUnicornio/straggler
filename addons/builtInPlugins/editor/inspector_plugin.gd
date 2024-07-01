extends EditorInspectorPlugin


func _can_handle(object: Object) -> bool:
	return object is Mineral


func _parse_begin(object: Object) -> void:
	if object is Mineral:
		var generator_buttons := preload("./editorButtons.gd").new()
		add_custom_control(generator_buttons)

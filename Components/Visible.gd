extends Node3D


# Called when the node enters the scene tree for the first time.
func _show():
	get_parent_node_3d().visible = true
	
func _hide():
	get_parent_node_3d().visible = false


func _on_button_pressed(button):
	_show()

func _on_button_released(button):
	_hide()

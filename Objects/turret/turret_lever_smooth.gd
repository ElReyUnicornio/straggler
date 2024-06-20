extends Node3D

var parent: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interactable_lever_hinge_moved(angle):
	var speed_factor = angle / 45
	var final_angle = parent.movement_speed * speed_factor
	if parent.global_rotation_degrees.z < 45 or angle < 0:
		parent.rotate_z(deg_to_rad(final_angle))
	elif parent.global_rotation_degrees.z > -45 or angle > 0:
		parent.rotate_z(deg_to_rad(final_angle))
		
	if parent.character: 
		parent.character.rotate_y(deg_to_rad(final_angle))
		parent.character.global_rotation = parent.position_marker.global_rotation
		parent.character.global_position = parent.position_marker.global_position

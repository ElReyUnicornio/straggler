extends Node3D

var parent: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interactable_hinge_hinge_moved(angle):
	var fixed_angle = clamp(angle, -180, 180)
	var speed_factor = fixed_angle / 180
	var final_angle = parent.movement_speed * speed_factor
	
	parent.rotate_y(deg_to_rad(final_angle))
	if parent.character: 
		parent.character.rotate_y(deg_to_rad(final_angle))
		parent.character.global_position = parent.position_marker.global_position

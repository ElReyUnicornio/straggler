extends Node3D

@export var movement_speed: float;
var character: Player;
@onready var position_marker := $sitPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if character and global_rotation_degrees != 0:
		character.global_rotation = position_marker.global_rotation
	pass


func _on_area_3d_body_entered(body):
	if body is XRToolsPlayerBody:
		body.axis_lock_angular_x = true
		body.axis_lock_angular_y = true
		body.axis_lock_angular_z = true
		character = body.get_parent()
		character.global_position = position_marker.global_position
		await get_tree().create_timer(0.5)
		body.axis_lock_linear_y = true

func _on_area_3d_body_exited(body):
	if body is XRToolsPlayerBody:
		body.axis_lock_angular_x = false
		body.axis_lock_angular_y = false
		body.axis_lock_angular_z = false
		body.axis_lock_linear_y = false
		character = null

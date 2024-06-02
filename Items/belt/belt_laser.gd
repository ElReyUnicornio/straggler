extends Node3D

var target: Node3D
var laser
var field

# Called when the node enters the scene tree for the first time.
func _ready():
	laser = $laser
	field = $field
	
	laser.mesh = laser.mesh.duplicate()
	field.mesh = field.mesh.duplicate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target and target != null:
		look_at(target.position)
		var distance = global_position.distance_to(target.global_position)
		laser.mesh.height = distance
		laser.position.z = -distance / 2
		field.position.z = -distance
		field.mesh.radius = 0.2
		field.mesh.height = 0.4
	

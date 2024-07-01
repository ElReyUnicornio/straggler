@tool
extends Node3D
class_name Mineral

@export var data: MineralData

var active_faces := {
	'up': null,
	'down': null,
	'left': null,
	'right': null,
	'front': null,
	'back': null
}

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		return
	else:
		update_faces([1,0,1,0,1,0])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		$Hurtbox/Health.max_health = data.health
		return
	else:
		pass

func _on_health_die():
	update_faces([0,0,0,0,0,0])
	$GPUParticles3D.emitting = true
	await get_tree().create_timer(0.8).timeout
	queue_free()

func scan_and_update_faces():
	var arr = [0,0,0,0,0,0]
	if !$RayUp.get_collision_point(): arr[1] = 1
	if !$RayDown.get_collision_point(): arr[1] = 1
	if !$RayLeft.get_collision_point(): arr[2] = 1
	if !$RayRight.get_collision_point(): arr[3] = 1
	if !$RayFront.get_collision_point(): arr[4] = 1
	if !$RayBack.get_collision_point(): arr[5] = 1
	
	update_faces(arr)

func update_faces(visibility_matrix: Array):
	for i in active_faces:
		if active_faces[i]:
			active_faces[i].queue_free()
			active_faces[i] = null
		
	if visibility_matrix[0]:
		var top = data.faces.instantiate()
		add_child(top)
		active_faces['top'] = top
		top.position.y = 0.5
	if visibility_matrix[1]:
		var down = data.faces.instantiate()
		add_child(down)
		active_faces['down'] = down
		down.global_rotation_degrees.z = 180
		down.position.y = -0.5
	
	if visibility_matrix[2]:
		var left = data.faces.instantiate()
		add_child(left)
		active_faces['left'] = left
		left.global_rotation_degrees.z = 90
		left.position.x = -0.5
	if visibility_matrix[3]:
		var right = data.faces.instantiate()
		add_child(right)
		active_faces['right'] = right
		right.global_rotation_degrees.z = -90
		right.position.x = 0.5
	
	if visibility_matrix[4]:
		var front = data.faces.instantiate()
		add_child(front)
		active_faces['front'] = front
		front.global_rotation_degrees.x = 90
		front.position.z = 0.5
	if visibility_matrix[5]:
		var back = data.faces.instantiate()
		add_child(back)
		active_faces['back'] = back
		back.global_rotation_degrees.x = -90
		back.position.z = -0.5

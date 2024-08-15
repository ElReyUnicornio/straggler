extends CharacterBody3D

@export var SPEED = 150.0
const JUMP_VELOCITY = 4.5

@onready var na = $NavigationAgent3D

var attacking = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	na.target_position = GameManager.dome.global_position
	na.target_desired_distance = 17
	$"Root Scene/AnimationPlayer".play("Armature|ArmatureAction")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		move_and_slide()
		return
		
	#checks for dome proximity
	var dome_distance = na.distance_to_target()
	if dome_distance < 18:
		if attacking: return
		attack()
		return
	
	#rotate the object to look at the navigation target
	var destination = na.get_next_path_position()
	look_at(destination)
	rotation_degrees.x = 0
	
	#moves to the next target
	
	var next_target_direction: Vector3 = global_position.direction_to(destination).normalized()
	velocity.x = next_target_direction.x * SPEED * delta
	velocity.z = next_target_direction.z * SPEED * delta
	if next_target_direction.y + 2.5 > 0: velocity.y = next_target_direction.y * SPEED * 2 * delta
	
	#snap the object to the ground
	var floor_angle = get_floor_angle()
	rotation_degrees.x = floor_angle
	
	move_and_slide()
	
func attack():
	attacking = true
	look_at(GameManager.dome.global_position)
	$Hitbox/CollisionShape3D.disabled = false
	await get_tree().create_timer(0.5).timeout
	$Hitbox/CollisionShape3D.disabled = true
	await  get_tree().create_timer(0.4).timeout
	attacking = false

func die():
	GameManager.current_enemies -= 1
	queue_free()

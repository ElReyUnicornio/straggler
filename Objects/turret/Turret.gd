extends Node3D

@export var movement_speed: float
@export var bullets: PackedScene
@export var shoot_delay := 0.2
var character: Player
@onready var position_marker := $sitPosition
@onready var shoot_position := $shootPosition

var btn_shooting: bool = false
var shooting := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	shoot()

func shoot():
	if shooting and bullets and btn_shooting:
		shooting = false
		var instance: Bullet = bullets.instantiate()
		GameManager.world.add_child(instance)
		instance.global_position = shoot_position.global_position
		instance.global_rotation = shoot_position.global_rotation
		await get_tree().create_timer(shoot_delay).timeout
		shooting = true

func _on_area_3d_body_entered(body):
	if body is XRToolsPlayerBody:
		GlobalPlayer.disableDrill()
		character = body.get_parent()
		character.global_position = position_marker.global_position

func _on_area_3d_body_exited(body):
	if body is XRToolsPlayerBody:
		GlobalPlayer.enableDrill()
		character = null
		await get_tree().create_timer(1).timeout
		var tween = get_tree().create_tween()
		tween.tween_property(self, "rotation", Vector3(0,0,0), 1)


func _on_lever_smooth_action_pressed():
	btn_shooting = true
	shooting = true


func _on_lever_smooth_action_released():
	btn_shooting = false
	shooting = false

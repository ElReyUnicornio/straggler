extends Node3D
class_name Bullet

@export var speed := 10.0
@export var lifetime := 3.0
@onready var hitbox: Hitbox = $Hitbox

var timer: SceneTreeTimer

func _ready():
	print("bala")
	timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(_on_impact)
	
	hitbox.impacted.connect(_on_impact)
	
func _process(delta):
	translate_object_local(Vector3(-1,0,0) * speed * delta)

func _on_impact():
	queue_free()


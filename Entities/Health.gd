extends Node3D
class_name Health

@export var max_health := 100
@onready var health := max_health
var died := false

signal health_changed(new_health)
signal die()

func get_damage(damage: int):
	if died: return
	
	health -= damage
	print(health)
	health_changed.emit(health)
	
	if health <= 0:
		died = true
		die.emit()

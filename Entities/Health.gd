extends Node3D
class_name Health

@export var max_health := 100
@onready var health := max_health

signal health_changed(new_health)
signal die()

func get_damage(damage: int):
	health -= damage
	health_changed.emit(health)
	
	if health <= 0:
		die.emit()

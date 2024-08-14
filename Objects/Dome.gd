extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.dome = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_health_die():
	GameManager.end_game()

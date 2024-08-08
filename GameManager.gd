extends Node

var world: Node3D
var dome: Node3D
var paused = false

signal game_start()
signal game_end()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_game():
	game_start.emit()
	
func pause_game():
	paused = !paused
	
func end_game():
	game_end.emit()

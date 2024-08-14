extends Node
class_name Game

#scenes
@export var GameOver: PackedScene = preload("res://Levels/GameOver.tscn")
@export var main: PackedScene = preload("res://Levels/Main.tscn")

#utilities
var rng := RandomNumberGenerator.new()

#gameObjects
var world: Node3D
var dome: Node3D

#wave controllers
var spawners: Array[Spawner]
var wave_level := 1
var current_enemies := 0 :
	set(new_val):
		if new_val <= 0: wave_end.emit()
		current_enemies = new_val

var next_wave_timmer: SceneTreeTimer
signal wave_end()
signal wave_start()

#game_controllers
var paused = false

signal game_start()
signal game_end()

# Called when the node enters the scene tree for the first time.
func _ready():
	wave_end.connect(end_wave)
	start_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_wave():
	wave_start.emit()
	print("wave started")
	var wave_enemies = rng.randi_range(1, 4) + wave_level
	current_enemies = wave_enemies
	for i in range(wave_enemies):
		spawners[rng.randi_range(0, len(spawners) - 1)].spawn()
		await get_tree().create_timer(rng.randf_range(4.0, 6.0))

func end_wave():
	print("wave ended")
	next_wave_timmer = get_tree().create_timer(120)
	next_wave_timmer.timeout.connect(start_wave)
	
func start_game():
	#var parent = world.get_parent()
	#world.queue_free()
	#world = main.instantiate()
	#parent.add_child(world)
	
	next_wave_timmer = get_tree().create_timer(120)
	next_wave_timmer.timeout.connect(start_wave)
	game_start.emit()
	
func pause_game():
	paused = !paused
	
func end_game():
	spawners.clear()
	wave_level = 1
	next_wave_timmer.timeout.disconnect(start_wave)
	var parent = world.get_parent()
	world.queue_free()
	world = GameOver.instantiate()
	parent.add_child(world)
	game_end.emit()

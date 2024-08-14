extends Marker3D
class_name Spawner

@export var scenes: Array[PackedScene]
@export var chances: Array[NumRange]
@export var min_level: Array[int]

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.spawners.append(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn():
	var index = roll_dice()
	print(index)
	if GameManager.wave_level < min_level[index] or index == -1:
		spawn()
		return
	else:
		var instance = scenes[index].instantiate()
		instance.global_position = global_position
		GameManager.world.add_child(instance)

func roll_dice():
	var number = randf_range(0,1000)
	for chance in chances:
		if chance.min <= number and number <= chance.max:
			return chances.find(chance)
	return -1

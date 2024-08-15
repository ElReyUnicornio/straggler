extends Node3D

var inventory := []
var count := 0
@export var characterbody: CharacterBody3D 
@onready var joints := [
	$joint,
	$joint2,
	$joint3,
	$joint4,
	$joint5,
	$joint6
]

@onready var lasers := [
	$BeltLaser1, 
	$BeltLaser2, 
	$BeltLaser3, 
	$BeltLaser4, 
	$BeltLaser5, 
	$BeltLaser
]

# Called when the node enters the scene tree for the first time.
func _ready():
	for joint in joints:
		joint.node_a = characterbody.get_path()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_3d_body_entered(body):
	if body is Anchorable and count < 6:
		if body in inventory: return
		body.die.connect(detach_body)
		joints[count].node_b = body.get_path()
		lasers[count].target = body
		inventory.append(body)
		$AudioStreamPlayer3D.play()
		count += 1

func detach_body(body: Anchorable):
	var index = inventory.find(body)
	if index != -1:
		lasers[index].target = null
		inventory.erase(index)
		count -= 1
		$AudioStreamPlayer3D.play()

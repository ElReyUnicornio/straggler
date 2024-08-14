extends Node3D

var parent: Node3D
var grabbed := false

@export var action_button := "trigger_click"
@export var death_zone := 10.0
@onready var _controller

signal actionPressed()
signal actionReleased()

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	_controller = XRHelpers.get_xr_controller(GlobalPlayer.current.get_node("XRrightHand"))
	_controller.connect("button_pressed", _on_button_pressed)
	_controller.connect("button_released", _on_button_released)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interactable_lever_hinge_moved(angle):
	print(angle)
	if angle > -death_zone and angle < death_zone: return
	var speed_factor = angle / 45
	var final_angle = parent.vertical_speed * -speed_factor
	if parent.rotation_degrees.z < 46 and parent.rotation_degrees.z > -46:
		parent.rotate_object_local(Vector3(0,0,1), deg_to_rad(final_angle))
	if parent.rotation_degrees.z > 46: parent.rotation_degrees.z = 45
	if parent.rotation_degrees.z < -46: parent.rotation_degrees.z = -45


func _on_interactable_lever_grabbed(interactable):
	grabbed = true


func _on_interactable_lever_released(interactable):
	grabbed = false
	actionReleased.emit()

func _on_button_pressed(control: String):
	if control == action_button and grabbed: 
		actionPressed.emit()

func _on_button_released(control: String):
	if control == action_button and grabbed: 
		actionReleased.emit()

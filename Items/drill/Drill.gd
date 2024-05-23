extends Node3D

@export var action_button := "trigger_click"
@onready var _controller := XRHelpers.get_xr_controller(self)

var active_target: Node3D
var enabled := true

func _ready():
	_controller.connect("button_pressed", _on_button_pressed)
	_controller.connect("button_released", _on_button_released)

func _process(delta):
	if !active_target: return
	if get_node_or_null(active_target.get_path()):
		var distance = global_position.distance_to(active_target.global_position)
		if distance > 1:
			enabled = true
			active_target = null
			$collideMonitor/CollisionMonitor.disabled = true

func _on_button_pressed(control: String):
	if control == action_button and enabled: 
		$Hitbox/CollisionShape3D.disabled = false
		$collideMonitor/CollisionMonitor.disabled = false

func _on_button_released(control: String):
	if control == action_button: 
		$Hitbox/CollisionShape3D.disabled = true

func _on_collide_monitor_area_entered(area):
	active_target = area
	enabled = false

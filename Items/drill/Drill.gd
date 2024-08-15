extends Node3D
class_name Drill

@export var action_button := "trigger_click"
@onready var _controller := XRHelpers.get_xr_controller(self)

var active_target: Node3D
var enabled := true

func _ready():
	_controller.connect("button_pressed", _on_button_pressed)
	_controller.connect("button_released", _on_button_released)
	$UI/Visible.hide()
	
	GlobalPlayer.drillEnabledUpdated.connect(_on_state_changed)

func _process(delta):
	if !active_target:
		enabled = true
		active_target = null
		$collideMonitor/CollisionMonitor.disabled = true
		return
	if get_node_or_null(active_target.get_path()):
		if active_target.get_parent() is Drill:
			enabled = true
			active_target = null
			$collideMonitor/CollisionMonitor.disabled = true
			return
		var distance = global_position.distance_to(active_target.global_position)
		if distance > 1:
			enabled = true
			active_target = null
			$collideMonitor/CollisionMonitor.disabled = true

func _on_button_pressed(control: String):
	if control == action_button and enabled and GlobalPlayer.drillEnabled: 
		$AnimationTree["parameters/conditions/drilling"] = true
		$AnimationTree["parameters/conditions/idle"] = false

func _on_button_released(control: String):
	if control == action_button and GlobalPlayer.drillEnabled: 
		$AnimationTree["parameters/conditions/drilling"] = false
		$AnimationTree["parameters/conditions/idle"] = true

func _on_collide_monitor_area_entered(area):
	active_target = area
	enabled = false
	
func _on_state_changed(value: bool):
	visible = value

func enable_laser(any):
	GlobalPlayer.current.change_laser_state(false)
	
func disable_laser(any):
	GlobalPlayer.current.change_laser_state(true)

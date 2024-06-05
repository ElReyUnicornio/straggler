@tool
extends Area3D
class_name Hurtbox

var health_component: Health

func _ready():
	health_component = get_node("Health")
	
func _process(delta):
	if Engine.is_editor_hint():
		update_configuration_warnings()
	
func _get_configuration_warnings():
	var warnings = []
	var has_health = false
	for child in get_children():
		if child is Health: has_health = true
		
	if !has_health: warnings.append("This node need a Health component to work correctly")
	return warnings


func _on_area_entered(area):
	if area is Hitbox:
		if area.is_ally: return
		health_component.get_damage(area.damage)

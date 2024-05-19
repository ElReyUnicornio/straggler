extends Area3D
class_name Hurtbox

var health_component: Health

func _ready():
	health_component = get_node("Health")
	
func _get_configuration_warnings():
	if !health_component:
		return "- This node has not a  health component, so it cant manage the health of the object"



func _on_area_entered(area):
	if area is Hitbox:
		health_component.get_damage(area.damage)

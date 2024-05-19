extends RigidBody3D

func _on_health_die():
	queue_free()


func _on_health_health_changed(new_health):
	print(new_health)

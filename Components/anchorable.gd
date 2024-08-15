extends RigidBody3D
class_name Anchorable

@export var M_name: String

signal die(body: Anchorable)

func disolve():
	die.emit(self)
	GlobalPlayer.add_resource(M_name)
	queue_free()

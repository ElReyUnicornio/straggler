@tool
class_name World
extends XRToolsSceneBase

@export var enable_drill: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	if !Engine.is_editor_hint():
		GameManager.world = self
		if enable_drill: GlobalPlayer.enableDrill()
		else: GlobalPlayer.disableDrill()

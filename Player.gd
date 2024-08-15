extends Node
class_name PlayerGlobal

var current: Player

var drillEnabled: bool = true

signal drillEnabledUpdated(value: bool)

#stats
var silicon := 0
var bismuth := 0
var platinum := 0

var turret_upgrades = []
var dome_upgrades = []
var player_upgrades = []

func _ready():
	if current:
		disableDrill()
	if GameManager:
		GameManager.game_start.connect(enableDrill)
		GameManager.game_start.connect(reset_stats)
		GameManager.game_end.connect(disableDrill)

func enableDrill():
	drillEnabled = true;
	drillEnabledUpdated.emit(drillEnabled)

func disableDrill():
	drillEnabled = false;
	drillEnabledUpdated.emit(drillEnabled)

func reset_stats():
	silicon = 0
	bismuth = 0
	platinum = 0
	
	turret_upgrades = []
	dome_upgrades = []
	player_upgrades = []

func add_resource(data: String):
	match(data.to_lower()):
		"silicon": silicon += 1
		"bismuth": bismuth += 1
		"platinum": platinum += 1

func get_height():
	print(current.body.player_height_offset)
	return current.body.player_height_offset

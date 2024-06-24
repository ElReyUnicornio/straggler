extends Node

var current: Player
var drillEnabled: bool = true

signal drillEnabledUpdated(value: bool)

func enableDrill():
	drillEnabled = true;
	drillEnabledUpdated.emit(drillEnabled)

func disableDrill():
	drillEnabled = false;
	drillEnabledUpdated.emit(drillEnabled)

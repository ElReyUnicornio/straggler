extends XROrigin3D
class_name Player

var xr_interface: XRInterface
@onready var body := $PlayerBody

func _ready():
	GlobalPlayer.current = self
	GlobalPlayer.drillEnabledUpdated.connect(change_laser_state)
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialised successfully")
		DisplayServer.window_set_vsync_mode (DisplayServer.VSYNC_DISABLED)
		get_viewport().use_xr = true
		
	else:
		print("OpenXR not initialised, please check if your headset is connected")

func change_laser_state(value: bool):
	$XRleftHand/FunctionPointer.enabled = !value
	$XRrightHand/FunctionPointer.enabled = !value
	if value:
		$XRleftHand/FunctionPointer.show_laser = 0
		$XRrightHand/FunctionPointer.show_laser = 0
	else:
		$XRleftHand/FunctionPointer.show_laser = 1
		$XRrightHand/FunctionPointer.show_laser = 1

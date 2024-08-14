extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.next_wave_timmer.time_left:
		var time_left_mins = floor(GameManager.next_wave_timmer.time_left / 60)
		var time_left_secs = floor( GameManager.next_wave_timmer.time_left - (time_left_mins * 60) )
		$Panel/Label.text = "Tiempo restante: " + str(time_left_mins) + ":" + str(time_left_secs).lpad(2,"0")

func _on_button_down():
	get_tree().quit()

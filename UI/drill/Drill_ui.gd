extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.next_wave_timmer:
		var time_left_mins = floor(GameManager.next_wave_timmer.time_left / 60)
		var time_left_secs = floor( GameManager.next_wave_timmer.time_left - (time_left_mins * 60) )
		$Panel2/VBoxContainer/Label.text = "Tiempo restante: " + str(time_left_mins) + ":" + str(time_left_secs).lpad(2,"0")
	$Panel2/VBoxContainer/HBoxContainer/Label.text = str(GlobalPlayer.silicon)
	$Panel2/VBoxContainer/HBoxContainer/Label2.text = str(GlobalPlayer.bismuth)
	$Panel2/VBoxContainer/HBoxContainer/Label3.text = str(GlobalPlayer.platinum)
	
func _on_button_down():
	get_tree().quit()

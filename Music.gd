extends AudioStreamPlayer


func _ready():
	pass

func process(_delta):
	if $Music.playing == false:
		$Music.play()
	pass

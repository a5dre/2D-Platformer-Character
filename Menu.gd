extends Control



func _on_Save_pressed():
	Global.save_game()

func _on_Load_pressed():
	Global.load_game()

func _on_Quit_pressed():
	get_tree().quit()

extends Node2D

onready var Skull = load("res://Enemy/Skull.tscn")

func _physics_process(_delta):
	if not has_node("Skull"):
		var skull = Skull.instance()
		add_child(skull)
		skull.name = "Skull"
	if not has_node("Skull2"):
		var skull = Skull.instance()
		add_child(skull)
		skull.name = "Skull2"

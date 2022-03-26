extends Node2D

var score = 10

func _on_Bone_body_entered(body):
	if body.name == "Player":
		Global.update_score(score)
		queue_free()



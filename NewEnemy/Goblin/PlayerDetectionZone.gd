extends Area2D

var Player = null

func can_see_player():
	return Player != null


func _on_PlayerDetectionZone_body_entered(body):
	Player = body


func _on_PlayerDetectionZone_body_exited(body):
	Player = null

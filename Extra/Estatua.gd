extends KinematicBody2D

var stats = PlayerStats

func _ready():
	pass # Replace with function body.



func _on_aura_body_entered(body):
	print("si")
	stats.health += 5

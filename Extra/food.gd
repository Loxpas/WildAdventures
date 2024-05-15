extends Sprite

var stats = PlayerStats


func _ready():
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	print("si")
	stats.health += 1
	queue_free()


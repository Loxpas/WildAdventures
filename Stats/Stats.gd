extends Node2D

export(int) var max_health = 5 setget set_max_health
var health = max_health setget set_health

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed")

func set_health(value):
	health = clamp(value, 0, max_health) # Usamos 'clamp' para asegurarnos de que la salud esté dentro del rango permitido
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
		get_tree().change_scene("res://UI/GameOverScreen.tscn")
		
func _ready():
	self.health = max_health

extends Node2D

var score = 0

func _ready():
	connect_enemies()

func connect_enemies():
	var bat_node = get_node("Bat") # Ajusta la ruta al nodo Bat en tu escena
	var slime_node = get_node("Slime") # Ajusta la ruta al nodo Slime en tu escena
	var skeleton_node = get_node("Skeleton") # Ajusta la ruta al nodo Skeleton en tu escena
	var demon_node = get_node("Demon")
	var doc_node = get_node("Doc")
	var eye_node = get_node("Eye")
	var goblin_node = get_node("Goblin")
	var ogro_node = get_node("Ogro")
	var orc_node = get_node("Orc")

	if bat_node:
		bat_node.connect("enemy_died", self, "_on_enemy_died")
	if slime_node:
		slime_node.connect("enemy_died", self, "_on_enemy_died")
	if skeleton_node:
		skeleton_node.connect("enemy_died", self, "_on_enemy_died")
	if demon_node:
		demon_node.connect("enemy_died", self, "_on_enemy_died")
	
	
	
func _on_enemy_died():
	score += 1
	print("Score:", score)
	if score == 9:
		print("finishhhhhhhh")
		get_tree().change_scene("res://Extra/WinScreen/Win.tscn")

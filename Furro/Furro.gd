extends KinematicBody2D

const Acceleration = 500
const Max_speed = 100 
const Friction = 500

enum {		#Array de movimientos, desplazamiento y ataque
	MOVE,
	ROLL,
	ATTACK,
}

var state = MOVE
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")


func _ready():
	animationTree.active = true

func _physics_process(delta):
	
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			pass
		ATTACK:
			attack_state(delta)

func move_state(delta): # Codigo de movimientos del personaje
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_d") - Input.get_action_strength("ui_a")
	input_vector.y = Input.get_action_strength("ui_s") - Input.get_action_strength("ui_w")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * Max_speed, Acceleration * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, Friction * delta)

	#move_and_collide(velocity * delta)  # este 
	velocity = move_and_slide(velocity) # y este al aprecer hacen lo mismo
	
	if Input.is_action_just_pressed("ui_attackFurro"):
		state = ATTACK

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func attack_animation_finished():
	state = MOVE

extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var Acceleration = 300
export var Max_Speed = 150
export var Fricction = 200
export var Wander_Target_Range = 4

signal enemy_died

enum{
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = CHASE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController


func _ready():
	state = pick_random_state([IDLE, WANDER])


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	knockback = knockback.move_toward(Vector2.ZERO, Fricction * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, Fricction * delta)
			seek_player()
			
			if wanderController.get_time_left() == 0:
				update_wander()
				
		WANDER:
			seek_player()
			
			if wanderController.get_time_left() == 0:
				update_wander()
							
			accelerate_towards_point(wanderController.target_position, delta)
		
			if global_position.distance_to(wanderController.target_position) <= Wander_Target_Range:
				update_wander()
				
		CHASE:
			var player = playerDetectionZone.Player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	
	velocity = move_and_slide(velocity)
	
	
func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * Max_Speed, Acceleration * delta)
	sprite.flip_h = velocity.x < 0	

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
		
func update_wander():
		state = pick_random_state([IDLE, WANDER])
		wanderController.start_wander_timer(rand_range(1, 3))
		
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 250
	hurtbox.create_hit_effect()


func _on_Stats_no_health():
	print("DeathEye")
	emit_signal("enemy_died")
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position

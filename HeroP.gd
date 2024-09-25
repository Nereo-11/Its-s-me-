extends CharacterBody2D

const SPEED = 450
const GRAVITY = 9000
const JUMP_POWER = -2000
const FLOOR = Vector2(0, -1)

var velocity = Vector2(0,0)
var on_ground = false
var looking_left = false
var life = Resources.life
var points = Resources.points  # Singleton variable
var collision

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$Timer.start()  # Start the timer when the game starts.
	

func _physics_process(delta):
	if Resources.life <= 0:
		return

	velocity.x = 0
	var speed = SPEED
	
	if Input.is_action_pressed("ui_attack"):
		if Resources.points < 3:
			$AnimationPlayer.play("Attack1")
		else:
			$AnimationPlayer.play("Attack2")
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
		looking_left = false
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED
		looking_left = true
	
	if Input.is_action_pressed("ui_up") and on_ground:
		velocity.y = JUMP_POWER
		on_ground = false
	
	velocity.y += GRAVITY * delta
	set_velocity(velocity)
	set_up_direction(FLOOR)
	move_and_slide()
	velocity = velocity
	
	if velocity.x != 0:
		if Resources.points < 3:
			$AnimationPlayer.play("Run1")
			$Sprite2D.flip_h = velocity.x < 0
		else:
			$AnimationPlayer.play("Run2")
			$Sprite2D.flip_h = velocity.x < 0
	
	if velocity.y != 0:
		if Resources.points < 3:
			$AnimationPlayer.play("Jump1")
		else:
			$AnimationPlayer.play("Jump2")
	
	if is_on_floor():
		on_ground = true

	if (get_slide_collision_count() > 0):
		for i in range(get_slide_collision_count()):
			if "Enemy" in get_slide_collision(i).collider.name:
				touched(get_slide_collision(i).collider.name)
			elif "Bandera" in get_slide_collision(i).collider.name:
				show_win_label()
		
#func _on_Orbe_body_entered(body):
#	if body.name == "Hero":
		#Resources.points += 1
#		update_life_counter()
		#queue_free()

func update_life_counter():
	var life_counter = get_node("LifeCounterHero")
	if life_counter:
		life_counter.text = "Lives: %d     Points: %d" % [Resources.life, Resources.points]
	else:
		print("Error: LifeCounterHero node not found.")


func touched(collision_object):
	Resources.life -= 1
	#Resources.points -= 1
	update_life_counter()
	if Resources.life > 0:
		position.x = -750
		position.y = -69
		start(position)
	else:
		if Resources.points < 3:
			$AnimationPlayer.play("Dead1")
		else:
			$AnimationPlayer.play("Dead2")
		set_process(false)
		set_physics_process(false)
		show_game_over()


func _on_SwordHit_body_entered(body):
	if "Enemy" in body.get_name():
		body.queue_free()
	#print(body.get_name())
	#if ("Enemy" in body.get_name()):
	#	get_node("../" + body.get_name()).hide()
	#	get_node("../" + body.get_name()).remove_and_skip()

func show_game_over():
	var game_over_label = $GameOverLabel
	if game_over_label:
		game_over_label.visible = true
	else:
		print("Error: GameOverLabel node not found.")

func show_win_label():
	var win_label = $WinLabel
	if win_label:
		win_label.visible = true
	else:
		print("Error: WinLabel node not found.")
	# Detener el movimiento al quitar el script de movimiento del nodo
	set_process(false)
	set_physics_process(false)


func _on_Bandera_body_entered(body):
	if body.name == "Hero":
		show_win_label()

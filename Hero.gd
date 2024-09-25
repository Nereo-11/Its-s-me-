extends CharacterBody2D

const SPEED = 450
const GRAVITY = 9000
const JUMP_POWER = -2000
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
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
	velocity.x = 0
	var speed = SPEED
	
	if Input.is_action_pressed("ui_attack"):
		$AnimationPlayer.play("Attack1")
	
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
		$AnimationPlayer.play("Run1")
		$Sprite2D.flip_h = velocity.x < 0
	
	if velocity.y != 0:
		$AnimationPlayer.play("Jump1")
	
	if is_on_floor():
		on_ground = true

	if (get_slide_collision_count() > 0):
		for i in range(get_slide_collision_count()):
			if "Enemy" in get_slide_collision(i).collider.name:
				touched(get_slide_collision(i).collider.name)
		
func _on_Orbe_body_entered(body):
	if body.name == "Hero":
		points += 1 
		var life_counter_hero = $LifeCounterHero
		if life_counter_hero:
			life_counter_hero.text = "Lives: " + str(life) + "   Points: " + str(points)
		#get_node("LifeCounterHero").text = str("Lives: ", life,"     ", "Points: ", points)
		else:
			print("Error: LifeCounterHero node not found.")


func touched(collision_object):

	life -= 1
	get_node("LifeCounterHero").text = str("Lives: ", life,"     ", "Points: ", points)
	if (life > 0):
		position.x = -750
		position.y = -69
		start(position)
	else:
		#$CollisionShape2D.set_deferred("disabled", true)
		#get_node("../GameOverLabel").show()  # Make the Game Over label visible
		$AnimationPlayer.play("Dead1") #Sucede solo si no se presiono a otra tecla
		
func _on_SwordHit_body_entered(body):
	if "Enemy" in body.get_name():
		body.queue_free()
	#print(body.get_name())
	#if ("Enemy" in body.get_name()):
	#	get_node("../" + body.get_name()).hide()
	#	get_node("../" + body.get_name()).remove_and_skip()




func _on_Orbe2_body_entered(body):
	if body.name == "Hero":
		points += 1
		var life_counter_hero = $LifeCounterHero
		if life_counter_hero:
			life_counter_hero.text = "Lives: " + str(life) + "   Points: " + str(points)
		#get_node("LifeCounterHero").text = str("Lives: ", life,"     ", "Points: ", points)
		else:
			print("Error: LifeCounterHero node not found.")
	pass # Replace with function body.




extends CharacterBody2D

@export var speed = 60  # Velocidad del enemigo
var player1
var collision = Vector2.ZERO  # Almacena el resultado de la colisión

func _ready():
	# Obtener referencias a los nodos de los jugadores
	#player1 = get_node("../Player") Descomentar para tomar el otro jugador
	player1 = get_node("../Hero") 

func _physics_process(delta):
	# Calcular la dirección hacia el jugador más cercano
	var direction_to_player1 = (player1.global_position - global_position).normalized()

	# Elegir la dirección hacia el jugador más cercano
	var direction_to_target = direction_to_player1

	# Calcular el desplazamiento basado en la velocidad y la dirección hacia el jugador más cercano
	var displacement = direction_to_target * speed * delta

	# Intenta mover el enemigo y obtén el resultado de la colisión
	collision = move_and_collide(displacement)

	# Si hay colisión, invierte la dirección para evitar atravesar objetos
	if collision:
		direction_to_target *= -1

	# Mueve el enemigo según la dirección hacia el jugador más cercano
	set_velocity(direction_to_target * speed)
	move_and_slide()


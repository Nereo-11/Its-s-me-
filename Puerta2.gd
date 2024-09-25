 extends Area2D

# Asegúrate de ajustar este nombre de ruta según el nodo del mapa en tu estructura de nodos.
var new_map_path = "res://Niveles/segundoNivel.tscn"

func _ready():
	# Conecta la señal body_entered a una función que manejará el cambio de escena
	connect("body_entered", Callable(self, "_on_Puerta_body_entered"))

func _on_Puerta_body_entered(body):
	# Comprueba si el cuerpo es el jugador. Asegúrate de que 'Player' sea el nombre correcto de tu nodo de jugador.
	if body.name == "Hero":
		# Cambia al mapa nuevo
		change_scene_to_file()

func change_scene_to_file():
	# Asegúrate de que el path del mapa nuevo es correcto.
	var new_scene = load(new_map_path)
	if new_scene:
		get_tree().change_scene_to_packed(new_scene)
	else:
		print("No se pudo cargar la escena: ", new_map_path)

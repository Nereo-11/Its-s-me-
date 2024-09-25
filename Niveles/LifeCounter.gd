extends Label

var life = Resources.life  # Singleton variable
var points = Resources.points

func _ready():
	self.text = str("Lives: ", life,"     ", "Points: ", points)
	pass # Replace with function body.

extends StaticBody2D

var Effects = null
onready var Explosion = load("res://Effects/Explosion.tscn")
var Obstacle_Container = null
var health = 10
var size = 1

#Change this function so that the police car is always at full speed but has slow rotation so it is hard to hit the player
func _ready():
	size = rand_range(1, 3)
	rotation = rand_range(0, 2 * PI)
	scale *= size
	health *= size

func _physics_process(_delta):
	pass

func damage(d):
	health -= d
	if health <= 0:
		Effects = get_node_or_null("/root/Game/Effects")
		if Effects != null:
			var explosion = Explosion.instance()
			Effects.add_child(explosion)
			explosion.global_position = global_position
		queue_free()

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.damage(1 * size)
		damage(100)

func obstacle(): #this function is necessary for tracking score at the moment even though it is empty, see bullet script
	pass


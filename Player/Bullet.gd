extends Line2D

var direction = Vector2.ZERO
var speed = 50.0
var damage = 3 #3

onready var Explosion = load("res://Effects/Explosion.tscn")
var Effects = null

func _ready():
	rotation = direction.angle()
	pass

func _physics_process(delta):
	position += direction * speed

func _on_Area2D_body_entered(body):
	if body.name != "Player":
		if body.has_method("damage"):
			body.damage(damage)
			if body.has_method("obstacle"):
				Global.update_score(50)
				if body.health <= 0:
					if Global.health <= 0.9:
						Global.updateHealth(Global.health + (body.size / 20.0))
			else:
				Global.update_score(100)
				if body.health <= 0:
					if Global.health <= 0.9:
						Global.updateHealth(Global.health + 0.1)
		Effects = get_node_or_null("/root/Game/Effects")
		if Effects != null:
			var explosion = Explosion.instance()
			Effects.add_child(explosion)
			explosion.global_position = global_position
			explosion.scale = Vector2(0.3, 0.3)
		queue_free()

func _on_Timer_timeout():
	queue_free()



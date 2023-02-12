extends KinematicBody2D

var Effects = null
onready var Explosion = load("res://Effects/Explosion.tscn")
var Enemy_Container = null
var id = -1
var rotation_speed = 5.0
var speed = 7.5 #6
var speed_buff = 2.0 #apply extra speed when out of player range
var velocity = Vector2.ZERO
var health = 10
var Player = null

#Change this function so that the police car is always at full speed but has slow rotation so it is hard to hit the player
func _ready():
	var direction = target_direction()
	if direction != null:
		rotation = direction.angle() - PI

func _physics_process(_delta):
	var direction = target_direction()
	if direction != null:
		var current_direction = Vector2.RIGHT.rotated(rotation)
		#print(current_direction)
		var added_angle = current_direction.angle_to(direction)
		Player = get_node_or_null("/root/Game/Player_Container/Player")
		if Player != null:
			if global_position.distance_to(Player.getPosition()) > 900:
				rotation += added_angle
			else:
				rotation += clamp(added_angle, -rotation_speed / 200.0, rotation_speed / 200.0)
		#velocity = velocity + (direction * speed) #Set velocity
		velocity = current_direction
		velocity = velocity.normalized() * speed * rotation_speed * 10.0 #Change velocity to between range
		if Player != null:
			if global_position.distance_to(Player.getPosition()) > 700:
				velocity *= speed_buff
		velocity = move_and_slide(velocity, Vector2.ZERO) #Apply velocity
		#rotation = velocity.angle()

func damage(d):
	health -= d
	if health <= 0:
		Effects = get_node_or_null("/root/Game/Effects")
		if Effects != null:
			var explosion = Explosion.instance()
			Effects.add_child(explosion)
			explosion.global_position = global_position
		Enemy_Container = get_node_or_null("/root/Game/Enemy_Container")
		if Enemy_Container != null:
			Enemy_Container.enemyDeath(id)
		queue_free()

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.damage(1)
		damage(100)

func target_direction():
	Player = get_node_or_null("/root/Game/Player_Container/Player")
	if Player != null:
		var direction = global_position.angle_to_point(Player.global_position) - PI/2
		return Vector2.UP.rotated(direction)
	else:
		print("Player variable not defined in PoliceCar.gd")
		return null

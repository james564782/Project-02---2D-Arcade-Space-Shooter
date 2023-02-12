extends KinematicBody2D

var Effects = null
onready var Bullet = load("res://Player/Bullet.tscn")
onready var Explosion = load("res://Effects/Explosion.tscn")

var health = 10.0
var maxHealth = 10.0

var bulletTimer = 0.0
var bulletMax = 100.0
var cooldownRate = 0.3
var warmupRate = 0.5

var wheel_base = 70
var steering_angle = 15

var velocity = Vector2.ZERO
var steer_angle

var engine_power = 500  # Forward acceleration force.
var acceleration = Vector2.ZERO

var friction = -0.9
var drag = -0.0015

var braking = -450
var max_speed_reverse = 350

var slip_speed = 400  # Speed where traction is reduced
var traction_fast = 0.1  # High-speed traction
var traction_slow = 0.7  # Low-speed traction

func _ready():
	rotation = -PI/2

func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)
	if Input.is_action_pressed("shoot") && bulletTimer + warmupRate < bulletMax:
		if rand_range(95, 100) > bulletTimer:
			shoot()
		else:
			bulletTimer = clamp(bulletTimer - (cooldownRate / 4), 0, bulletMax)
	else:
		bulletTimer = clamp(bulletTimer - cooldownRate, 0, bulletMax)
	Global.updateCooldown(bulletTimer / bulletMax)

func shoot():
	Effects = get_node_or_null("/root/Game/Effects")
	if Effects != null:
		var bullet = Bullet.instance()
		bullet.global_position = global_position + Vector2.UP.rotated(rotation + PI/2) * 28 + Vector2(rand_range(-1.8, 1.8), 0).rotated(rotation + PI/2)
		bullet.direction = Vector2.UP.rotated(rotation + PI/2 + rand_range(-PI/30.0, PI/30.0))
		Effects.add_child(bullet)
		bulletTimer = clamp(bulletTimer + warmupRate, 0, bulletMax)

func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force

func get_input():
	var turn = 0
	if Input.is_action_pressed("right"):
		turn += 1
	if Input.is_action_pressed("left"):
		turn -= 1
	steer_angle = turn * steering_angle
	if Input.is_action_pressed("forward"): #accelerate
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()

func damage(d):
	health -= d
	Global.updateHealth(Global.health - (d / maxHealth))
	if Global.health <= 0:
		Effects = get_node_or_null("/root/Game/Effects")
		if Effects != null:
			var explosion = Explosion.instance()
			Effects.add_child(explosion)
			explosion.global_position = global_position
			hide()
			yield(explosion, "animation_finished")
		queue_free()

func getPosition():
	return global_position

func _on_Area2D_body_entered(body):
	pass
	#if body.name != "Player":
	#	damage(0)

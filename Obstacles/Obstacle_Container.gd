extends Node2D

onready var Obstacle = load("res://Obstacles/Obstacle.tscn")

var spawnObstacles = true

var distanceFromPlayer = 600 #how far enemies spawn from player

func _ready():
	randomize()
	spawn_obstacle()

func spawn_obstacle():
	var Player = get_node_or_null("/root/Game/Player_Container/Player")
	var Obstacle_Container = get_node_or_null("/root/Game/Obstacle_Container")
	if Obstacle != null && Player != null && Obstacle_Container != null:
		var spawnPosition = Player.global_position
		spawnPosition += (Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized() * distanceFromPlayer)
		var obstacle = Obstacle.instance()
		obstacle.global_position = spawnPosition
		Obstacle_Container.add_child(obstacle)

func _on_Timer_timeout():
	spawn_obstacle()
	

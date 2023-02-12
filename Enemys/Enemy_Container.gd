extends Node2D

onready var PoliceCar = load("res://Enemys/PoliceCar.tscn")

var maxEnemies = 3
var enemyCount = 0
var enemyId = 0

var maxEnemyTimer = 30 #increase max number of enemies

var spawnEnemies = true

var distanceFromPlayer = 600 #how far enemies spawn from player

var Enemies = [] #.append to add items, .erase to remove items

func _ready():
	randomize()

func _physics_process(_delta):
	if enemyCount < maxEnemies && spawnEnemies:
		spawnEnemy()

func enemyDeath(id):
	for enemy in Enemies:
		if enemy.id == id:
			Enemies.erase(enemy)
			enemyCount -= 1

func spawnEnemy():
	var Player = get_node_or_null("/root/Game/Player_Container/Player")
	var Enemy_Container = get_node_or_null("/root/Game/Enemy_Container")
	if PoliceCar != null && Player != null && Enemy_Container != null:
		var spawnPosition = Player.global_position
		spawnPosition += (Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized() * distanceFromPlayer)
		var enemy = PoliceCar.instance()
		enemy.global_position = spawnPosition
		Enemy_Container.add_child(enemy)
		Enemies.append(enemy)
		enemy.id = enemyId
		var inherit_value = rand_range(0.85, 1.15)
		enemy.speed *= inherit_value
		#enemy.rotation_speed *= -(inherit_value - 1.0) + 1
		enemyId += 1
		enemyCount += 1
		#print("Spawned Enemy " + str(enemyId) + " at " + str(spawnPosition) + " with " + str(enemy.speed) + " movement speed and " + str(enemy.rotation_speed) + " rotation speed")


func _on_Timer_timeout():
	maxEnemies += 1
	print("Increase enemy count to " + str(maxEnemies))

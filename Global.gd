extends Node

var VP = null

var score = 0
var time = 0

var health = 1
var weaponCooldown = 0

func _ready():
	randomize()
	pause_mode = Node.PAUSE_MODE_PROCESS
	VP = get_viewport().size
	var _signal = get_tree().get_root().connect("size_changed",self,"_resize")
	reset()

func _physics_process(_delta):
	pass
	#var Enemy_Container = get_node_or_null("/root/Game/Enemy_Container")
	#if Enemy_Container != null:
	#	if Asteroid_Container.get_child_count() == 0 and Enemy_Container.get_child_count() == 0:
	#		var _scene = get_tree().change_scene("res://UI/End_Game.tscn")

func updateHealth(h):
	health = h
	if health <= 0:
		var _scene = get_tree().change_scene("res://UI/End_Game.tscn")
		print("end game")
	else:
		var HUD = get_node_or_null("/root/Game/UI/HUD")
		if HUD != null:
			HUD.update_health()

func updateCooldown(c):
	weaponCooldown = c
	var HUD = get_node_or_null("/root/Game/UI/HUD")
	if HUD != null:
		HUD.update_cooldown()

func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		var Pause_Menu = get_node_or_null("/root/Game/UI/Pause_Menu")
		if Pause_Menu == null:
			get_tree().quit()
		else:
			if Pause_Menu.visible:
				Pause_Menu.hide()
				get_tree().paused = false
			else:
				Pause_Menu.show()
				get_tree().paused = true

func _resize():
	VP = get_viewport().size
	var HUD = get_node_or_null("/root/Game/UI/HUD")
	if HUD != null:
		HUD.update_lives()

func update_score(s):
	score += s
	var HUD = get_node_or_null("/root/Game/UI/HUD")
	if HUD != null:
		HUD.update_score()

#func update_lives(l):
#	lives += l
#	if lives < 0:
#		var _scene = get_tree().change_scene("res://UI/End_Game.tscn")
#	else:
#		var HUD = get_node_or_null("/root/Game/UI/HUD")
#		if HUD != null:
#			HUD.update_lives()

func reset():
	score = 0
	time = 0
	health = 1
	weaponCooldown = 0
	

extends Control

var lives_pos = Vector2.ZERO
var lives_index = 30

func _ready():
	update_score()
	update_time()
	update_health()
	update_cooldown()

func update_score():
	$Score.text = "Score: " + str(Global.score)

func update_time():
	$Time.text = "Time: " + str(Global.time)

func update_health():
	var health = Global.health
	$HealthBarPartial.rect_size = Vector2(health * 2 * 100, 20)
	if health > 0.3:
		$HealthBarPartial.color = Color(0, 1, 0, 0.5)
	else:
		$HealthBarPartial.color = Color(1, 0, 0, 0.5)

func update_cooldown():
	var cooldown = Global.weaponCooldown
	$CooldownBarPartial.rect_size = Vector2(cooldown * 2 * 100, 20)
	$CooldownBarPartial.color = Color(cooldown, -(cooldown - 1) + 0.1, 0, .5)

func _on_Timer_timeout():
	Global.time += 1
	Global.update_score(5)
	#if Global.time < 0:
	#	var _scene = get_tree().change_scene("res://UI/End_Game.tscn")
	#else:
	update_time()

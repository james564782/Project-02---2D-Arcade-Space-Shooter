extends Control


func _ready():
	pass


func _on_Play_pressed():
	get_tree().change_scene("res://GameScene/Game.tscn")


func _on_Quit_pressed():
	get_tree().quit()

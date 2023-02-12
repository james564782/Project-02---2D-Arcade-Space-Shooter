extends Node2D


func _ready():
	pass

func _process(delta):
	var Player = get_node_or_null("/root/Game/Player_Container/Player")
	#var sprite = ("root/Map/Sprite")
	if Player != null:
		var pos = Player.getPosition()
		global_position = Vector2(round((pos.x / 768) - 0.5) * 768, round((pos.y / 768) - 0.5)* 768)
		#sprite.offset = global_position

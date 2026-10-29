extends Node2D

var dungeon_scene = preload("res://scenes/Dungeon.tscn")
var player_scene = preload("res://scenes/Player.tscn")

var dungeon
var player

func _ready():
	# Создаем подземелье
	dungeon = dungeon_scene.instantiate()
	add_child(dungeon)

	# Создаем игрока
	player = player_scene.instantiate()
	add_child(player)
	player.global_position = dungeon.get_start_position()

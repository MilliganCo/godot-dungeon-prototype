extends Node2D

@export var tile_size = 32
@export var dungeon_size = Vector2(50, 50)

var tiles = []

func _ready():
	generate_dungeon()

func generate_dungeon():
	tiles = []
	for y in range(int(dungeon_size.y)):
		tiles.append([])
		for x in range(int(dungeon_size.x)):
			tiles[y].append(0)  # Пустые клетки

	# Пример: создаем центральную комнату
	for y in range(20, 30):
		for x in range(20, 30):
			tiles[y][x] = 1  # Заполняем комнату

	update_tilemap()

func update_tilemap():
	var tile_map = $TileMap
	tile_map.clear()
	# This source prototype has no TileSet/artwork. Keep its room data usable
	# without attempting invalid tile writes into an unconfigured TileMap.
	if tile_map.tile_set == null:
		return
	for y in range(int(dungeon_size.y)):
		for x in range(int(dungeon_size.x)):
			if tiles[y][x] == 1:
				tile_map.set_cell(0, Vector2i(x, y), 0, Vector2i.ZERO)

func get_start_position():
	return $StartPosition.global_position

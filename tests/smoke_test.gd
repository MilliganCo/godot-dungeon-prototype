extends SceneTree

var checks := 0
var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _expect(condition: bool, label: String) -> void:
	checks += 1
	if condition:
		print("PASS: " + label)
	else:
		failures += 1
		push_error("FAIL: " + label)

func _run() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	if packed == null:
		_expect(false, "main scene loads")
		quit(1)
		return
	var main := packed.instantiate()
	root.add_child(main)
	await process_frame
	var dungeon := main.get_node_or_null("Dungeon")
	var player := main.get_node_or_null("Player")
	_expect(dungeon != null, "main creates a dungeon")
	_expect(player is CharacterBody2D, "main creates the player actor as its direct child")
	if dungeon == null or not player is CharacterBody2D:
		main.queue_free()
		await process_frame
		quit(1)
		return
	player.set_physics_process(false)
	_expect(dungeon.tiles.size() == 50 and dungeon.tiles[0].size() == 50, "grid is 50 by 50")
	var floor_cells := 0
	for row in dungeon.tiles:
		for tile in row:
			if tile == 1:
				floor_cells += 1
	_expect(floor_cells == 100, "central room contains 100 floor cells")
	_expect(player.global_position.is_equal_approx(dungeon.get_start_position()), "player uses the existing start marker")

	var item := (load("res://scenes/Item.tscn") as PackedScene).instantiate()
	main.add_child(item)
	_expect(item is Area2D, "item scene root matches its Area2D script")
	item._on_body_entered(player)
	_expect(player.inventory.get("key", 0) == 1, "item gives one key")
	await process_frame
	_expect(not is_instance_valid(item), "collected item is removed")

	var door := (load("res://scenes/Door.tscn") as PackedScene).instantiate()
	main.add_child(door)
	_expect(door is Area2D, "door scene exposes its body_entered trigger")
	door._on_body_entered(player)
	_expect(player.inventory.get("key", 0) == 0, "door consumes one key")
	await process_frame
	_expect(not is_instance_valid(door), "opened door is removed")

	var locked_door := (load("res://scenes/Door.tscn") as PackedScene).instantiate()
	main.add_child(locked_door)
	locked_door._on_body_entered(player)
	_expect(not locked_door.is_queued_for_deletion(), "door remains without a key")
	locked_door.queue_free()
	for path in ["res://scenes/Enemy.tscn", "res://scenes/Boss.tscn"]:
		var enemy := (load(path) as PackedScene).instantiate()
		main.add_child(enemy)
		enemy.set_physics_process(false)
		_expect(enemy is CharacterBody2D, path.get_file() + " root matches its character script")
		enemy.queue_free()
	main.queue_free()
	await process_frame
	print("DUNGEON_CHECKS=%d FAILURES=%d" % [checks, failures])
	quit(1 if failures else 0)

extends CharacterBody2D

@export var speed = 200

# Инвентарь игрока
var inventory = {}

func _ready():
	# Инициализация инвентаря
	inventory = {}

func _physics_process(_delta):
	var direction = Vector2()
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1

	velocity = direction.normalized() * speed
	move_and_slide()

# Добавление предмета в инвентарь
func collect_item(item_type):
	if item_type in inventory:
		inventory[item_type] += 1
	else:
		inventory[item_type] = 1
	print("Item collected: %s (x%d)" % [item_type, inventory[item_type]])

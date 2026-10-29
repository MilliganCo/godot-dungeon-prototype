extends Area2D

@export var required_item = "key"  # Тип предмета, необходимого для открытия

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player" and body.inventory.get(required_item, 0) > 0:
		body.inventory[required_item] -= 1  # Уменьшаем количество ключей
		print("Door opened!")
		queue_free()  # Удаляем дверь

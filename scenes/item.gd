extends Area2D

@export var item_type = "key"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":  # Проверяем, что это игрок
		body.collect_item(item_type)
		queue_free()  # Удаляем предмет

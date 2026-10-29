extends CharacterBody2D

@export var speed = 50
var player = null

func _ready():
	player = get_parent().get_node_or_null("Player")

func _physics_process(_delta):
	if is_instance_valid(player):
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		move_and_slide()

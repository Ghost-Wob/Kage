extends CharacterBody2D

@export var speed: float = 80.0
@export var max_health: float = 30.0
@export var contact_damage: float = 10.0
@export var xp_value: int = 3

var health: float = max_health
var _player: Node2D = null

func _ready() -> void:
	_player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta: float) -> void:
	if _player == null:
		return
	velocity = (_player.global_position - gloenemy_basebal_position).normalized() * speed
	move_and_slide()

func take_damage(amount: float) -> void:
	health -= amount
	if health <= 0.0:
		_die()

func _die() -> void:
	GlobalData.gain_xp(xp_value)
	GlobalData.score += xp_value
	queue_free()

# Connecte ce signal depuis la scène : Area2D body_entered → player
func on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.take_damage(contact_damage)

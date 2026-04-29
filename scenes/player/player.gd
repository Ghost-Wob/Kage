extends CharacterBody2D

@export var base_speed: float = 200.0
@export var max_health: float = 100.0

var health: float = max_health
var speed: float = base_speed

signal health_changed(current: float, maximum: float)
signal died

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	add_to_group("player")
	GlobalData.level_up.connect(_on_level_up)
	GlobalData.rage_changed.connect(_on_rage_changed)

func _physics_process(delta: float) -> void:
	var dir := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()
	velocity = dir * speed
	move_and_slide()
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0

func take_damage(amount: float) -> void:
	var actual := amount * (0.5 if GlobalData.rage_active else 1.0)
	health -= actual
	GlobalData.add_rage(amount * 0.4)
	emit_signal("health_changed", health, max_health)
	if health <= 0.0:
		emit_signal("died")
		GlobalData.emit_signal("player_died")

func _on_level_up(_level: int) -> void:
	health = min(health + 20.0, max_health)
	emit_signal("health_changed", health, max_health)

func _on_rage_changed(_value: float) -> void:
	speed = base_speed * (1.5 if GlobalData.rage_active else 1.0)
	modulate = Color(1.3, 0.2, 0.2) if GlobalData.rage_active else Color.WHITE

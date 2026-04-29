extends Node

signal player_died
signal xp_gained(amount: int)
signal level_up(new_level: int)
signal rage_changed(value: float)

var score: int = 0
var elapsed_time: float = 0.0
var is_game_running: bool = false

var player_xp: int = 0
var player_level: int = 1
var xp_to_next_level: int = 10

var rage: float = 0.0
const MAX_RAGE: float = 100.0
var rage_active: bool = false
var rage_timer: float = 0.0
const RAGE_DURATION: float = 30.0

func gain_xp(amount: int) -> void:
	player_xp += amount
	emit_signal("xp_gained", amount)
	if player_xp >= xp_to_next_level:
		player_xp -= xp_to_next_level
		player_level += 1
		xp_to_next_level = int(xp_to_next_level * 1.4)
		emit_signal("level_up", player_level)

func add_rage(amount: float) -> void:
	if rage_active:
		return
	rage = clamp(rage + amount, 0.0, MAX_RAGE)
	emit_signal("rage_changed", rage)
	if rage >= MAX_RAGE:
		_activate_rage()

func _activate_rage() -> void:
	rage_active = true
	rage_timer = RAGE_DURATION
	emit_signal("rage_changed", rage)

func tick_rage(delta: float) -> void:
	if not rage_active:
		return
	rage_timer -= delta
	if rage_timer <= 0.0:
		rage_active = false
		rage = 0.0
		emit_signal("rage_changed", rage)

func reset() -> void:
	score = 0
	elapsed_time = 0.0
	is_game_running = false
	player_xp = 0
	player_level = 1
	xp_to_next_level = 10
	rage = 0.0
	rage_active = false
	rage_timer = 0.0

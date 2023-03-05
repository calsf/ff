# Player health singleton
extends Node

var MAX_HP = 100
var curr_hp : int

signal health_updated()
signal player_died()

func _ready():
	reset_health()

# Add to health, avoid going over
func add_health(gain):
	var diff = (curr_hp + gain) - MAX_HP
	
	curr_hp = min(curr_hp + gain, MAX_HP)
	emit_signal("health_updated")

	if diff >= 0:
		return gain - diff
	else:
		return gain

# Subtract from health, avoid going below 0
func lose_health(loss):
	if curr_hp > 0:
		curr_hp = max(curr_hp - loss, 0)
		emit_signal("health_updated")
		
		# If hp hits 0, player has died
		if curr_hp <= 0:
			emit_signal("player_died")

# Reset player health to max
func reset_health():
	curr_hp = MAX_HP
	emit_signal("health_updated")
	


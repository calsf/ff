# Player health singleton
extends Node

const DEFAULT_MAX_HP = 100

var MAX_HP = DEFAULT_MAX_HP
var curr_hp : int

signal health_updated()
signal health_lost(i)
signal health_gain(i)
signal player_died()

func _ready():
	reset_health()

# Add to health, avoid going over
func add_health(gain):
	var diff = (curr_hp + gain) - MAX_HP
	
	curr_hp = min(curr_hp + gain, MAX_HP)
	emit_signal("health_updated")

	if diff >= 0:
		emit_signal("health_gain", gain - diff)
		return gain - diff
	else:
		emit_signal("health_gain", gain)
		return gain

# Subtract from health, avoid going below 0
func lose_health(loss):
#	if loss <= 0:
#		return
	
	if curr_hp > 0:
		curr_hp = max(curr_hp - loss, 0)
		emit_signal("health_updated")
		emit_signal("health_lost", loss)
		
		# If hp hits 0, player has died
		if curr_hp <= 0:
			emit_signal("player_died")

# Reset player health to max
func reset_health():
	curr_hp = MAX_HP
	emit_signal("health_updated")
	


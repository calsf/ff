# Player dice bank singleton
extends Node

var dice = []
var number_icon_paths = []

signal die_bank_updated(i)

func _init():
	number_icon_paths.append("res://dice/die-numbers/die-num-1.png")
	number_icon_paths.append("res://dice/die-numbers/die-num-2.png")
	number_icon_paths.append("res://dice/die-numbers/die-num-3.png")
	number_icon_paths.append("res://dice/die-numbers/die-num-4.png")
	number_icon_paths.append("res://dice/die-numbers/die-num-5.png")
	number_icon_paths.append("res://dice/die-numbers/die-num-6.png")
	number_icon_paths.append("res://dice/die-numbers/die-num-7.png")
	number_icon_paths.append("res://dice/die-numbers/die-num-8.png")
	number_icon_paths.append("res://dice/die-numbers/die-num-9.png")
	number_icon_paths.append("res://dice/die-numbers/die-num-10.png")
	number_icon_paths.append("res://dice/die-numbers/die-num-11.png")
	number_icon_paths.append("res://dice/die-numbers/die-num-12.png")
	
	var attack = FaceAttack.new(5)
	var block = FaceBlock.new(5)
	var attack_brutal = FaceAttackBrutal.new(5)
	var dodge = FaceDodge.new()
	var drain = FaceDrain.new(5)
	var heal = FaceHeal.new(5)
	var replay = FaceReplay.new()
	var scramble = FaceScramble.new()
	var unload = FaceUnload.new()
	var attack_charge = FaceChargeAttack.new(2)
	var block_charge = FaceChargeBlock.new(5)
	var reload = FaceReload.new()
	
	# Start with 6 die
	dice.append(Die.new(number_icon_paths[0], [attack, attack, attack, block, block, block]))
	dice.append(Die.new(number_icon_paths[1], [attack, attack, attack, block, block, block]))
	dice.append(Die.new(number_icon_paths[2], [attack, attack, attack, block, block, block]))
	dice.append(Die.new(number_icon_paths[3], [attack, attack, attack, block, block, block]))
	dice.append(Die.new(number_icon_paths[4], [attack, attack, attack, block, block, block]))
	dice.append(Die.new(number_icon_paths[5], [attack, attack, attack, block, block, block]))
	
	# TEMP TESTING
	dice.append(Die.new(number_icon_paths[6], [unload, drain, replay, scramble, heal, dodge]))
	dice.append(Die.new(number_icon_paths[7], [attack_charge,attack_charge,attack_charge,attack_charge,attack_charge,attack_charge]))
	dice.append(Die.new(number_icon_paths[8], [block_charge,block_charge,block_charge,block_charge,block_charge,block_charge]))
	dice.append(Die.new(number_icon_paths[9], [reload,reload,reload,reload,reload,reload]))
	
	# Empty dice slots
	#dice.append(Die.new(number_icon_paths[6]))
	#dice.append(Die.new(number_icon_paths[7]))
	#dice.append(Die.new(number_icon_paths[8]))
	#dice.append(Die.new(number_icon_paths[9]))
	dice.append(Die.new(number_icon_paths[10]))
	dice.append(Die.new(number_icon_paths[11]))

func add_die(die):
	# Add die to first empty slot found
	for i in range(dice.size()):
		if dice[i].is_empty:
			var icon = load(number_icon_paths[i])
			die.number_icon = icon
			dice[i] = die
			emit_signal("die_bank_updated", i)
			return

func replace_die(i, die):
	var icon = load(number_icon_paths[i])
	die.number_icon = icon
	dice[i] = die
	emit_signal("die_bank_updated", i)
	return

func replace_face(die_index, face_index, new_face):
	dice[die_index].faces[face_index] = new_face
	emit_signal("die_bank_updated", die_index)

# Returns number of used dice
func get_used_dice():
	var num = 0
	for i in range(dice.size()):
		if not dice[i].is_empty and dice[i].is_used:
			num += 1
	return num

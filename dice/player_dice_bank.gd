# Player dice bank singleton
extends Node

const DEFAULT_STARTING_FAVOR = 2

var starting_favor = DEFAULT_STARTING_FAVOR
var dice = []
var number_icon_paths = []

signal die_bank_updated(i)
signal starting_favor_updated()

func _init():
	reset_dice_bank()

func reset_dice_bank():
	dice = []
	number_icon_paths = []
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
	
	var attack = FaceAttack
	var block = FaceBlock
	var attack_brutal = FaceAttackBrutal
	var dodge = FaceDodge
	var drain = FaceDrain
	var heal = FaceHeal
	var replay = FaceReplay
	var scramble = FaceScramble
	var unload = FaceUnload
	var attack_charge = FaceChargeAttack
	var block_charge = FaceChargeBlock
	var reload = FaceReload
	var attack_block = FaceAttackBlock
	var multi_attack = FaceMultiAttack
	var block_reflect = FaceBlockReflect
	var sacrifice = FaceSacrifice
	var rage = FaceRage
	var attack_perfect = FaceAttackPerfect
	var cheap_favor = FaceCheapFavor
	var favorable_attack = FaceFavorableAttack
	var guardian = FaceGuardian
	var strengthen = FaceStrengthen
	var fortify = FaceFortify
	
	# Start with 6 die
	dice.append(Die.new(number_icon_paths[0], [attack.new(), attack.new(), attack.new(), block.new(), block.new(), block.new()]))
	dice.append(Die.new(number_icon_paths[1], [attack.new(), attack.new(), attack.new(), block.new(), block.new(), block.new()]))
	dice.append(Die.new(number_icon_paths[2], [attack.new(), attack.new(), attack.new(), block.new(), block.new(), block.new()]))
	dice.append(Die.new(number_icon_paths[3], [attack.new(), attack.new(), attack.new(), block.new(), block.new(), block.new()]))
	dice.append(Die.new(number_icon_paths[4], [attack.new(), attack.new(), attack.new(), block.new(), block.new(), block.new()]))
	dice.append(Die.new(number_icon_paths[5], [attack.new(), attack.new(), attack.new(), block.new(), block.new(), block.new()]))
	
	# TEMP TESTING
	dice.append(Die.new(number_icon_paths[6], [unload.new(), drain.new(), replay.new(), scramble.new(), heal.new(), dodge.new()]))
	dice.append(Die.new(number_icon_paths[7], [fortify.new(), fortify.new(), fortify.new(), fortify.new(), strengthen.new(), strengthen.new()]))
	dice.append(Die.new(number_icon_paths[8], [block_reflect.new(), block_reflect.new(), block_reflect.new(), block_charge.new(), block_charge.new(), block_charge.new()]))
	dice.append(Die.new(number_icon_paths[9], [attack_perfect.new(), attack_perfect.new(),attack_perfect.new(),dodge.new(),dodge.new(),dodge.new()]))
	
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
			return true
	
	# Failed to add, no slots
	return false

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

# Returns number of non empty dice
func get_owned_dice():
	var num = 0
	for i in range(dice.size()):
		if not dice[i].is_empty:
			num += 1
	return num

# Returns a list of indices where die slot is not empty
func get_owned_dice_slots():
	var slots = []
	for i in range(dice.size()):
		if not dice[i].is_empty:
			slots.append(i)
	return slots

func upgrade_dice_faces():
	for i in range(dice.size()):
		var die = dice[i]
		for face in die.faces:
			if face.num_value > 0:
				face.num_value += 1
		emit_signal("die_bank_updated", i)

# Increase starting favor
func increase_starting_favor():
	starting_favor += 1
	emit_signal("starting_favor_updated")
	

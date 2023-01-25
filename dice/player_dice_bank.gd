# Player dice bank singleton
extends Node

var dice = []

func _init():
	var attack = FaceAttack.new(5)
	var block = FaceBlock.new(5)
	
	# Start with 6 die
	dice.append(Die.new("res://dice/die-numbers/die-num-1.png", [attack, attack, attack, block, block, block]))
	dice.append(Die.new("res://dice/die-numbers/die-num-2.png", [attack, attack, attack, block, block, block]))
	dice.append(Die.new("res://dice/die-numbers/die-num-3.png", [attack, attack, attack, block, block, block]))
	dice.append(Die.new("res://dice/die-numbers/die-num-4.png", [attack, attack, attack, block, block, block]))
	dice.append(Die.new("res://dice/die-numbers/die-num-5.png", [attack, attack, attack, block, block, block]))
	dice.append(Die.new("res://dice/die-numbers/die-num-6.png", [attack, attack, attack, block, block, block]))
	
	# Empty dice slots
	dice.append(Die.new("res://dice/die-numbers/die-num-7.png"))
	dice.append(Die.new("res://dice/die-numbers/die-num-8.png"))
	dice.append(Die.new("res://dice/die-numbers/die-num-9.png"))
	dice.append(Die.new("res://dice/die-numbers/die-num-10.png"))
	dice.append(Die.new("res://dice/die-numbers/die-num-11.png"))
	dice.append(Die.new("res://dice/die-numbers/die-num-12.png"))

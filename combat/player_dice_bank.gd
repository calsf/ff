# Player dice bank singleton
extends Node

var dice = []

func _init():
	var attack = FaceAttack.new(5)
	var block = FaceBlock.new(5)
	
	# Start with 6 die
	dice.append(Die.new([attack, attack, attack, block, block, block]))
	dice.append(Die.new([attack, attack, attack, block, block, block]))
	dice.append(Die.new([attack, attack, attack, block, block, block]))
	dice.append(Die.new([attack, attack, attack, block, block, block]))
	dice.append(Die.new([attack, attack, attack, block, block, block]))
	dice.append(Die.new([attack, attack, attack, block, block, block]))
	
	# Empty dice slots
	dice.append(Die.new())
	dice.append(Die.new())
	dice.append(Die.new())
	dice.append(Die.new())
	dice.append(Die.new())
	dice.append(Die.new())

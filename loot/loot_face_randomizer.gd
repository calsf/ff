# Singleton for face loot randomization
extends Node

var common_face_pool = [
	FaceAttack.new(5),
	FaceBlock.new(5),
	FaceAttackBrutal.new(5),
	FaceMultiAttack.new(3)
]

var uncommon_face_pool = [
	FaceDrain.new(5),
	FaceHeal.new(10),
	FaceDodge.new(),
	FaceScramble.new(),
	FaceBlockReflect.new(5),
	FaceAttackBlock.new(5)
]

var rare_face_pool = [
	FaceChargeAttack.new(4),
	FaceChargeBlock.new(5),
	FaceReplay.new(),
	FaceUnload.new(),
	FaceReload.new(),
	FaceAttackPerfect.new(5),
	FaceCheapFavor.new(3),
	FaceStrengthen.new(3),
	FaceFortify.new(3)
]

var legendary_face_pool = [
	FaceRage.new(),
	FaceSacrifice.new(),
	FaceGuardian.new(),
	FaceFavorableAttack.new()
]

var face_pools = [
	common_face_pool,
	uncommon_face_pool,
	rare_face_pool,
	legendary_face_pool
]

func get_random_face():
	var face_pool_num = -1
	
	randomize()
	var num = randi() % 100
	
	if num > 0 and num < 40:	# Common
		face_pool_num = 0
	elif num > 40 and num < 75:	# Uncommon
		face_pool_num = 1
	elif num > 75 and num < 95: # Rare
		face_pool_num = 2
	elif num > 95 and num < 100: # Legendary
		face_pool_num = 3
	
	var face_pool = face_pools[face_pool_num]
	return face_pool[randi() % face_pool.size()]

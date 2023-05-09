# Singleton for face loot randomization
extends Node

var common_face_pool = [
	FaceAttack,
	FaceBlock,
	FaceAttackBrutal,
	FaceMultiAttack
]

var uncommon_face_pool = [
	FaceDrain,
	FaceHeal,
	FaceDodge,
	FaceScramble,
	FaceBlockReflect,
	FaceAttackBlock
]

var rare_face_pool = [
	FaceChargeAttack,
	FaceChargeBlock,
	FaceReplay,
	FaceUnload,
	FaceReload,
	FaceAttackPerfect,
	FaceCheapFavor,
	FaceStrengthen,
	FaceFortify
]

var legendary_face_pool = [
	FaceRage,
	FaceSacrifice,
	FaceGuardian,
	FaceFavorableAttack
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
	return face_pool[randi() % face_pool.size()].new()

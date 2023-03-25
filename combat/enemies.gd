extends Node

func _init():
	var enemies = LevelDepth.get_enemies()
	
	# Instance and initialize enemies
	for enemy in enemies:
		var enemy_instance = enemy.enemy.instance()
		enemy_instance.init_enemy(enemy.health_scaling)
		
		self.add_child(enemy_instance)

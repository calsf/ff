extends Node

func _init():
	var enemies = LevelDepth.get_enemies_boss()
	
	# Instance and initialize enemies
	for enemy in enemies:
		var enemy_instance = enemy.enemy.instance()
		enemy_instance.init_enemy(enemy.get_health_scaling(), enemy.get_offensive_scaling(), enemy.get_defensive_scaling())
		
		self.add_child(enemy_instance)

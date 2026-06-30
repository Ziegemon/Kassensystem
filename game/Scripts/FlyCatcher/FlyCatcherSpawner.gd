extends Node

@export var flyScene: PackedScene
@export var flyContainer: Node

var spawnTimer: float = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if FlyCatcherGlobal.gameState == FlyCatcherGlobal.GameState.Running:
		spawnTimer = spawnTimer - delta
		if spawnTimer <= 0:
			var rand: RandomNumberGenerator = RandomNumberGenerator.new()
			var config: FlyCatcherConfig = FlyCatcherGlobal.getConfigByDifficulty()
			spawnTimer = rand.randf_range(config.minSpawnInterval, config.maxSpawnInterval)
			if FlyCatcherGlobal.difficulty != FlyCatcherGlobal.Difficulty.ASIAN:
				var newFly = flyScene.instantiate()
				var spawnRadius: float = rand.randf_range(config.minSpawnRadius, config.maxSpawnRadius)
				newFly.global_position = get_viewport().size * (0.5 + spawnRadius * (rand.randi_range(0, 1) * 2 - 1))
				flyContainer.add_child(newFly)
				FlyCatcherGlobal.flyCount += 1
			elif FlyCatcherGlobal.flyCount < 1:
				var newFly = flyScene.instantiate()
				flyContainer.add_child(newFly)
				FlyCatcherGlobal.flyCount += 1
				

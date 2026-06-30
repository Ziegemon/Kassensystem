class_name FlyCatcherConfig

var minVelocity: float
var maxVelocity: float

var minSpawnInterval: float
var maxSpawnInterval: float

var minSpawnRadius: float
var maxSpawnRadius: float

var time: float
var bounce: bool

func _init(minVelocity: float, maxVelocity: float,
			minSpawnInterval: float, maxSpawnInterval: float,
			minSpawnRadius: float, maxSpawnRadius: float,
			time: float, bounce: bool):
	self.minVelocity = minVelocity
	self.maxVelocity = maxVelocity
	self.minSpawnInterval = minSpawnInterval
	self.maxSpawnInterval = maxSpawnInterval
	self.minSpawnRadius = minSpawnRadius
	self.maxSpawnRadius = maxSpawnRadius
	self.time = time
	self.bounce = bounce

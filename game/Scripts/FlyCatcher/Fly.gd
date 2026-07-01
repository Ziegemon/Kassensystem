extends Node

@export var character: Node2D
@export var killTrigger: Button
@export var animation: AnimatedSprite2D

var config: FlyCatcherConfig
var velocity: float
var direction: float
var alive: bool = true

var pathFunctionX: float = floor(FlyCatcherGlobal.asianLeftBoundaryX - 1 * sign(FlyCatcherGlobal.asianLeftBoundaryX))
var asianScore: float = 0

#OnSpawn
func _ready() -> void:
	config = FlyCatcherGlobal.getConfigByDifficulty()
	velocity = RandomNumberGenerator.new().randf_range(config.minVelocity, config.maxVelocity)
	direction = RandomNumberGenerator.new().randf_range(-PI, PI)
	killTrigger.pressed.connect(onClick)
	killTrigger.focus_mode = Control.FOCUS_NONE
	if RandomNumberGenerator.new().randf() < 0.5:
		animation.play("Flying2")

func _process(delta: float) -> void:
	if FlyCatcherGlobal.gameState == FlyCatcherGlobal.GameState.Start:
		character.queue_free()
		return
	if FlyCatcherGlobal.gameState == FlyCatcherGlobal.GameState.TimeOut:
		velocity *= pow(0.1, delta)
		animation.speed_scale *= pow(0.1, delta)
	
	if alive:
		if FlyCatcherGlobal.difficulty != FlyCatcherGlobal.Difficulty.ASIAN:
			character.position.x = character.position.x + velocity * cos(direction) * delta
			character.position.y = character.position.y + velocity * sin(direction) * delta
			
			if character.position.x < 0 or character.position.x > get_viewport().size.x:
				if config.bounce:
					direction = PI - direction
				else:
					character.queue_free()
			elif character.position.y < 0 or character.position.y > get_viewport().size.y:
				if config.bounce:
					direction = -direction
				else:
					character.queue_free()
		else:
			character.position = FlyCatcherGlobal.coordinateToScreenSpace(
				Vector2(pathFunctionX, FlyCatcherGlobal.path.pathFunction.call(pathFunctionX)))
			if FlyCatcherGlobal.asianInputComfirmed:
				pathFunctionX += delta * (FlyCatcherGlobal.asianRightBoundaryX - FlyCatcherGlobal.asianLeftBoundaryX) / FlyCatcherGlobal.crossTime
				var coordinateDistance: float = Vector2(FlyCatcherGlobal.screenToCoordinateSpace(character.position) - 
					FlyCatcherGlobal.asianNetPositionInCoordinateSpace).length()
				asianScore = max(
					asianScore, max(0, 2 - coordinateDistance) * 50.0
					/ (max(0.1, FlyCatcherGlobal.asianNetRadiusInCoordinateSpace) * 10.0)
				)
				if character.position.x > get_viewport().size.x:
					alive = false
					FlyCatcherGlobal.score = asianScore
					FlyCatcherGlobal.asianRoundEndedType = FlyCatcherGlobal.AsianRoundEndedType.Missed
					FlyCatcherGlobal.asianRoundEnded = true
					character.queue_free()
	else:
		var modulate: Color = animation.modulate
		modulate.a *= pow(0.1, delta)
		animation.modulate = modulate
		if modulate.a <= 0.05:
			queue_free()

func onClick() -> void:
	if FlyCatcherGlobal.difficulty != FlyCatcherGlobal.Difficulty.ASIAN:
		if FlyCatcherGlobal.gameState == FlyCatcherGlobal.GameState.Running and alive:
			animation.play("Squish" + str(RandomNumberGenerator.new().randi_range(1, 3)))
			velocity = 0
			FlyCatcherGlobal.remainingTime += 0.5
			FlyCatcherGlobal.score += 1
			FlyCatcherGlobal.flyCount -= 1
			alive = false

func onEnter() -> void:
	if FlyCatcherGlobal.difficulty == FlyCatcherGlobal.Difficulty.ASIAN:
		#Discard coordinate distance, set distance score to 100, add time bonus
		FlyCatcherGlobal.score = 100 / (max(0.1, FlyCatcherGlobal.asianNetRadiusInCoordinateSpace) * 10.0) + FlyCatcherGlobal.remainingTime
		FlyCatcherGlobal.asianRoundEndedType = FlyCatcherGlobal.AsianRoundEndedType.Caught
		alive = false
		FlyCatcherGlobal.asianRoundEnded = true

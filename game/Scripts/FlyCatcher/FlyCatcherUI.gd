extends Node

@export var coordinateSystem: TextureRect
@export var gameLabel: Label
@export var timeOutScreen: Node
@export var timeOutLabel: Label
@export var restartButton: TextureButton
@export var startScreen: Node
@export var startLabel: Label
@export var startButton: TextureButton
@export var modeButton: OptionButton
@export var quitButton: TextureButton
@export var quitScreenPath: String

func _ready() -> void:
	restartButton.pressed.connect(onRestartButtonPressed)
	startButton.pressed.connect(onStartButtonPressed)
	quitButton.pressed.connect(onQuitButtonPressed)
	FlyCatcherGlobal.onGameStateChanged.connect(onGameStateChanged)
	FlyCatcherGlobal.onDifficultyChanged.connect(onDifficultyChanged)
	FlyCatcherGlobal.difficulty = FlyCatcherGlobal.difficulty
	FlyCatcherGlobal.gameState = FlyCatcherGlobal.gameState

func onGameStateChanged() -> void:
	if FlyCatcherGlobal.gameState == FlyCatcherGlobal.GameState.Start:
		coordinateSystem.hide()
		gameLabel.hide()
		timeOutScreen.hide()
		timeOutLabel.hide()
		restartButton.hide()
		startScreen.show()
		startLabel.show()
		startButton.show()
		modeButton.show()
		quitButton.show()
	elif FlyCatcherGlobal.gameState == FlyCatcherGlobal.GameState.Running:
		if FlyCatcherGlobal.difficulty == FlyCatcherGlobal.Difficulty.ASIAN: coordinateSystem.show()
		else: coordinateSystem.hide()
		gameLabel.show()
		timeOutScreen.hide()
		timeOutLabel.hide()
		restartButton.hide()
		startScreen.hide()
		startLabel.hide()
		startButton.hide()
		modeButton.hide()
		quitButton.hide()
	elif FlyCatcherGlobal.gameState == FlyCatcherGlobal.GameState.TimeOut:
		coordinateSystem.hide()
		gameLabel.hide()
		timeOutScreen.show()
		timeOutLabel.show()
		restartButton.show()
		startScreen.hide()
		startLabel.hide()
		startButton.hide()
		modeButton.hide()
		quitButton.hide()
		if FlyCatcherGlobal.difficulty != FlyCatcherGlobal.Difficulty.ASIAN:
			timeOutLabel.text = "Round ended!"
		else:
			match FlyCatcherGlobal.asianRoundEndedType:
				FlyCatcherGlobal.AsianRoundEndedType.Caught: timeOutLabel.text = "Fly caught!"
				FlyCatcherGlobal.AsianRoundEndedType.TimeOut: timeOutLabel.text = "Time out!"
				FlyCatcherGlobal.AsianRoundEndedType.Missed: timeOutLabel.text = "Fly missed!"
		timeOutLabel.text += "\nScore: %s" % FlyCatcherGlobal.score
		timeOutLabel.text += "\nPersonal highscore: %s" % FlyCatcherGlobal.userHighscores[Exchange.current_selected_user_id][FlyCatcherGlobal.difficulty]

func onDifficultyChanged() -> void:
	pass

func _process(delta: float) -> void:
	gameLabel.text = "Remaining time: %s" % str(FlyCatcherGlobal.remainingTime).pad_decimals(1)
	if FlyCatcherGlobal.difficulty == FlyCatcherGlobal.Difficulty.ASIAN:
		gameLabel.text += "\n%s" % FlyCatcherGlobal.path.description
	else:
		gameLabel.text += "\nScore: %s" % int(FlyCatcherGlobal.score)

func onRestartButtonPressed() -> void:
	FlyCatcherGlobal.gameState = FlyCatcherGlobal.GameState.Start

func onStartButtonPressed() -> void:
	FlyCatcherGlobal.difficulty = FlyCatcherGlobal.Difficulty.values()[modeButton.get_selected_id()]
	FlyCatcherGlobal.gameState = FlyCatcherGlobal.GameState.Running

func onQuitButtonPressed() -> void:
	get_tree().change_scene_to_file(quitScreenPath)

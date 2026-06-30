extends Node

const E: float = 2.718281828459045

var configDict: Dictionary
func getConfigByDifficulty(difficulty: Difficulty = self.difficulty) -> FlyCatcherConfig:
	return configDict[difficulty]

enum Difficulty {EASY, NORMAL, RAGE, ASIAN}
var _difficulty: Difficulty
var difficulty: Difficulty :
	get: return _difficulty
	set(value): setDifficulty(value)

signal onDifficultyChanged
func setDifficulty(difficulty: Difficulty) -> void:
	if gameState == GameState.Running:
		gameState = GameState.TimeOut
	if difficulty == Difficulty.ASIAN:
		path = pathList.pick_random()
	_difficulty = difficulty
	onDifficultyChanged.emit()

enum GameState {Start, Running, TimeOut}
var _gameState: GameState
var gameState: GameState :
	get: return _gameState
	set(value): setGameState(value)

signal onGameStateChanged
func setGameState(gameState: GameState) -> void:
	if gameState == FlyCatcherGlobal.GameState.Start:
		score = 0
		remainingTime = getConfigByDifficulty().time
		print(remainingTime)
		flyCount = 0
	_gameState = gameState
	onGameStateChanged.emit()

var highscore: Dictionary = {
	Difficulty.EASY: 0.0,
	Difficulty.NORMAL: 0.0,
	Difficulty.RAGE: 0.0,
	Difficulty.ASIAN: 0.0
}

var score: float = 0
var remainingTime: float = 1
var flyCount: int = 0

#Game data for ASIAN difficulty
var asianNetPositionInCoordinateSpace: Vector2
var asianNetRadiusInCoordinateSpace: float
var asianInputComfirmed: bool = false
var asianRoundEnded: bool = false

enum AsianRoundEndedType {Caught, TimeOut, Missed}
var asianRoundEndedType: AsianRoundEndedType

var path: Path
var pathList: Array[Path] = [
	Path.new(func (x: float) -> float: return x / 2.0, "f(x) = x/2"),
	Path.new(func (x: float) -> float: return 0.05 * x * x, "f(x) = 0.05 * x^2"),
	Path.new(func (x: float) -> float: return -2.0 + x * x / 20.0, "f(x) = -2 + (x^2)/20"),
	Path.new(func (x: float) -> float: return 2.0 + x * x * x / 500.0, "f(x) = 2 + (x^3)/500"),
	Path.new(func (x: float) -> float: return -1.0 + x * x * x / 200.0, "f(x) = -1 + (x^3)/200"),
	Path.new(func (x: float) -> float: return 2.0 - x * x / 50.0 + x * x * x * x / 5000.0, "f(x) = 2 - (x^2)/50 + (x^4)/5000"),
	Path.new(func (x: float) -> float: return 50.0 / (x * x + 10.0), "f(x) = 50 / (x^2 + 10)"),
	Path.new(func (x: float) -> float: return sqrt(x + 11.0) + 2, "f(x) = (x + 11)^0.5 + 2"),
	Path.new(func (x: float) -> float: return 3.0 * log(x + 11.0), "f(x) = 3 * ln(x + 11)"),
	Path.new(func (x: float) -> float: return 5.0 * pow(E, -0.1 * (x + 10.0)), "f(x) = 5 * e^(-0.1 * (x + 10))"),
	Path.new(func (x: float) -> float: return 5.0 * sin(x), "f(x) = 5 * sin(x)"),
	Path.new(func (x: float) -> float: return 4.0 * cos(x / 2.0), "f(x) = 4 * cos(x/2)"),
	Path.new(func (x: float) -> float: return 4.0 * cos(x) + x / 10.0, "f(x) = 4 * cos(x) + x/10"),
	Path.new(func (x: float) -> float: return x * x / 25 - 4 * cos(x/3), "f(x) = (x^2)/25 - 4 * cos(x/3)"),
	Path.new(func (x: float) -> float: return 5 * pow(E, -0.05 * (x + 10)) - sin(x / 2), "f(x) = 5 * e^(-0.05 * (x + 10)) - sin(x/2)"),
	Path.new(func (x: float) -> float: return 3 * log(x + 11) + 2 * sin(x), "f(x) = 3 * ln(x + 11) + 2 * sin(x)")
]

const asianLeftBoundaryX: float = -576.0 / 56.0
const asianRightBoundaryX: float = 576.0 / 56.0
const asianTopBoundaryY: float = 324.0 / 56.0
const asianBottomBoundaryY: float = -324.0 / 56.0
const crossTime: float = 10

func _ready() -> void:
	#minV, maxV, minSpawnI, maxSpawnI, minSpawnR, maxSpawnR, time, bounce
	configDict = {
		Difficulty.EASY: FlyCatcherConfig.new(150, 250, 0.8, 1.2, 0.1, 0.2, 20, true),
		Difficulty.NORMAL: FlyCatcherConfig.new(250, 350 , 0.6, 1, 0.15, 0.25, 20, false),
		Difficulty.RAGE: FlyCatcherConfig.new(450, 550, 0.4, 0.8, 0.15, 0.25, 20, false),
		Difficulty.ASIAN: FlyCatcherConfig.new(350, 350, 1, 1, 0, 0, 30, false),
	}
	difficulty = Difficulty.EASY
	gameState = GameState.Start

func _process(delta: float) -> void:
	if gameState == GameState.Running:
		remainingTime = max(remainingTime - delta, 0)
		if difficulty != Difficulty.ASIAN:
			if remainingTime <= 0:
				if score > highscore[difficulty]:
					highscore[difficulty] = score
				gameState = GameState.TimeOut
		else:
			if (remainingTime <= 0 and !asianInputComfirmed) or asianRoundEnded:
				if remainingTime <= 0 and !asianInputComfirmed:
					asianRoundEndedType = AsianRoundEndedType.TimeOut
				asianInputComfirmed = false
				asianRoundEnded = false
				if score > highscore[difficulty]:
					highscore[difficulty] = score
				gameState = GameState.TimeOut

func coordinateToScreenSpace(v: Vector2) -> Vector2:
	return Vector2((v.x - FlyCatcherGlobal.asianLeftBoundaryX) / (FlyCatcherGlobal.asianRightBoundaryX - FlyCatcherGlobal.asianLeftBoundaryX) * get_viewport().size.x,
		(1.0 - (v.y - FlyCatcherGlobal.asianBottomBoundaryY) / (FlyCatcherGlobal.asianTopBoundaryY - FlyCatcherGlobal.asianBottomBoundaryY)) * get_viewport().size.y)

func screenToCoordinateSpace(v: Vector2) -> Vector2:
	return Vector2(v.x / get_viewport().size.x * (FlyCatcherGlobal.asianRightBoundaryX - FlyCatcherGlobal.asianLeftBoundaryX) + FlyCatcherGlobal.asianLeftBoundaryX,
		(1.0 - v.y / get_viewport().size.y) * (FlyCatcherGlobal.asianTopBoundaryY - FlyCatcherGlobal.asianBottomBoundaryY) + FlyCatcherGlobal.asianBottomBoundaryY) 

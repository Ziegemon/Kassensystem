extends Sprite2D

@export var swatterSprite: Sprite2D
@export var swatterTexture: Texture
@export var swatterArea: Area2D
@export var cobwebTexture: Texture
@export var squashSprite: Sprite2D

var swatterOriginalScale: Vector2

var mouseButtonHold: bool
var canceledWhileOnHold: bool
var mouseButtonPressPosition: Vector2

func _ready() -> void:
	swatterOriginalScale = swatterSprite.scale
	swatterArea.body_entered.connect(onBodyEntered)
	squashSprite.hide()

func _process(delta: float) -> void:
	if FlyCatcherGlobal.difficulty == FlyCatcherGlobal.Difficulty.ASIAN and FlyCatcherGlobal.gameState == FlyCatcherGlobal.GameState.Running:
		swatterSprite.texture = cobwebTexture
		#Set sprite position according to coordinate space, no further behavior
		if FlyCatcherGlobal.asianInputComfirmed:
			swatterSprite.position = FlyCatcherGlobal.coordinateToScreenSpace(FlyCatcherGlobal.asianNetPositionInCoordinateSpace)
			return
		#Update net radius, no further behavior
		if !FlyCatcherGlobal.asianInputComfirmed and mouseButtonHold:
			FlyCatcherGlobal.asianNetRadiusInCoordinateSpace = Vector2(
				FlyCatcherGlobal.asianNetPositionInCoordinateSpace
				- FlyCatcherGlobal.screenToCoordinateSpace(getValidMousePosition())
			).length()
			swatterSprite.scale = Vector2(1, 1) * (mouseButtonPressPosition - getValidMousePosition()).length() / swatterSprite.texture.get_size()
			return
	else: swatterSprite.texture = swatterTexture
	swatterSprite.position = getValidMousePosition()
	swatterSprite.scale = swatterOriginalScale

func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed: onMouseButtonPress()
			elif !canceledWhileOnHold: onMouseButtonRelease()
			else: canceledWhileOnHold = false
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed: onMouseButtonCancel()
func _gui_input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed: onMouseButtonPress()
			elif !canceledWhileOnHold: onMouseButtonRelease()
			else: canceledWhileOnHold = false
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed: onMouseButtonCancel()

func onMouseButtonPress() -> void:
	mouseButtonHold = true
	mouseButtonPressPosition = getValidMousePosition()
	if FlyCatcherGlobal.difficulty == FlyCatcherGlobal.Difficulty.ASIAN and FlyCatcherGlobal.gameState == FlyCatcherGlobal.GameState.Running:
		if !FlyCatcherGlobal.asianInputComfirmed:
			FlyCatcherGlobal.asianNetPositionInCoordinateSpace = FlyCatcherGlobal.screenToCoordinateSpace(mouseButtonPressPosition)
	
	if FlyCatcherGlobal.difficulty != FlyCatcherGlobal.Difficulty.ASIAN:
		squashSprite.show()
		await get_tree().create_timer(0.1).timeout
		squashSprite.hide()

func onMouseButtonRelease() -> void:
	mouseButtonHold = false
	if FlyCatcherGlobal.difficulty == FlyCatcherGlobal.Difficulty.ASIAN and FlyCatcherGlobal.gameState == FlyCatcherGlobal.GameState.Running:
		if !FlyCatcherGlobal.asianInputComfirmed:
			FlyCatcherGlobal.asianInputComfirmed = true
func onMouseButtonCancel() -> void:
	if mouseButtonHold: canceledWhileOnHold = true
	mouseButtonHold = false

func getValidMousePosition() -> Vector2:
	if FlyCatcherGlobal.difficulty == FlyCatcherGlobal.Difficulty.ASIAN and FlyCatcherGlobal.gameState == FlyCatcherGlobal.GameState.Running:
		return Vector2(max(get_global_mouse_position().x, get_viewport().size.x / 2.0), get_global_mouse_position().y)
	return get_global_mouse_position()

func onBodyEntered(body: Node2D) -> void:
	body.onEnter()

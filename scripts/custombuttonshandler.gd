extends Node

var buttonrects : Dictionary #[Rect2]
var global_click : bool = false
var currentscenesize : Vector2

@onready var original_reso = Vector2(	ProjectSettings.get("display/window/size/viewport_width"),
										ProjectSettings.get("display/window/size/viewport_height"))

func reset_dict():
	buttonrects.clear()

func append_dict(ref : ReferenceRect):
	buttonrects[ref] = ref.get_global_rect()

func calculate_scaled_position(pos : Vector2) -> Vector2:
	return Vector2(	pos.x * original_reso.x / currentscenesize.x,
					pos.y * original_reso.y / currentscenesize.y	)
					# ☝️TODO, NEED FIX!! intinya ga semua screen scalenya sesuai dengan aspek ratio awalnya
func check_click(event: InputEvent):
	#print("doing check")
	if !buttonrects.is_empty():
		#print("not empty")
		for btn_rect in buttonrects:
			if buttonrects[btn_rect].has_point(calculate_scaled_position(event.get_global_position())):
				btn_rect.pressed.emit()

func check_release(event: InputEvent):
	if !buttonrects.is_empty():
		for btn_rect in buttonrects:
			if btn_rect.is_pressed:
				btn_rect.is_pressed = false
				btn_rect.released.emit()

func _input(event: InputEvent):
	global_click = false
	if event is InputEventMouseButton:
		if event.get_button_mask() == 1:
			global_click = true
			CustomButtons.check_click(event)
		elif event.get_button_mask() == 0:
			CustomButtons.check_release(event)

func update_screensize(size : Vector2):
	currentscenesize = size

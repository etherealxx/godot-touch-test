extends Node

var buttonrects : Dictionary #[Rect2]

#func append_array(btn : Rect2):
	#buttonrects.append(btn)
#

func reset_array():
	buttonrects.clear()

func append_dict(ref : ReferenceRect):
	buttonrects[ref] = ref.get_global_rect()
	
func check_click(event):
	#print("doing check")
	if !buttonrects.is_empty():
		#print("not empty")
		for btn_rect in buttonrects:
			if buttonrects[btn_rect].has_point(event.get_global_position()):
				btn_rect.pressed.emit()

func check_release(event):
	if !buttonrects.is_empty():
		for btn_rect in buttonrects:
			if btn_rect.is_pressed:
				btn_rect.is_pressed = false
				btn_rect.released.emit()

extends Node

@onready var label = $Control/Label
@onready var debuginfolabel = $Control/Label2
@onready var touchbutton = $Control/TouchScreenButton
@onready var touchlabel = $Control/Label3
@onready var timer = $Fivesectimer
@onready var custompresslabel = $Control/Label4
@onready var earlyprintlabel = $Control/Label5
@onready var customtouch = $Control/TouchScreenButton/RefRectCustomTouchBtn

var windowsize = DisplayServer.window_get_size()
var input_count : int = 0
var currenttext : Array[String]
#var click_true_release_false = false

func _ready():
	#CustomButtons.reset_array()
	touchbutton.pressed.connect(_on_touchbutton_pressed)
	touchbutton.released.connect(_on_touchbutton_released)
	timer.timeout.connect(_on_timer_timeout)
	var customtouchrect = customtouch.get_global_rect()
	CustomButtons.update_screensize(windowsize)
	earlyprintlabel.text = "Windowsize: %v\nRectpos: %v\nRectsize: %v" % [windowsize, customtouchrect.position, customtouchrect.size]
	
func _process(float):
	if CustomButtons.global_click:
		custompresslabel.text = "custom click"
	else:
		custompresslabel.text = ""
		
func _on_timer_timeout():
	touchlabel.text = ""

func reset_timer():
	timer.stop()
	timer.wait_time = 3
	timer.start()
	
func _on_touchbutton_pressed():
	touchlabel.text = "Button pressed!"
	reset_timer()
	
func _on_touchbutton_released():
	touchlabel.text = "Button released!"
	reset_timer()
	
func doing_input(texttoprint):
	if currenttext.size() > 25:
		while currenttext.size() > 25:
			currenttext.pop_front()
	currenttext.append(texttoprint)
	var printthis : String
	for line in currenttext:
		printthis = printthis + line + "\n"
	label.text = printthis
	input_count += 1

func updatedebuginfo(inputevent_name : String, event):
	var texttoprint : String
	if inputevent_name == "InputEventMouse":
		var txt_buttonmask = event.get_button_mask()
		var txt_global_position = event.get_global_position()
		texttoprint = "InputEvent: %s\nbutton_mask:%d\nglobal_position:%v" % [inputevent_name, txt_buttonmask, txt_global_position]
		
		if event is InputEventMouseButton:
			var variant = "InputEventMouseButton"
			var txt_button_index = event.get_button_index()
			var txt_cancelled = "true" if event.is_canceled() else "false"
			var txt_double_click = "true" if event.is_double_click() else "false"
			var txt_pressed = "true" if event.is_pressed() else "false"
			var txt_factor = event.get_factor()
			texttoprint += "\nVariant: %s\nbutton_index: %d\ncancelled: %s\ndouble_click: %s\npressed: %s\nfactor: %f" % [variant, txt_button_index, txt_cancelled, txt_double_click, txt_pressed, txt_factor]
		elif event is InputEventMouseMotion:
			var variant = "InputEventMouseMotion"
			var txt_relative = event.get_relative()
			var txt_velocity = event.get_velocity()
			texttoprint += "\nVariant: %s\nrelative: %v\nvelocity: %v" % [variant, txt_relative, txt_velocity]
			
		debuginfolabel.text = texttoprint
	return true
	
func check_input(funcname : String, event):
	var input_txt : String
	var debuginfo_hastext : bool = false
	if event is InputEvent:
		input_txt = "InputEvent from %s (%d)" % [funcname, input_count]
		doing_input(input_txt)
	if event is InputEventAction:
		input_txt = "InputEventAction from %s (%d)" % [funcname, input_count]
		doing_input(input_txt)
	if event is InputEventFromWindow:
		input_txt = "InputEventFromWindow from %s (%d)" % [funcname, input_count]
		doing_input(input_txt)
		if event is InputEventScreenTouch:
			input_txt = "InputEventScreenTouch from %s (%d)" % [funcname, input_count]
			doing_input(input_txt)
		if event is InputEventScreenDrag:
			input_txt = "InputEventScreenDrag from %s (%d)" % [funcname, input_count]
			doing_input(input_txt)
		if event is InputEventWithModifiers:
			input_txt = "InputEventWithModifiers from %s (%d)" % [funcname, input_count]
			doing_input(input_txt)
			if event is InputEventGesture:
				input_txt = "InputEventGesture from %s (%d)" % [funcname, input_count]
				doing_input(input_txt)
			if event is InputEventKey:
				input_txt = "InputEventKey from %s (%d)" % [funcname, input_count]
				doing_input(input_txt)
			if event is InputEventMouse:
				input_txt = "InputEventMouse from %s (%d)" % [funcname, input_count]
				debuginfo_hastext = updatedebuginfo("InputEventMouse", event)
				doing_input(input_txt)
				
	if not debuginfo_hastext:
		debuginfolabel.text = ""
				
func _input(event):
	#click_true_release_false = false
	#if event is InputEventMouseButton:
		#if event.get_button_mask() == 1:
			#click_true_release_false = true
			#CustomButtons.check_click(event)
		#elif event.get_button_mask() == 0:
			#CustomButtons.check_release(event)
			
	check_input("_input()", event)
				
func _unhandled_input(event):
	check_input("_unhandled_input()", event)
			
func _unhandled_key_input(event):
	check_input("_unhandled_key_input()", event)

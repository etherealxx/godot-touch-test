extends ReferenceRect

signal pressed
signal released

@onready var touch = $".."

var is_pressed : bool = false

func _ready():
	pressed.connect(func() : touch.pressed.emit())
	pressed.connect(_on_pressed)
	released.connect(func() : touch.released.emit())
	#touch.released.connect(func() : released.emit())
	CustomButtons.append_dict(self)

func _on_pressed():
	is_pressed = true

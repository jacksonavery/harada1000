extends ColorRect

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.connect("timeout", _flash)

func _flash():
	visible = !visible

func force_flash():
	visible = true
	timer.start()

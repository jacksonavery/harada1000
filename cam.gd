extends Camera2D

@onready var indicator: ColorRect = $"../Tiles/Indicator"

func _process(delta: float) -> void:
	position = hlp.exdc(position, indicator.position, 10, delta)

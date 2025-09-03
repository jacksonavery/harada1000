extends Node

@onready var tiles: Node2D = $Node2D/Tiles
@onready var scorer: Node = $Scorer

func _process(delta: float) -> void:
	if tiles.is_complete() and scorer.is_met():
		print("yay")

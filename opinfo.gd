extends Control

@onready var label: Label = $OpInfo/OpInfo/Label
@onready var label_2: Label = $OpInfo/OpInfo/Label2
@onready var color_rect: ColorRect = $OpInfo/ColorRect

func set_op(o: Operator):
	color_rect.color = o.col
	#var stack = o.stack.duplicate()
	#stack.reverse()
	label.text = ""
	label_2.text = ""
	for i in o.stack:
		var c = char(i)
		if i < 32:
			c = " "
		label.text += "'%s' " % c
		label_2.text += "x%02x " % i

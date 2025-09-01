extends VBoxContainer

const OPINFO = preload("res://opinfo.tscn")

func _ready() -> void:
	clear()

func update_info(id: int, op: Operator):
	if id > get_child_count() - 1:
		add_child(OPINFO.instantiate())
	
	var label = get_child(id)
	label.set_op(op)
	label.visible = true

func clear():
	for l in get_children():
		l.visible = false

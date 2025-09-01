extends HBoxContainer

var index = 0

# only has one string now, reads it in one at a time
func get_next():
	var node = get_child(0)
	if index < node.text.length():
		index+=1
		return node.text[index-1]
	return 0

func reset():
	index = 0

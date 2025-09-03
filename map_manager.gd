extends Node2D

@onready var timer: Timer = $Timer
@onready var indicator: ColorRect = $Indicator
@onready var operators: Node2D = $Operators
@onready var operator_info: VBoxContainer = %OperatorInfo
@onready var output_label: Label = %OutputLabel
@onready var input_labels: HBoxContainer = %InputLabels

const TILE = preload("res://tile.tscn")
const TILE_SIZE = Vector2(32, 48)
const OPERATOR = preload("res://operator.tscn")

var tiles = {}
var tile_ids = {}
var saved_tile_state = {}
var spawn_locations = []

var playing = false
var indicator_pos: Vector2i = Vector2i.RIGHT
var last_cam_dir = Vector2i.RIGHT

# only apply updates to tiles at the end of a frame
var queued_changes = []

func _ready() -> void:
	var str = "{"
	for c in str.length():
		saved_tile_state[Vector2i(c, 0)] = str[c]
	_regenerate()
	
	timer.connect("timeout", _update_one_step)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		# mov
		if event.keycode == KEY_LEFT:
			indicator_pos.x -= 1
			indicator.force_flash()
			last_cam_dir = Vector2i.LEFT
			return
		if event.keycode == KEY_RIGHT:
			indicator_pos.x += 1
			indicator.force_flash()
			last_cam_dir = Vector2i.RIGHT
			return
		if event.keycode == KEY_UP:
			indicator_pos.y -= 1
			indicator.force_flash()
			last_cam_dir = Vector2i.UP
			return
		if event.keycode == KEY_DOWN:
			indicator_pos.y += 1
			indicator.force_flash()
			last_cam_dir = Vector2i.DOWN
			return
		
		# typing
		if !playing:
			var code = OS.get_keycode_string(event.get_keycode_with_modifiers()).to_lower()
			var decoded = decode_keycode(code)
			if decoded:
				_try_place_tile(indicator_pos, decoded, true)
				indicator.force_flash()
		
		if event.keycode == KEY_ESCAPE:
			var own = get_viewport().gui_get_focus_owner()
			if own:
				own.release_focus()

func _process(delta: float) -> void:
	# start and stop occur on the start of a frame
	if Input.is_action_just_pressed("start"):
		playing = !playing
		if playing:
			_start_processing()
		else:
			_stop_processing()
	
	# cam follow the indicator
	indicator.position = Vector2(indicator_pos) * TILE_SIZE - TILE_SIZE * .5

func _regenerate():
	for t in tiles.values():
		t.queue_free()
	tiles.clear()
	tile_ids.clear()
	spawn_locations.clear()
	input_labels.reset()
	color_index = 0
	
	for t in saved_tile_state.keys():
		_try_place_tile(t, saved_tile_state[t], false)


func _try_place_tile(coords: Vector2i, id: String, human: bool):
	if id == "space":
		_remove_tile(coords)
		if human:
			indicator.force_flash()
		return
	if id == "backspace":
		_remove_tile(coords - last_cam_dir)
		if human:
			indicator_pos -= last_cam_dir
			indicator.force_flash()
		return
	if id == "delete":
		_remove_tile(coords)
		if human:
			indicator_pos += last_cam_dir
			indicator.force_flash()
		return
	
	if human:
		indicator_pos += last_cam_dir
	
	# add spawn locs
	if id == "{":
		spawn_locations.append(coords)
	
	if decodes.has(id):
		id = decodes[id]
	
	_place_tile(coords, id)

func _place_tile(coords: Vector2i, id: String):
	if tiles.has(coords):
		_remove_tile(coords)
	if id == char(0):
		return
	var t = TILE.instantiate()
	add_child(t)
	t.position = Vector2(coords) * TILE_SIZE
	tiles[coords] = t
	t.set_text(id)
	tile_ids[coords] = id

func _remove_tile(coords: Vector2i):
	if tiles.has(coords):
		tiles[coords].queue_free()
	tiles.erase(coords)
	tile_ids.erase(coords)
	spawn_locations.erase(coords)

func _start_processing():
	saved_tile_state = tile_ids.duplicate()
	timer.start()
	
	for i in spawn_locations.size():
		var o = OPERATOR.instantiate()
		operators.add_child(o)
		o.set_stats(spawn_locations[i], get_color())
		o.position = Vector2(o.pos) * TILE_SIZE
		operator_info.update_info(i, o)

func _stop_processing():
	timer.stop()
	for o in operators.get_children():
		o.queue_free()
	_regenerate()
	
	operator_info.clear()
	output_label.text = ""

func _update_one_step():
	for i in operators.get_child_count():
		var o: Operator = operators.get_child(i)
		# move op
		o.pos += o.dir
		# do new logic
		var tile = " "
		if tile_ids.has(o.pos):
			tile = tile_ids[o.pos]
		# update and check for pops
		var output = o.update(tile, input_labels, self)
		if output is String:
			# just splat it out for now
			output_label.text += output
		
		# send to gui
		operator_info.update_info(i, o)
	
	for qc in queued_changes:
		_place_tile(qc[0], qc[1])
	queued_changes = []


func operator_place_tile(coords: Vector2i, val: int):
	#  delay by a frame so that operator execution order
	# doesnt matter (as much)
	queued_changes.append([coords, char(val)])
func operator_read_tile(coords: Vector2i) -> int:
	if tile_ids.has(coords):
		return tile_ids[coords].unicode_at(0)
	return 0
func spawn_op(coords: Vector2i):
	var o = OPERATOR.instantiate()
	operators.add_child(o)
	o.set_stats(coords, get_color(), [], Vector2i.ZERO)
	o.position = Vector2(o.pos) * TILE_SIZE
	

const decodes = {
	"a":"a",
	"b":"b",
	"c":"c",
	"d":"d",
	"e":"e",
	"f":"f",
	"g":"g",
	"h":"h",
	"i":"i",
	"j":"j",
	"k":"k",
	"l":"l",
	"m":"m",
	"n":"n",
	"o":"o",
	"p":"p",
	"q":"q",
	"r":"r",
	"s":"s",
	"t":"t",
	"u":"u",
	"v":"v",
	"w":"w",
	"x":"x",
	"y":"y",
	"z":"z",
	"shift+a":"A",
	"shift+b":"B",
	"shift+c":"C",
	"shift+d":"D",
	"shift+e":"E",
	"shift+f":"F",
	"shift+g":"G",
	"shift+h":"H",
	"shift+i":"I",
	"shift+j":"J",
	"shift+k":"K",
	"shift+l":"L",
	"shift+m":"M",
	"shift+n":"N",
	"shift+o":"O",
	"shift+p":"P",
	"shift+q":"Q",
	"shift+r":"R",
	"shift+s":"S",
	"shift+t":"T",
	"shift+u":"U",
	"shift+v":"V",
	"shift+w":"W",
	"shift+x":"X",
	"shift+y":"Y",
	"shift+z":"Z",
	
	"1":"1",
	"2":"2",
	"3":"3",
	"4":"4",
	"5":"5",
	"6":"6",
	"7":"7",
	"8":"8",
	"9":"9",
	"0":"0",
	"shift+1":"!",
	"shift+2":"@",
	"shift+3":"#",
	"shift+4":"$",
	"shift+5":"%",
	"shift+6":"^",
	"shift+7":"&",
	"shift+8":"*",
	"shift+9":"(",
	"shift+0":")",
	
	"minus":"-",
	"shift+minus":"_",
	"equal":"=",
	"shift+equal":"+",
	
	"bracketleft":"[",
	"shift+bracketleft":"{",
	"bracketright":"]",
	"shift+bracketright":"}",
	"backslash":"\\",
	"shift+backslash":"|",
	
	"apostrophe":"'",
	"shift+apostrophe":"\"",
	"semicolon":";",
	"shift+semicolon":":",
	
	"comma":",",
	"shift+comma":"<",
	"period":".",
	"shift+period":">",
	"slash":"/",
	"shift+slash":"?",
	
	"quoteleft":"`",
	"shift+quoteleft":"~",
	
	"backspace":"backspace",
	"space":"space",
	"delete":"delete"
}
func decode_keycode(code):
	if !decodes.has(code):
		return null
	else:
		return decodes[code]


func is_complete():
	for o in operators.get_children():
		if o.dir != Vector2i.ZERO:
			return false
	return true

# generate a lot of diff colors
var color_index = 0
func get_color() -> Color:
	var hue = float(color_index) / (9.0) * (2.75)
	color_index += 1
	return Color.from_hsv(hue, 0.75, 1.0)

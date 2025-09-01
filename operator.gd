extends Node2D
class_name Operator

@onready var dir_indicator: Node2D = $DirIndicator

var rot2od: hlp.SecondOrderDynamics

var pos: Vector2i
var stack: Array
var dir: Vector2i
var col: Color

func push(c: String) -> void:
	assert(c.length() == 1)
	stack.append(c.unicode_at(0))
func pushi(i: int) -> void:
	stack.append(i)
func pop() -> String:
	if stack.size() > 0:
		return char(stack.pop_back())
	return char(0)
func popi() -> int:
	if stack.size() > 0:
		return stack.pop_back()
	return 0

func set_stats(p = Vector2i.ZERO, c = Color.WHITE, s = [], d = Vector2i.RIGHT) -> void:
	pos = p
	stack = s
	modulate = c
	#color_rect.color = c
	col = c
	dir = d

func _ready() -> void:
	rot2od = hlp.SecondOrderDynamics.new(2.0, .7, 1.2, 0.0)

# move visually
func _process(delta: float) -> void:
	var target_pos = Vector2(pos) * Vector2(32, 48)
	position = hlp.exdc(position, target_pos, 20, delta)
	var target_rot = dir_indicator.rotation + hlp.angle_to_angle(dir_indicator.rotation, Vector2(dir).angle())
	dir_indicator.rotation = rot2od.update(delta, target_rot)

# perform update
func update(c: String, input_label: Node, tile_holder: Node):
	match c:
		" ":
			pass
		"{":
			pass
		"}":
			dir = Vector2i.ZERO
		# navigation
		"<":
			dir = Vector2i.LEFT
		">":
			dir = Vector2i.RIGHT
		"^":
			dir = Vector2i.UP
		",":
			dir = Vector2i.DOWN
		"'":
			pos += dir
		"\"":
			pos += dir * popi()
		# conditional redirection
		"!":
			var dist = popi()
			if popi() != 0:
				pos += -dir * dist
		"@":
			if popi() != 0:
				dir = rotate_vec2i(dir, -1)
		"#":
			if  popi() != 0:
				dir = rotate_vec2i(dir, 1)
		# conditionals
		"`": # this means b>
			pushi(1 if popi() <= popi() else 0)
		"=":
			pushi(popi() == popi())
		# easy math
		":":
			var a = popi()
			pushi(a)
			pushi(a)
		"+":
			var a = popi()
			var b = popi()
			pushi(b+a)
		"-":
			var a = popi()
			var b = popi()
			pushi(b-a)
		"*":
			var a = popi()
			var b = popi()
			pushi(b*a)
		"/":
			var a = popi()
			var b = popi()
			if a == 0:
				pushi(0)
			pushi(b/a)
		"%":
			var a = popi()
			var b = popi()
			pushi(b%a)
		"&":
			var a = popi()
			if a < 10:
				a += "0".unicode_at(0)
			var b = popi()
			if b < 10:
				b += "0".unicode_at(0)
			var str = char(b)+char(a)
			# error prevention
			for char in str:
				if !["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"].has(char):
					pushi(0)
					return
			pushi(str.hex_to_int())
		# input
		"?":
			var n = input_label.get_next()
			if n is not String and n == 0:
				pushi(0)
			else:
				push(n)
		# tries to get an int
		"|":
			pushi(int(input_label.get_next()))
		# save and load to map
		"(":
			tile_holder.operator_place_tile(pos + rotate_vec2i(dir, -1), popi())
		")":
			tile_holder.operator_place_tile(pos + rotate_vec2i(dir, 1), popi())
		"[":
			pushi(tile_holder.operator_read_tile(pos + rotate_vec2i(dir, -1)))
		"]":
			pushi(tile_holder.operator_read_tile(pos + rotate_vec2i(dir, 1)))
		# spawn new operator
		"~":
			tile_holder.spawn_op(pos + rotate_vec2i(dir, -1))
		"_":
			tile_holder.spawn_op(pos + rotate_vec2i(dir, 1))
		
		# poppers
		"$":
			popi()
		".":
			return pop()
		";":
			return str(popi())
		"\\":
			var a = popi()
			var b = popi()
			pushi(a)
			pushi(b)
		# pushers
		"0":
			pushi(0)
		"1":
			pushi(1)
		"2":
			pushi(2)
		"3":
			pushi(3)
		"4":
			pushi(4)
		"5":
			pushi(5)
		"6":
			pushi(6)
		"7":
			pushi(7)
		"8":
			pushi(8)
		"9":
			pushi(9)
		_:
			push(c)
	
	return -1

static func rotate_vec2i(v: Vector2i, i: int):
	return Vector2i(Vector2(v).rotated(PI*.5*i))

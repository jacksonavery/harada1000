extends Node2D

func set_text(text: String):
	$Label.text = text
	if color_lookup.has(text):
		modulate = color_lookup[text]

const BRANCH_COLOR = Color.CRIMSON
const MATH_COLOR = Color.CORNFLOWER_BLUE
const PATH_COLOR = Color.MEDIUM_PURPLE
const SETGET_COLOR = Color.GREEN_YELLOW
const IO_COLOR = Color.CORAL
const SPAWN_COLOR = Color.DEEP_PINK
const STACK_COLOR = Color.YELLOW
const START_END_COLOR = Color.WEB_GRAY
const color_lookup = {
	# branch
	"!": BRANCH_COLOR,
	"@": BRANCH_COLOR,
	"#": BRANCH_COLOR,
	# special guy
	"$": Color.GREEN,
	# math
	"+": MATH_COLOR,
	"-": MATH_COLOR,
	"*": MATH_COLOR,
	"/": MATH_COLOR,
	"%": MATH_COLOR,
	"=": MATH_COLOR,
	"&": MATH_COLOR, # not really math tbh, but functions like it
	# pathing
	">": PATH_COLOR,
	"<": PATH_COLOR,
	"^": PATH_COLOR,
	",": PATH_COLOR,
	"'": PATH_COLOR,
	"\"": PATH_COLOR,
	# setgets
	"[": SETGET_COLOR,
	"]": SETGET_COLOR,
	"(": SETGET_COLOR,
	")": SETGET_COLOR,
	# IO
	"?": IO_COLOR,
	"|": IO_COLOR,
	";": IO_COLOR,
	".": IO_COLOR,
	# spawning
	"~": SPAWN_COLOR,
	"_": SPAWN_COLOR,
	# stack manip
	"\\": STACK_COLOR,
	":": STACK_COLOR,
	# spawnin
	"{": START_END_COLOR,
	"}": START_END_COLOR,
}

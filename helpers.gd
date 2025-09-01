extends Resource
class_name hlp

# shoutout freya holmer
static func exdc(a, b, decay, delta):
	return b+(a-b)*exp(-decay*delta)

#  shoutout t3ssel8r. i really like how exdc is more or less stateless and wish
# this were too but there's no real way to do all this statelessly
#  intentionally doesnt define the type of the variable!! make sure you only ever
# feed it the same type or it wont work!! i wish godot did type templates !!
class SecondOrderDynamics:
	var xp#: Vector2		# prev inp
	var y#: Vector2		# state
	var yd#: Vector2
	var k1: float		# derived constants
	var k2: float
	var k3: float
	
	func _init(f: float, z: float, r: float, x0) -> void:
		k1 = z / (PI * f)
		k2 = 1.0 / ((TAU * f) * (TAU * f))
		k3 = r * z / (TAU * f)
		
		xp = x0
		y = x0
		yd = x0 * 0.0
	
	func update(delta: float, x, xd = null):
		if xd == null:
			xd = (x - xp) / delta
			xp = x
		
		var stable_k2 = max(k2, 1.1 * (delta * delta * .25 + delta * k1 * .5))
		
		y = y + delta * yd
		yd = yd + delta * (x + k3*xd - y - k1*yd) / stable_k2
		return y


static func angle_to_angle(from, to):
	return fposmod(to-from + PI, PI*2) - PI

# ensure positivity
static func gcd(a: int, b: int) -> int:
	return _gcd(absi(a), absi(b))
# https://forum.godotengine.org/t/how-to-make-fraction-simplification/13728
static func _gcd(a: int, b: int) -> int:
	return a if b == 0 else gcd(b, a % b)

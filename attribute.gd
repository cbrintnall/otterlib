extends RefCounted
class_name Attribute

var max: float
var min: float
var base: float
var current: float:
	set(val):
		current = clampf(val, min, max)

func _init(base_value: float, min_value := -INF, max_value := INF):
	base = base_value
	min = min_value
	max = max_value
	current = base_value
	
func reset():
	current = base

func set_value(amt: float):
	current = amt

# overrides current value to be a % of the base
func set_percent(amt: float):
	current = base + (base * amt)

func incr_percent(amt: float):
	incr(base * amt)
	
func incr(amt: float):
	current += amt
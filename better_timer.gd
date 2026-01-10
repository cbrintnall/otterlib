extends RefCounted
class_name BetterTimer

var SPEED_MULT := 1.0
var every: float
var progress: float:
  get:
    return clampf(_time / every, 0.0, 1.0)

var _time: float

func _init(_every: float):
  every = _every
  
func reset():
  _time = 0.0
  
func set_normalized(t: float):
  _time = t * every

# Must be called every frame with delta, doesn't increment itself otherwise
func check(delta: float, wrap_time := true) -> bool:
  _time = clampf(_time + (delta * SPEED_MULT), 0.0, every)
  if _time >= every:
    if wrap_time:
      _time -= every
    return true
  return false

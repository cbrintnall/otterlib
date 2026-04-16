extends RefCounted
class_name BetterTimer

var multiplier := 1.0
var every: float
var progress: float:
  get:
    return clampf(_time / every, 0.0, 1.0)
var remaining: float:
  get:
    return _time

var _time: float
var _ltime: float

func _init(_every: float):
  every = _every
  
func reset():
  _time = 0.0
  
func finished() -> bool:
  return progress >= 1.0
  
func set_normalized(t: float):
  _time = t * every

# Must be called every frame with delta, doesn't increment itself otherwise
func check(delta: float, wrap_time := true) -> bool:
  _ltime = _time
  _time = clampf(_time + (delta * multiplier), 0.0, every)
  if _time >= every:
    if wrap_time:
      _time -= every
    return true
  return false

func threshold(marker: float) -> bool:
  return progress > marker and clampf(_ltime / every, 0.0, 1.0) < marker

func threshold_repeat(marker: float) -> bool:
  return fmod(progress, marker) < fmod(clampf(_ltime / every, 0.0, 1.0), marker)

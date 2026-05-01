extends RefCounted
class_name BetterTimer

signal finished_progress

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
var _reset_bind: Callable

func _init(_every: float):
  every = _every
  
func bind_reset(cb: Callable):
  if _reset_bind == null or not _reset_bind.is_valid():
    _reset_bind = cb
  
func reset():
  _time = 0.0
  
func reset_to(time: float):
  every = time
  reset()
  
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
    finished_progress.emit()
    if _reset_bind.is_valid():
      reset_to(_reset_bind.call())
    return true
  return false

func threshold(marker: float) -> bool:
  return progress > marker and clampf(_ltime / every, 0.0, 1.0) < marker

func threshold_repeat(marker: float) -> bool:
  return fmod(progress, marker) < fmod(clampf(_ltime / every, 0.0, 1.0), marker)

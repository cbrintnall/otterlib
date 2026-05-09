extends Node
class_name TaskQueue

signal just_finished

var finished: bool:
  get:
    return len(queue) == 0 and _current == null

var queue := []

var _current: Task

func register(callable: Callable):
  queue.push_back(callable)
  
func _process(delta: float) -> void:
  if queue and not _current:
    _current = Task.wait_for(queue.pop_front())
    
  if _current and _current.finished:
    _current = null
    if not queue:
      just_finished.emit()

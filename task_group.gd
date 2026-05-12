extends RefCounted
class_name TaskGroup

signal group_finished

var finished: bool:
  get:
    return _counter <= 0

var _counter := 0

func run(callable: Callable):
  _counter += 1
  await callable.call()
  _counter -= 1
  if _counter == 0:
    group_finished.emit()
  assert(_counter >= 0)

extends Node
class_name TaskGroup

var finished: bool:
  get:
    return _counter <= 0

var _counter := 0

func run(callable: Callable):
  _counter += 1
  await callable.call()
  _counter -= 1
  assert(_counter >= 0)

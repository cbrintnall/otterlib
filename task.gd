extends RefCounted
class_name Task

var finished := false

static func wait_for(cb: Callable) -> Task:
  var task := Task.new()
  task.wait_for_callable(cb)
  return task

func wait_for_callable(cb: Callable):
  await cb.call()
  finished = true

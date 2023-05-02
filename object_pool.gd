extends Node
class_name ObjectPool

var scene: PackedScene
var on_spawn: Callable

var _existing := []
var _count := 0

func _init(_scene: PackedScene, _on_spawn: Callable):
  scene = _scene
  on_spawn = _on_spawn

  Performance.add_custom_monitor("pools/%s" % _scene.resource_path, func(): return _count)

func request():
  if len(_existing) > 0:
    var next = _existing.pop_front()
    next.on_show()
    return next

  var new_object = scene.instantiate()
  assert(new_object.has_method("on_show"))
  assert(new_object.has_method("on_hide"))
  assert(new_object.has_signal("restore"))
  new_object.return.connect(func():
    _existing.push_back(new_object)
    new_object.on_hide()
  )
  add_child(new_object)
  on_spawn.call(new_object)
  _count += 1

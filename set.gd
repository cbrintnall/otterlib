extends RefCounted
class_name Set

var _data := {}

func _init(data := []):
  append_array(data)

func count() -> int:
  return len(_data)

func add(obj):
  _data[obj]=true
  
func remove(obj):
  _data.erase(obj)
  
func has(obj) -> bool:
  return _data.get(obj, false)

func to_array() -> Array:
  return _data.keys()

func append_array(arr: Array):
  for obj in arr:
    add(obj)

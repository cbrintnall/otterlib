extends RefCounted
class_name Set

var _data := {}

func add(item):
	_data[item] = true
	
func remove(item):
	_data.erase(item)
	
func contains(item):
	return _data.get(item) != null

func as_array() -> Array:
	return _data.keys()

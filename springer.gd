extends Node

var data = {}
var removals := []

func register(field:String, obj, target, velocity, stiffness, damp, speed := 1.0):
  if not data.has(obj):
    data[obj] = {}
    
  data[obj][field] = {
    "stiffness": stiffness,
    "damp": damp,
    "target": target,
    "velocity": velocity,
    "speed": speed
  }
  
func remove(obj, field: String):
  data.get(obj, {}).erase(field)

func set_target_getter(obj, field: String, getter: Callable):
  data[obj][field]["getter"] = getter

func _process(delta: float) -> void:
  while removals:
    data.erase(removals.pop_front())
  
  for obj in data:
    for field in data[obj]:
      var field_data = data[obj][field]
      var field_target = data[obj][field].get("getter", func(): return field_data["target"]).call()
      data[obj][field]["target"] = field_target

  for obj in data:
    if not obj:
      removals.push_back(obj)
      continue
    
    if not is_instance_valid(obj):
      removals.push_back(obj)
      continue

    for field in data[obj]:
      var field_data = data[obj][field]
      var res = Springs.spring(
        obj.get(field),
        field_data["target"],
        field_data["velocity"],
        minf(delta * field_data["speed"], 1.0/60.0),
        field_data["stiffness"],
        field_data["damp"]
      )
      
      field_data["velocity"] = res["velocity"]
      obj.set(field,res["position"])

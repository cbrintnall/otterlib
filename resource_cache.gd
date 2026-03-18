@abstract
extends Node
class_name ResourceCache

const SEARCH_PATHS = ["res://"]
const RESOURCE_EXTENSIONS = ["tres", "res"]

@export var resources: Array[Resource] = []:
  set(value):
    resources = value
    if Engine.is_editor_hint():
      notify_property_list_changed()
      
@abstract func is_resource(resource: Resource) -> bool

func collect_resources() -> void:
  var found: Array[Resource] = []

  for base_path in SEARCH_PATHS:
    _scan_directory(base_path, found)

  resources = found
  
func _notification(what: int) -> void:
  if what == NOTIFICATION_EDITOR_PRE_SAVE:
    collect_resources()

func _scan_directory(path: String, results: Array[Resource]) -> void:
  var dir = DirAccess.open(path)
  if dir == null:
    return

  dir.list_dir_begin()
  var file_name = dir.get_next()

  while file_name != "":
    var full_path = path.path_join(file_name)

    if dir.current_is_dir() and not file_name.begins_with("."):
      _scan_directory(full_path, results)
    elif file_name.get_extension() in RESOURCE_EXTENSIONS:
      _try_load_resources(full_path, is_resource, results)

    file_name = dir.get_next()

  dir.list_dir_end()

func _try_load_resources(path: String, predicate: Callable, results: Array[Resource]) -> void:
  var resource = load(path)
  if predicate.call(resource):
    results.append(resource)

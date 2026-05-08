@tool
extends BaseCreateScript
class_name CreateResourceScript

func _on_text_input(text: String) -> void:
  var key = text.replace(" ", "_").to_lower()
  var path = "%s/%s_%s.tres" % [ get_path(), get_prefix(), key ]
  var resource := create(text, key)
  assert(ResourceSaver.save(resource, path) == OK)
  
  var res = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
  EditorInterface.get_file_system_dock().navigate_to_path(path)
  EditorInterface.get_inspector().edit(res)

func create(text: String, key: String) -> Resource:
  return null

func get_prefix() -> String:
  return ""

func get_path() -> String:
  return ""

extends Node

const SAVE_GROUP = "saveables"

var save_name := "latest.save"
var save_path: String:
  get:
    return "user://%s" % save_name

var _save_data := ConfigFile.new()

func _ready() -> void:
  if OS.has_feature("dev"):
    save_name = "dev.save"

func get_save_data(section: String, key: String, default = null):
  return _save_data.get_value(section, key, default)
  
# NOTE: eventually we need to backup the save while the current save is happening, to avoid corruption.
"""
get_save_data() should return a dictionary of the format:
  {
    "title": <string>
    "data": {
      <save_data_key: string>: <save_data_value: any>
    }
  }
"""
func save(path: String = ""):
  if not path.is_empty():
    save_path = path
  var saveables = Utils.get_nodes_with_predicate(get_tree().root, func(node: Node): return node.has_method("get_save_data"))
  
  print("found '%d' nodes to save" % len(saveables))
  
  var data = []
  var next_cfg := ConfigFile.new()
  for saveable in saveables:
    if saveable==self:
      continue
    var node_data = saveable.get_save_data() 
    if node_data:
      data.push_back(node_data)
      
  print("saving '%d' data to '%s'" % [len(data), save_path])

  for obj in data:
    assert(obj.has("title"), "Save data missing 'title' key..")
    assert(obj.has("data"), "Save data missing 'data' key..")
    
    if not (obj.has("title") and obj.has("data")):
      continue
      
    for save_data_key in obj["data"]:
      next_cfg.set_value(obj["title"], save_data_key, obj["data"][save_data_key])
    
  _save_data = next_cfg
  _write_save()
  
func _write_save():
  var err = _save_data.save(save_path)
  
  if err:
    push_error("error while writing save data, %s" % error_string(err))
      
func _get_raw_save_path() -> String:
  return "%s/%s" % [OS.get_user_data_dir(), save_name]
  
func load_save(path: String = ""):
  var load_path = save_path
    
  if not path.is_empty():
    load_path = path
  
  var err = _save_data.load(load_path)
  print("user save location: '%s'"%_get_raw_save_path())

  if err:
    push_error("error while loading save data, %s" % error_string(err))
    return

  print("save data loaded from '%s'" % load_path)

extends Node

var cfg := ConfigFile.new()

var settings_path:
  get:
    return "/".join(PackedStringArray([OS.get_user_data_dir(), "settings.cfg"]))

func _init():
  var err = cfg.load(settings_path)
  if err != OK:
    cfg.save(settings_path)

func save():
  cfg.save(settings_path)

func get_value(section: String, key: String, default = null):
  return cfg.get_value(section, key, default)

func set_value(section: String, key: String, value: Variant, save_value := true):
  cfg.set_value(section, key, value)
  if save_value:
    save()

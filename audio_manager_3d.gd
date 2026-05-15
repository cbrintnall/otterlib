extends Node

var _debounced := {}
var _players := []
var _local_players: Array[AudioStreamPlayer] = []

var _pitch_shift: AudioEffectPitchShift

func _ready():
  const start = 20
  for i in start:
    _players.push_back(AudioStreamPlayer3D.new())
    add_child(_players[-1])
  _pitch_shift = AudioEffectPitchShift.new()
  AudioServer.add_bus_effect(AudioServer.get_bus_index("Master"), _pitch_shift)
    
func _process(_delta: float) -> void:
  _pitch_shift.pitch_scale = Engine.time_scale
    
func play(data: Dictionary):
  if data.get("debounce", 0.0) > 0.0:
    var last_played = _debounced.get(data["stream"], 0.0)
    if (Time.get_ticks_msec()/1000.0) - last_played < data.get("debounce", 0.0):
      return
    _debounced[data["stream"]] = Time.get_ticks_msec()/1000.0
  
  var location = data.get("location")
  var player
  
  if location == Vector3.ZERO or location == null:
    if len(_local_players) > 0:
      player = _local_players.pop_back()
    else:
      _local_players.push_back(AudioStreamPlayer.new())
      add_child(_local_players[-1])
      player = _local_players.pop_back()
    player.finished.connect(_local_players.push_back.bind(player), CONNECT_ONE_SHOT)
  else:
    if len(_players) > 0:
      player = _players.pop_back()
    else:
      _players.push_back(AudioStreamPlayer3D.new())
      add_child(_players[-1])
      player = _players.pop_back() as AudioStreamPlayer3D
    if data.get("distance", 0.0):
      player.max_distance = data.get("distance", 0.0)
    if data.get("parent"):
      player.reparent(data.get("parent"), false)
    elif data.get("location") != Vector3.ZERO:
      player.global_position = data.get("location")
    
    player.finished.connect(_players.push_back.bind(player), CONNECT_ONE_SHOT)
    
  player.volume_db = linear_to_db(data.get("volume", 1.0))
  player.stream = data["stream"]
  player.pitch_scale = 1.0 + (randf()*data.get("pitch_variance", 0.0)) + data.get("pitch_additional", 0.0)
    
  player.play()

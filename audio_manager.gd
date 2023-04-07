extends Node

var _players: Array[AudioStreamPlayer] = []
var _players_3d: Array[AudioStreamPlayer3D] = []

func play(stream: AudioStream, volume := 1.0):
  var chosen_player: AudioStreamPlayer

  for player in _players:
    if not player.playing:
      chosen_player = player

  if chosen_player == null:
    chosen_player = AudioStreamPlayer.new()
    add_child(chosen_player)

  chosen_player.volume_db = linear_to_db(volume)
  chosen_player.stream = stream
  chosen_player.play()

func play_3d(stream: AudioStream, location: Vector3, max_distance := 0.0, volume := 1.0):
  var chosen_player: AudioStreamPlayer3D

  for player in _players_3d:
    if not player.playing:
      chosen_player = player

  if chosen_player == null:
    chosen_player = AudioStreamPlayer3D.new()
    add_child(chosen_player)

  chosen_player.max_distance = max_distance
  chosen_player.global_position = location
  chosen_player.volume_db = linear_to_db(volume)
  chosen_player.stream = stream
  chosen_player.play()

@rpc("call_local", "any_peer")
func play_3d_rpc(stream_path: String, location: Vector3, max_distance := 0.0, volume := 1.0):
  play_3d(load(stream_path), location, max_distance, volume)

@rpc("call_local", "any_peer")
func play_rpc(stream_path: String, location: Vector3, max_distance := 0.0, volume := 1.0):
  play(load(stream_path), volume)


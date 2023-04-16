extends Node

class AudioPayload:
  var stream: AudioStream
  var location: Vector3
  var target: Node3D
  var bus := "Master"
  var distance := 0.0
  var volume := 1.0
  var pitch := 1.0

var _players: Array[AudioStreamPlayer] = []
var _players_3d: Array[AudioStreamPlayer3D] = []

func play(stream: AudioStream, volume := 1.0, pitch := 1.0, bus := "Master"):
  var chosen_player: AudioStreamPlayer

  for player in _players:
    if not player.playing:
      chosen_player = player

  if chosen_player == null:
    chosen_player = AudioStreamPlayer.new()
    add_child(chosen_player)

  chosen_player.bus = bus
  chosen_player.pitch_scale = pitch
  chosen_player.volume_db = linear_to_db(volume)
  chosen_player.stream = stream
  chosen_player.play()

func play_3d(stream: AudioStream, location: Vector3, max_distance := 0.0, volume := 1.0, pitch := 1.0, bus := "Master", follow = null):
  var chosen_player: AudioStreamPlayer3D

  for player in _players_3d:
    if not player.playing:
      chosen_player = player

  if chosen_player == null:
    chosen_player = AudioStreamPlayer3D.new()
    chosen_player.finished.connect(func(): chosen_player.reparent(self, false))
    add_child(chosen_player)

  if follow is Node3D:
    chosen_player.reparent(follow, false)
    chosen_player.position = Vector3.ZERO

  chosen_player.bus = bus
  chosen_player.pitch_scale = pitch
  chosen_player.max_distance = max_distance
  chosen_player.global_position = location
  chosen_player.volume_db = linear_to_db(volume)
  chosen_player.stream = stream
  chosen_player.play()

func play_payload(payload: AudioPayload):
  if payload.location != Vector3.ZERO:
    play_3d(
      payload.stream,
      payload.location,
      payload.distance,
      payload.volume,
      payload.pitch,
      payload.bus
    )
  else:
    play(
      payload.stream,
      payload.volume,
      payload.pitch,
      payload.bus
    )

@rpc("call_local", "any_peer")
func play_3d_rpc(stream_path: String, location: Vector3, max_distance := 0.0, volume := 1.0, pitch := 1.0, bus := "Master", follow = null):
  var follower = get_node(follow) if follow is NodePath else null
  play_3d(load(stream_path), location, max_distance, volume, pitch, bus, follower)

@rpc("call_local", "any_peer")
func play_rpc(stream_path: String, volume := 1.0, pitch := 1.0, bus := "Master"):
  play(load(stream_path), volume, pitch, bus)


extends Node

const FADE_TIME_SECONDS = 2.5
const VOLUME = 0.4
# there is weird bug with setting this to 0.0, so we use 0.01
const MINIMUM_VOLUME = 0.01

var music_player: AudioStreamPlayer
var backup_player: AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	backup_player = AudioStreamPlayer.new()
	
	add_child(music_player)
	add_child(backup_player)
	
	for child in get_children():
		(child as AudioStreamPlayer).bus = "Music"

func play(music: AudioStream):
	var fader = get_tree().create_tween()
	backup_player.stream = music
	backup_player.play()

	fader.tween_property(
		music_player,
		"volume_db",
		linear_to_db(MINIMUM_VOLUME),
		FADE_TIME_SECONDS
	).from_current()

	backup_player.volume_db = linear_to_db(MINIMUM_VOLUME)
	fader.parallel().tween_property(
		backup_player,
		"volume_db",
		linear_to_db(VOLUME),
		FADE_TIME_SECONDS
	).from_current()

	fader.finished.connect(
		func():
			var temp = music_player
			music_player = backup_player
			backup_player = temp
			backup_player.stop()
			backup_player.volume_db = linear_to_db(MINIMUM_VOLUME)
	)

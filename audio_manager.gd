extends Node

var _players: Array[AudioStreamPlayer] = []

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

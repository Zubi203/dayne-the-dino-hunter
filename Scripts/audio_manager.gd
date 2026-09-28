class_name AudioManager
extends Node

#array that stores cached audio players
var players: Array[AudioStreamPlayer]

@export var pitch_randomness: float = 0.1

#register this manager to the service locator when it enters the scene tree
func _enter_tree() -> void:
	ManagerRegistry.register("audio_manager", self)

#remove this manager from the service locator when it exits the scene tree
func _exit_tree() -> void:
	ManagerRegistry.unregister("audio_manager")

func play (sound: AudioStream):
	if sound == null:
		return
	
	#get an audio stream player and play the requested sound
	var player: AudioStreamPlayer = _get_player()
	player.stream = sound
	player.play()

func play_random_pitch(sound: AudioStream):
	if sound == null:
		return
	
	#get an audio stream player
	var player: AudioStreamPlayer = _get_player()
	player.stream = sound
	
	#randomize the pitch of the audio stream player
	player.pitch_scale += randf_range(-pitch_randomness, pitch_randomness)
	
	#play requested sound
	player.play()

func _get_player() -> AudioStreamPlayer:
	
	#check if the audio player array has an available audio player
	for player in players:
		#if a cached audio player is not currently in use, reuse it
		if not player.playing:
			#reset audio player pitch in case it has been altered
			player.pitch_scale = 1.0
			return player
	
	#if no audio stream players are available in the cached array or if all are busy, create a new audio stream player
	var new_player: AudioStreamPlayer = AudioStreamPlayer.new()
	
	#add the new audio player to the array of cached players
	players.append(new_player)
	add_child(new_player)
	
	#assign the appropriate audio bus to the new audio player
	new_player.bus = "SFX"
	return new_player

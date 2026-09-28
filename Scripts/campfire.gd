extends CheckpointButton

@export var click_particles: GPUParticles2D
@export var campfire_click_sound: AudioStream

var audio_manager: AudioManager:
	get: return ManagerRegistry.get_manager("audio_manager")


func checkpoint_clicked():
	
	#emit particles
	if click_particles:
		click_particles.restart()
	
	#play sound
	audio_manager.play(campfire_click_sound)
	
	await get_tree().create_timer(1).timeout
	
	#inform game manager that this button has been pressed
	game_manager._on_rest_button_pressed()

#emit particles while the scene is loading in to reduce jitters/lag
func _pre_warm_particles():
	click_particles.emitting = true

class_name CameraController
extends Camera2D

var shake_intensity: float = 0

#register this script to the service locator when it enters the scene tree
func _enter_tree() -> void:
	ManagerRegistry.register("camera_controller", self)

#remove this script from the service locator as it exits the scene tree
func _exit_tree() -> void:
	ManagerRegistry.unregister("camera_controller")

func shake (intensity: float):
	
	#if screen shake is disabled, cancel execution
	if not GlobalData.screen_shake_enabled:
		return
	
	shake_intensity = intensity

func _process(delta: float) -> void:
	if shake_intensity <= 0:
		return
	
	#if shake intensity is greater then zero, gradually decrease it to zero
	shake_intensity = move_toward(shake_intensity, 0.0, delta * shake_intensity * 5)
	
	#offset the camera based on shake intensity every frame
	offset.x = randf_range(-shake_intensity, shake_intensity)
	offset.y = randf_range(-shake_intensity, shake_intensity)

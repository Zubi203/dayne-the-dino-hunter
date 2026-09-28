class_name BuffOnDamageTakenStatus
extends StatusEffect

@export var buff_to_apply: StatusEffect

func apply_status(target: Character):
	if target == null:
		return
	
	target.add_status(self)
	
	#connect the character's DamageTaken signal when this buff is applied
	if not target.DamageTaken.is_connected(_on_damage_taken):
		target.DamageTaken.connect(_on_damage_taken)

func get_description(host: Character = null) -> String:
	return "Gain " + buff_to_apply.name + " when taking damage"

func _on_damage_taken(target: Character):
	if target == null:
		return
	
	#apply buff whenever the DamageTaken signal is detected
	target.add_status(buff_to_apply)

func on_remove(target: Character):
	
	#disconnect the character's DamageTaken signal when this buff is removed
	if target.DamageTaken.is_connected(_on_damage_taken):
		target.DamageTaken.disconnect(_on_damage_taken)

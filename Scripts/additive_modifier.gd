class_name AdditiveModifierStatus
extends ModifierStatus

@export var intensity: int = 2

func apply_status(target: Character):
	if target == null:
		return
	
	#add status to front of status effect array
	#this is for mathematical consistency by making sure all additive modifiers are applied before multiplicative ones
	target.add_status_front(self)

func apply_modifier(_target: Character, stat: int, type: AffectedStat) -> int:
	if not type == stat_to_modify:
		return stat
	
	stat += intensity
	
	
	if not allow_negative:
		#limit final value if negative numbers are not allowed
		stat = clamp(stat, 1, 999)
	
	return stat

#generate description for this status
#this is based on what stat it modifies, its intensity, and whether its a positive or negative change
func get_description(host: Character = null) -> String:
	var result: String = ""
	var increase_type_string: String
	if intensity < 0:
		increase_type_string = "reduced"
	else:
		increase_type_string = "increased"
	
	result = get_modifier_stat_type_string() + " is " + increase_type_string + " by " + str(abs(intensity))
	return result

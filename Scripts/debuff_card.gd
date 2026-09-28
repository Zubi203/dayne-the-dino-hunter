class_name StatusCard
extends CardData

@export var debuffs_to_apply: Array[StatusEffect] = []
@export var buffs_to_apply: Array[StatusEffect] = []

@export var damage: int 
@export var block: int 
@export var heal: int 
@export var self_damage: int

@export var cards_to_draw: int 
@export var energy_gain: int

var game_manager: GameManager:
	get: return ManagerRegistry.get_manager("game_manager")

var card_manager: CardManager:
	get: return ManagerRegistry.get_manager("card_manager")

func cast (data : CastData):
	if data.caster == null or data.opponent == null:
		return
	
	if damage > 0:
		#deal damage
		data.caster.attack(data.opponent, damage)
		await data.caster.get_tree().create_timer(0.2).timeout
		
	if block > 0:
		#gain block
		data.caster.block(block)
		await data.caster.get_tree().create_timer(0.2).timeout
		
	if heal > 0:
		#heal
		data.caster.heal(heal)
		await data.caster.get_tree().create_timer(0.2).timeout
		
	if self_damage > 0:
		#deal damage to caster
		data.caster.take_damage(self_damage)
		await data.caster.get_tree().create_timer(0.2).timeout
	
	if energy_gain > 0:
		#gain energy
		game_manager.current_energy += energy_gain
		await data.caster.get_tree().create_timer(0.2).timeout

	
	await data.caster.get_tree().create_timer(0.2).timeout
	
	#apply status effects to opponent
	for status in debuffs_to_apply:
		status.apply_status(data.opponent)
		await data.caster.get_tree().create_timer(0.4).timeout
	
	#apply status effects to self
	for status in buffs_to_apply:
		status.apply_status(data.caster)
		await data.caster.get_tree().create_timer(0.4).timeout
	
	#draw cards
	for i in cards_to_draw:
		card_manager._deal_card()
		await data.caster.get_tree().create_timer(0.2).timeout

func get_description(data: CastData) -> String:
	var description: String = ""
	
	# Update description numbers based on caster's and opponent's status effects
	
	if damage > 0:
		var amount: int = damage
		if data.caster:
			var self_statuses: Array[ActiveEffect] = data.caster.status_effects
			for status in self_statuses:
				if status.status_data is ModifierStatus:
					amount = status.status_data.apply_modifier(data.caster, amount, ModifierStatus.AffectedStat.ATTACK)
		if data.opponent:
			var opponent_statuses: Array[ActiveEffect] = data.opponent.status_effects
			for status in opponent_statuses:
				if status.status_data is ModifierStatus:
					amount = status.status_data.apply_modifier(data.opponent, amount, ModifierStatus.AffectedStat.INCOMING_DAMAGE)
		description += "\nDeal " + str(amount) + " damage." 
	
	if block > 0:
		var amount: int = block
		if data.caster:
			var self_statuses: Array[ActiveEffect] = data.caster.status_effects
			for status in self_statuses:
				if status.status_data is ModifierStatus:
					amount = status.status_data.apply_modifier(data.caster, amount, ModifierStatus.AffectedStat.BLOCK)
		description += "\nGain " + str(amount) + " block." 
	
	if heal > 0:
		var amount: int = heal
		if data.caster:
			var self_statuses: Array[ActiveEffect] = data.caster.status_effects
			for status in self_statuses:
				if status.status_data is ModifierStatus:
					amount = status.status_data.apply_modifier(data.caster, amount, ModifierStatus.AffectedStat.HEALING)
		description += "\nHeal " + str(amount) + " health." 
	
	if self_damage > 0:
		var amount: int = self_damage
		if data.caster:
			var self_statuses: Array[ActiveEffect] = data.caster.status_effects
			for status in self_statuses:
				if status.status_data is ModifierStatus:
					amount = status.status_data.apply_modifier(data.caster, amount, ModifierStatus.AffectedStat.INCOMING_DAMAGE)
		description += "\nLose " + str(amount) + " health." 
	
	if energy_gain > 0:
		description += "\nGain " + str(energy_gain) + " energy." 
	
	if cards_to_draw > 0:
		description += "\nDraw " + str(cards_to_draw) + " card(s)." 
	
	for status in debuffs_to_apply:
		description += "\nInflict " + status.name + "."
	for status in buffs_to_apply:
		description += "\nGain " + status.name + "."
	return description

func get_preview_text(data: CastData = null) -> String:
	
	#Update preview description numbers based on caster's and opponent's status effects
	
	if damage > 0:
		var amount: int = damage
		if data.caster:
			var self_statuses: Array[ActiveEffect] = data.caster.status_effects
			for status in self_statuses:
				if status.status_data is ModifierStatus:
					amount = status.status_data.apply_modifier(data.caster, amount, ModifierStatus.AffectedStat.ATTACK)
		if data.opponent:
			var opponent_statuses: Array[ActiveEffect] = data.opponent.status_effects
			for status in opponent_statuses:
				if status.status_data is ModifierStatus:
					amount = status.status_data.apply_modifier(data.opponent, amount, ModifierStatus.AffectedStat.INCOMING_DAMAGE)
		return str(amount) 
	
	if block > 0:
		var amount: int = block
		if data.caster:
			var self_statuses: Array[ActiveEffect] = data.caster.status_effects
			for status in self_statuses:
				if status.status_data is ModifierStatus:
					amount = status.status_data.apply_modifier(data.caster, amount, ModifierStatus.AffectedStat.BLOCK)
		return str(amount) 
	
	if heal > 0:
		var amount: int = heal
		if data.caster:
			var self_statuses: Array[ActiveEffect] = data.caster.status_effects
			for status in self_statuses:
				if status.status_data is ModifierStatus:
					amount = status.status_data.apply_modifier(data.caster, amount, ModifierStatus.AffectedStat.HEALING)
		return str(amount) 
	
	
	return "???"

func check_cast_condition() -> bool:
	return true

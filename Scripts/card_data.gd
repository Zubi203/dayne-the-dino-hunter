#Base class for all cards to inherit from

@abstract
class_name CardData
extends Resource

enum CardType{
	ATTACK,
	SKILL,
	STATUS, #unused
	POWER #unused
}

@export var name: String = ""
@export var type: CardType
@export var cost: int = 1
@export var icon: Texture2D
@export var override_auto_generated_description: bool = false
@export_multiline var special_description: String = ""

#all status effects in this array will be displayed as tooltips when the card is hovered over
@export var tooltip_statuses: Array[StatusEffect] = []

#sub class containing a reference to all combatants on the field
#required for card casting logic
class CastData:
	var caster: Character
	var opponent: Character

@abstract
#this method returns a description for the card based on its attributes
func get_description(data: CastData) -> String

@abstract
#this method is called when this card is played
#all inheriting card classes will have their core functionality contained within this method
func cast (data : CastData)

@abstract
#this method returns a short (usually integer-only) string reflecting the damage/block/heal/status associated with this card
#this string is to be displayed on the enemy's attack preview/intent graphic only
func get_preview_text(data: CastData = null) -> String

@abstract
#this method checks to see if a card can be casted
#if no special prerequisites are associated with a card, always return true
func check_cast_condition() -> bool

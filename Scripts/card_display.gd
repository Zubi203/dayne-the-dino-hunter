# UI class that displays an array of cards in a grid layout

class_name CardDisplay
extends Control


@export var card_container: GridContainer
@export var card_button_scene: PackedScene
@export var title_label: Label
@export var tooltip_container: VBoxContainer
@export var display_on_ready: bool = false

func _ready() -> void:
	if display_on_ready:
		display_cards.call_deferred(DeckManager.get_all_cards())
	else:
		
		#update pause manager
		PauseManager.add_menu(self)

func _exit_tree() -> void:
	
	#update pause manager
	PauseManager.remove_menu(self)

func display_cards(cards: Array[CardData], title_display: String = "Cards"):
	if card_container == null:
		return
	if card_button_scene == null:
		return
	if title_label == null:
		return
	
	#set menu title text
	title_label.text = title_display
	
	#create a card button instance for every card to be displayed
	for card in cards:
		var card_scene: CardButton = card_button_scene.instantiate()
		
		#add each instance to a grid container
		card_container.add_child(card_scene)
		
		#assign the card data resource to the card button instance
		card_scene.setup(card)
		
		#make the button invisible using modulate to prepare it for the entry animation
		card_scene.modulate.a = 0.0
		
		if tooltip_container:
			#give each card button a reference to the tooltip container so they can display tooltips when hovered over
			card_scene.tooltip_container = tooltip_container
	


func _on_close_button_pressed() -> void:
	close()

#menu closing animation
func _fade_out():
	var tween = create_tween()
	tween.set_ignore_time_scale(true)
	tween.tween_property(self, "modulate:a", 0.0, 0.15)
	tween.tween_callback(queue_free)

#menu closing sequence
func close():
	#update pause manager
	PauseManager.remove_menu(self)
	_fade_out()

func _input(_event: InputEvent) -> void:
	#close this menu when the "Esc" key is pressed
	if Input.is_action_just_pressed("ui_cancel") and PauseManager.is_current_menu(self) and PauseManager.state == PauseManager.State.PAUSED:
		close()

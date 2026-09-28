class_name CardInteractor
extends Node2D

signal CardCasted (card_data: CardData)

var card_manager: CardManager:
	get: return ManagerRegistry.get_manager("card_manager")

var game_manager: GameManager:
	get: return ManagerRegistry.get_manager("game_manager")

var selected_card: Card
var mouse_down_last_frame: bool
var mouse_down: bool

@export var drag_buffer_timer: Timer
var drag_buffer_threshold: float = 0.15
var cast_conditions_met: bool

#register this script to the service locator when it enters the scene tree
func _enter_tree() -> void:
	ManagerRegistry.register("card_interactor", self)

#remove this script from the service locator as it exits the scene tree
func _exit_tree() -> void:
	ManagerRegistry.unregister("card_interactor")

func _process(_delta: float) -> void:
	if drag_buffer_timer == null:
		return
	
	#check which card the mouse is currently hovered over
	var current_hover_card: Card = _get_selected_card()
	
	#if a hovered card is clicked, initiate drag logic
	if Input.is_action_just_pressed("left_click") and current_hover_card != null:
		mouse_down = !mouse_down
		
		#a buffer timer is used to allow for both click-and-drag and click-and-hover inputs
		#if the mouse button is held down for longer than the buffer duration, execute click-and-drag behavior
		#if the mouse button is held down for less time than the buffer duration (so a simple click), execute click-and-hover behavior
		drag_buffer_timer.start(drag_buffer_threshold)
	
	
	if not mouse_down:
		#if mouse button is not held down, execute hover behavior
		
		if current_hover_card != null:
			
			#as the mouse exits the bounds of a currently hovered card and enters the bounds of a new card, end the current card's hover state
			if selected_card != null and current_hover_card != selected_card:
				selected_card.hover_exit()
				selected_card = null
			
			#when a new card is hovered over, enter its hovered state
			if selected_card != current_hover_card:
				selected_card = current_hover_card
				selected_card.hover_enter()
				
		#as the mouse leaves the card bounds, end the current card's hover state
		elif selected_card != null:
			selected_card.hover_exit()
			selected_card = null
	
	#release mouse input if click-and-drag behavior was active
	if Input.is_action_just_released("left_click") and not drag_buffer_timer.time_left:
		mouse_down = false
	
	
	if mouse_down_last_frame and not mouse_down:
		#if the mouse button was just released, drop card
		_drop_card()
	elif not mouse_down_last_frame and mouse_down:
		#if the mouse button was just pressed, pick up card
		_pickup_card()
	
	#if a card is being dragged and right mouse button is clicked, drop the card back into your hand without casting it
	if Input.is_action_just_pressed("right_click"):
		_cancel_card()
	
	#if a card is dragged to the lower part of the screen, drop the card back into your hand without casting it
	if get_global_mouse_position().y > card_manager.card_origin.global_position.y - 10:
		_cancel_card()
	
	mouse_down_last_frame = mouse_down

func _get_selected_card() -> Card:
	
	#get the world 2d physics space state
	var mouse_pos = get_global_mouse_position()
	var space_state = get_world_2d().direct_space_state
	
	#generate a query to check if the mouse is currently intersecting with a card area2d
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = true
	
	var intersections = space_state.intersect_point(query)
	
	var card_to_select: Card = null
	var card_z_index = -1
	
	for result in intersections:
		var collider: Node2D = result['collider']
		
		#the cards are assigned different z indices when they are arranged in the hand
		#only select the card with the highest z index for consistency
		if collider is Card and collider.z_index > card_z_index:
			card_to_select = collider
			card_z_index = collider.z_index
	
	return card_to_select

func _pickup_card():
	if selected_card == null:
		return
	
	selected_card.drag_enter()

func _drop_card():
	if selected_card == null:
		return
	
	selected_card.drag_exit()
	
	cast_conditions_met = true
	
	#check card casting conditions
	
	#if the card is too low on the screen when dropped, cancel cast
	if selected_card.global_position.y > global_position.y + 20:
		return
	
	#if the card's energy cost is less than the player's current energy, cancel cast
	if game_manager.current_energy < selected_card.card_data.cost:
		cast_conditions_met = false
	
	#if the game has already ended, cancel cast
	if game_manager.game_over:
		cast_conditions_met = false
	
	#if the card's prerequisite conditions are not satisfied, cancel cast
	if not selected_card.card_data.check_cast_condition():
		cast_conditions_met = false
	
	#if the player has been defeated, cancel cast
	if game_manager.player.defeated:
		cast_conditions_met = false
	
	#if a cast is cancelled, flash the card red for visual feedback
	if not cast_conditions_met:
		selected_card.flash_red()
		return
	
	#if cast conditions are fulfilled, play the card
	CardCasted.emit(selected_card.card_data)
	game_manager.spend_energy(selected_card.card_data.cost)
	await selected_card.cast()
	
	#after the card has been played, send it to the discard pile
	card_manager.discard_card(selected_card)
	

func _cancel_card():
	if selected_card == null:
		return
	if selected_card.state != Card.States.DRAGGING:
		return
	
	selected_card.drag_exit()
	mouse_down = false

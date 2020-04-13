extends Node

onready var globals = get_node("/root/Globals")
onready var card = preload("res://Card.tscn")
onready var start_position = get_node("StartPosition")
onready var result_timer = get_node("ResultTimer")
onready var wrong_choice = get_node("WrongChoice")
onready var right_choice = get_node("RightChoice")

export var grid_x_size = 3
export var grid_y_size = 6
export var grid_x_space = 100
export var grid_y_space = 100

var cards = []


func _ready():
	globals.state = globals.GameStates.INIT

func _process(_delta: float):
	match globals.state:
		globals.GameStates.INIT:
			_init_game()

			globals.state = globals.GameStates.SELECTING_CARDS

		globals.GameStates.CLEANUP:
			_cleanup()

			if _is_all_cards_found():
				globals.state = globals.GameStates.END_GAME
			else:
				globals.state = globals.GameStates.SELECTING_CARDS

		globals.GameStates.SELECTING_CARDS:
			if _is_two_cards_selected():
				globals.state = globals.GameStates.CARDS_SELECTED

		globals.GameStates.CARDS_SELECTED:
			if _check_selected_cards_are_equal():
				right_choice.play()
				globals.should_mark_cards_found()
				globals.state = globals.GameStates.CLEANUP
			else:
				result_timer.start()
				globals.state = globals.GameStates.SHOWING_RESULT

		globals.GameStates.SHOWING_RESULT:
			pass
		globals.GameStates.END_GAME:
			_reload_scene()


func _init_game():
	if (grid_x_size * grid_y_size) % 2 != 0:
		print("Grid size isn't even", (grid_x_size * grid_y_size))
		get_tree().quit()

	var random_numbers = _get_shuffled_array()

	print("Random numbers", random_numbers)

	cards = _create_cards(random_numbers)
	for card in cards:
		add_child(card)


func _create_cards(numbers):
	var new_cards = []

	for y in range(grid_x_size):
		for x in range(grid_y_size):
			var new_card: Card = card.instance()
			new_card.position.x = start_position.position.x + grid_x_space * x
			new_card.position.y = start_position.position.y + grid_y_space * y
			new_card.card_number = numbers.pop_front()
			new_cards.push_back(new_card)

	return new_cards


func _get_shuffled_array():
	var numbers = []
	var middle = (grid_x_size * grid_y_size) / 2

	for i in range(1, middle + 1):
		numbers.push_back(i)

	for i in range(1, middle + 1):
		numbers.push_back(i)

	randomize()
	numbers.shuffle()

	return numbers


func _is_two_cards_selected():
	var count = 0
	for card in cards:
		if card.state == card.CardState.FACE_UP:
			count = count + 1

	return count >= 2


func _is_all_cards_found():
	var count = 0
	for card in cards:
		if card.state == card.CardState.FOUND:
			count = count + 1

	if count >= (grid_x_size * grid_y_size):
		return true
	else:
		return false


func _check_selected_cards_are_equal():
	var card1 = globals.selected_cards[0]
	var card2 = globals.selected_cards[1]

	return card1.card_number == card2.card_number


func _cleanup():
	globals.clean_selected_cards()


func _reset():
	_cleanup()
	cards.clear()


func _reload_scene():
	_reset()
	get_tree().reload_current_scene()


func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed('ui_cancel'):
		get_tree().quit(0)


func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit(0)


func _on_showing_result_ended():
	var card1 = globals.selected_cards[0]
	var card2 = globals.selected_cards[1]

	print("Cards selected not match %s and %s" % [card1.card_number, card2.card_number])

	if (card1.card_number != card2.card_number):
		card1.should_mark_face_down()
		card2.should_mark_face_down()
		wrong_choice.play()

	globals.state = globals.GameStates.CLEANUP

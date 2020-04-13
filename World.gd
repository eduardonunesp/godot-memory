extends Node

onready var globals = get_node("/root/Globals")
onready var card = preload("res://Card.tscn")
onready var start_position = get_node("StartPosition")

export var grid_x_size = 5
export var grid_y_size = 5
export var grid_x_space = 100
export var grid_y_space = 100


var cards = []

func _ready():
	var random_numbers = _get_random_numbers()
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

func _get_random_numbers():
	var numbers = []
	for i in range(1, (grid_x_size * grid_y_size) + 1):
		numbers.push_back(i)
	randomize()
	numbers.shuffle()
	return numbers

func _count_face_up_cards():
	var count = 0
	for card in cards:
		if card.state == card.CardState.FACE_UP:
			count = count + 1
	return count

func _process(delta: float):
	if (_count_face_up_cards() == 0):
		globals.state = globals.GameStates.NO_CARD_SELETED
	if (_count_face_up_cards() == 1):
		globals.state = globals.GameStates.FIRST_CARD_SELECTED
	if (_count_face_up_cards() == 2):
		globals.state = globals.GameStates.SECOND_CARD_SELECTED

	match globals.state:
		globals.GameStates.NO_CARD_SELETED:
			pass
		globals.GameStates.FIRST_CARD_SELECTED:
			pass
		globals.GameStates.SECOND_CARD_SELECTED:
			pass


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed('ui_cancel'):
		get_tree().quit(0)

func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit(0)

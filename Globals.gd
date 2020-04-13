extends Node

enum GameStates {
	INIT,
	CLEANUP,
	SELECTING_CARDS,
	CARDS_SELECTED,
	SHOWING_RESULT,
	END_GAME,
}

var state = GameStates.SELECTING_CARDS setget _set_state
var prev_state = state
var selected_cards = []

func clean_selected_cards():
	selected_cards.clear()

func should_mark_cards_face_down():
	for card in selected_cards:
		card.should_mark_face_down()

func should_mark_cards_found():
	for card in selected_cards:
		card.should_mark_found()

func _set_state(new_state):
	if new_state != state:
		prev_state = state
		state = new_state
		print("State changed from %s to %s" % [GameStates.keys()[prev_state], GameStates.keys()[new_state]])

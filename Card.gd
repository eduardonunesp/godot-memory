extends Area2D
class_name Card

signal face_changed(card_state)

onready var label = $Label
onready var number = $Number
onready var face_up = $FaceUp
onready var face_down = $FaceDown

enum CardState {
	FACE_UP,
	FACE_DOWN,
	FOUND,
}

export (CardState) var state = CardState.FACE_DOWN

var card_number = 0

func should_mark_found():
	print("Card %s found" % card_number)
	state = CardState.FOUND

func should_mark_face_down():
	print("Card %s is face down" % card_number)
	state = CardState.FACE_DOWN

func _process(_delta: float):
	match state:
		CardState.FACE_DOWN:
			_on_face_down()
		CardState.FACE_UP:
			_on_face_up()

	number.text = str(card_number)

func _on_face_down():
	face_up.visible = false
	number.visible = false
	label.text = "FACE DOWN"

func _on_face_up():
	face_up.visible = true
	number.visible = true
	label.text = "FACE UP"

func _on_card_clicked(_viewport: Node, event: InputEvent, _shape_idx: int):
	if Globals.state != Globals.GameStates.SELECTING_CARDS:
		return

	if (event is InputEventMouseButton && event.pressed):
		if state == CardState.FACE_DOWN:
			state = CardState.FACE_UP
			emit_signal("face_changed", state)
			Globals.selected_cards.push_back(self)
			print(self.card_number)
